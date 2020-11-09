//
//  ActionSheetGalleryPicket.swift
//  Backit
//
//  Created by Александр Кузьмин on 13/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit
import Photos

public typealias TelegramSelection = (TelegramSelectionType) -> ()

public enum TelegramSelectionType {
    
    case photo([PHAsset])
}

extension UIAlertController {
    
    /// Add Telegram Picker
    ///
    /// - Parameters:
    ///   - selection: type and action for selection of asset/assets
    
    func addTelegramPicker(selection: @escaping TelegramSelection) {
        let vc = TelegramPickerViewController(selection: selection)
        set(vc: vc)
    }
}



final class TelegramPickerViewController: UIViewController {
    
    
    var buttons: [ButtonType] {
        return selectedAssets.count == 0
            ? [.photoOrVideo]
            : [.sendPhotos]
    }
    
    enum ButtonType {
        case photoOrVideo
        case file
        case sendPhotos
        case sendAsFile
    }
    
    // MARK: UI
    
    struct UI {
        static let preferredContentHeight = 345
        static let rowHeight: CGFloat = 58
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8)
        static let minimumInteritemSpacing: CGFloat = 6
        static let minimumLineSpacing: CGFloat = 6
        static let maxHeight: CGFloat = 250 //UIScreen.main.bounds.width / 2
        static let multiplier: CGFloat = 2
        static let animationDuration: TimeInterval = 0.3
        static let photoCellWidth: CGFloat = UIScreen.main.bounds.width / 2.7
    }
    
    func title(for button: ButtonType) -> String {
        switch button {
        case .photoOrVideo: return NSLocalizedString("Send", comment: "")
        case .file: return "File"
        case .sendPhotos: return "\(NSLocalizedString("Send", comment: "")) \(selectedAssets.count) \(selectedAssets.count == 1 ? NSLocalizedString("Photo", comment: "") : NSLocalizedString("Photos", comment: ""))"
        case .sendAsFile: return "Send as File"
        }
    }
    
    func font(for button: ButtonType) -> UIFont {
        switch button {
        case .sendPhotos: return UIFont.boldSystemFont(ofSize: 20)
        default: return UIFont.systemFont(ofSize: 20) }
    }
    
    var preferredHeight: CGFloat {
        return UI.maxHeight / 1 /*(selectedAssets.count == 0 ? UI.multiplier : 1)*/ + UI.insets.top + UI.insets.bottom
    }
    
    func sizeFor(asset: PHAsset) -> CGSize {
        let height: CGFloat = UI.maxHeight
        let width: CGFloat = CGFloat(Double(height) * Double(asset.pixelWidth) / Double(asset.pixelHeight))
        return CGSize(width: width, height: height)
    }
    
    func sizeForItem(asset: PHAsset) -> CGSize {
        let size: CGSize = sizeFor(asset: asset)
//        if selectedAssets.count == 0 {
//            let value: CGFloat = size.height / UI.multiplier
//            return CGSize(width: value, height: value)
//        } else {
        return size
        //}
    }
    
    // MARK: Properties
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = UIScrollView.DecelerationRate.fast
        $0.contentInsetAdjustmentBehavior = .never
        $0.contentInset = UI.insets
        $0.backgroundColor = .clear
        $0.maskToBounds = false
        $0.clipsToBounds = false
        $0.register(ItemWithPhoto.self, forCellWithReuseIdentifier: String(describing: ItemWithPhoto.self))
        return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: layout))
    
    fileprivate lazy var layout: PhotoLayout = { [unowned self] in
        $0.delegate = self
        $0.lineSpacing = UI.minimumLineSpacing
        return $0
        }(PhotoLayout())
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorStyle = .none
        $0.backgroundColor = nil
        $0.bounces = false
        $0.tableHeaderView = collectionView
        $0.tableFooterView = UIView()
        $0.register(LikeButtonCell.self, forCellReuseIdentifier: LikeButtonCell.identifier)
        
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    lazy var assets = [PHAsset]()
    lazy var selectedAssets = [PHAsset]()
    
    var selection: TelegramSelection?
    
    // MARK: Initialize
    
    required init(selection: @escaping TelegramSelection) {
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width * 0.5
        }
        
        updatePhotos()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    
    func layoutSubviews() {
        tableView.tableHeaderView?.height = preferredHeight
        preferredContentSize.height = CGFloat(UI.preferredContentHeight)
    }
    
    func updatePhotos() {
        checkStatus { [weak self] assets in
            
            self?.assets.removeAll()
            self?.assets.append(contentsOf: assets)
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.collectionView.reloadData()
            }
        }
    }
    
    func checkStatus(completionHandler: @escaping ([PHAsset]) -> ()) {
        Log("status = \(PHPhotoLibrary.authorizationStatus())")
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            /// This case means the user is prompted for the first time for allowing contacts
            Assets.requestAccess { [unowned self] status in
                self.checkStatus(completionHandler: completionHandler)
            }
            
        case .authorized:
            /// Authorization granted by user for this app.
            DispatchQueue.main.async {
                self.fetchPhotos(completionHandler: completionHandler)
            }
            
        case .denied, .restricted:
            /// User has denied the current app to access the contacts.
            OperationQueue.main.addOperation {
                let alert = UIAlertController(style: .alert, title: NSLocalizedString("Permission denied", comment: ""), message: NSLocalizedString("Not have access to gallery. Please, allow the application to access to your photo library.", comment: ""))
                alert.addAction(title: NSLocalizedString("Close", comment: ""), style: .cancel) { [weak self] action in }
                if let topVC = UIApplication.shared.topMostViewController() {
                    topVC.present(alert, animated: true)
                }
            }
        default:
            break
        }
    }
    
    func fetchPhotos(completionHandler: @escaping ([PHAsset]) -> ()) {
        Assets.fetch(assetFormatePredicate: nil) { [weak self] result in
            switch result {
                
            case .success(let assets):
                completionHandler(assets)
                
            case .error(let error):
                Log("------ error")
                let alert = UIAlertController(style: .alert, title: "Error", message: error.localizedDescription)
                alert.addAction(title: "OK") { [weak self] action in
                    self?.alertController?.dismiss(animated: true)
                }
                alert.show()
            }
        }
    }
    
    private func showWarningAlert(title: String, subtitle: String) {
        let alert = UIAlertController(style: .alert, title: title, message: subtitle)
        alert.addAction(title: NSLocalizedString("Close", comment: ""), style: .cancel) { action in }
        if let topVC = UIApplication.shared.topMostViewController() {
            topVC.present(alert, animated: true)
        }
    }
    
    func action(withAsset asset: PHAsset, at indexPath: IndexPath) {
        //let previousCount = selectedAssets.count
        
        if selectedAssets.contains(asset) {
            selectedAssets.remove(asset)
        } else {
            if selectedAssets.count <= 2 {
                if getAssetSizeInMebabytes(asset: asset) > 15 {
                    showWarningAlert(title: "", subtitle: NSLocalizedString("No more than 15 Mb", comment: ""))
                    return
                }
                selectedAssets.append(asset)
            } else {
                showWarningAlert(title: "", subtitle: NSLocalizedString("3 photos maximum No more than 15 Mb", comment: ""))
            }
        }
        //selection?(TelegramSelectionType.photo(selectedAssets))
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        var indexPaths = indexPathsOfSelectedItems()
        if !indexPaths.contains(indexPath) {
            indexPaths.append(indexPath)
        }
        updateCellSelectionState(forIndexPaths: indexPaths)
        
        tableView.reloadData()
    }
    
    private func updateCellSelectionState(forIndexPaths: [IndexPath]) {
        forIndexPaths.forEach { (indexPath) in
            if let cell = collectionView.cellForItem(at: indexPath) as? ItemWithPhoto {
                cell.setupSelectedIndicator()
            }
        }
    }
    
    private func indexPathsOfSelectedItems() -> [IndexPath] {
        return selectedAssets.map { (asset) -> IndexPath in
            return IndexPath(row: assets.firstIndex(of: asset) ?? 0, section: 0)
        }
    }
    
    func action(for button: ButtonType) {
        switch button {
            
        case .photoOrVideo:
            break
            
        case .file:
            
            break
        case .sendPhotos:
            alertController?.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.selection?(TelegramSelectionType.photo(self.selectedAssets))
            }
            
        case .sendAsFile:
            
            break
        }
    }
    
    private func getAssetSizeInMebabytes(asset: PHAsset) -> Double {
        let resources = PHAssetResource.assetResources(for: asset)
        var sizeOnDisk: Int64 = 0
        if let resource = resources.first {
            if let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong {
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64))
            }
        }
        let result = (Double(sizeOnDisk) / 1000000.0)
        print("MYLOG: selected file size is: \(result)")
        return result
    }
}


// MARK: - TableViewDelegate
extension TelegramPickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        layout.selectedCellIndexPath = layout.selectedCellIndexPath == indexPath ? nil : indexPath
        action(withAsset: assets[indexPath.item], at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        action(withAsset: assets[indexPath.item], at: indexPath)
    }
}

// MARK: - CollectionViewDataSource
extension TelegramPickerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemWithPhoto.self), for: indexPath) as? ItemWithPhoto else { return UICollectionViewCell() }
        
        let asset = assets[indexPath.item]
        let size = sizeFor(asset: asset)
        
        item.setupView(asset: asset, rootVC: self)
        
        DispatchQueue.main.async {
            Assets.resolve(asset: asset, size: size) { new in
                item.imageView.image = new
            }
        }
        
        return item
    }
}

// MARK: - PhotoLayoutDelegate
extension TelegramPickerViewController: PhotoLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let size: CGSize = CGSize(width: UI.photoCellWidth, height: UI.maxHeight)//sizeForItem(asset: assets[indexPath.item])
        //Log("size = \(size)")
        return size
    }
}

// MARK: - TableViewDelegate
extension TelegramPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log("indexPath = \(indexPath)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.action(for: self.buttons[indexPath.row])
        }
    }
}

// MARK: - TableViewDataSource
extension TelegramPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeButtonCell.identifier) as! LikeButtonCell
        cell.textLabel?.font = font(for: buttons[indexPath.row])
        cell.textLabel?.text = title(for: buttons[indexPath.row])
        cell.textLabel?.isEnabled = !(buttons[indexPath.row] == .photoOrVideo)
        return cell
    }
}
