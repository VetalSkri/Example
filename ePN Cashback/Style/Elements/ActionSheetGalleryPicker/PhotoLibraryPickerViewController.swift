//
//  PhotoLibraryPickerViewController.swift
//  Backit
//
//  Created by Александр Кузьмин on 13/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIAlertController {
    
    /// Add PhotoLibrary Picker
    ///
    /// - Parameters:
    ///   - flow: scroll direction
    ///   - pagging: pagging
    ///   - images: for content to select
    ///   - selection: type and action for selection of image/images
    
    func addPhotoLibraryPicker(flow: UICollectionView.ScrollDirection, paging: Bool, selection: PhotoLibraryPickerViewController.Selection) {
        let selection: PhotoLibraryPickerViewController.Selection = selection
        var asset: PHAsset?
        var assets: [PHAsset] = []
        
        let vc = PhotoLibraryPickerViewController(flow: flow, paging: paging, selection: {
            switch selection {
            case .single(let action):
                return .single(action: { new in
                    asset = new
                    action?(asset)
                })
            case .multiple(_):
                return .multiple(action: { new in
                    assets = new
                })
            }
        }())
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.preferredContentSize.height = vc.preferredSize.height * 0.9
            vc.preferredContentSize.width = vc.preferredSize.width * 0.9
        } else {
            vc.preferredContentSize.height = vc.preferredSize.height
        }
        set(vc: vc)
    }
}

final class PhotoLibraryPickerViewController: UIViewController {
    
    public typealias SingleSelection = (PHAsset?) -> Swift.Void
    public typealias MultipleSelection = ([PHAsset]) -> Swift.Void
    
    public enum Selection {
        case single(action: SingleSelection?)
        case multiple(action: MultipleSelection?)
    }
    
    // MARK: UI Metrics
    
    var preferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100)
    }
    
    var itemSize: CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    // MARK: Properties
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.register(ItemWithImage.self, forCellWithReuseIdentifier: String(describing: ItemWithImage.self))
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.decelerationRate = UIScrollView.DecelerationRate.fast
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = true
        $0.backgroundColor = .clear
        $0.maskToBounds = false
        $0.clipsToBounds = false
        return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: layout))
    
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.sectionInset = .zero
        return $0
    }(UICollectionViewFlowLayout())

    fileprivate var selection: Selection?
    fileprivate var assets: [PHAsset] = []
    fileprivate var selectedAssets: [PHAsset] = []
    
    // MARK: Initialize
    
    required public init(flow: UICollectionView.ScrollDirection, paging: Bool, selection: Selection) {
        super.init(nibName: nil, bundle: nil)
        
        self.selection = selection
        self.layout.scrollDirection = flow
        
        self.collectionView.isPagingEnabled = paging
        
        switch selection {
            
        case .single(_):
            collectionView.allowsSelection = true
        case .multiple(_):
            collectionView.allowsMultipleSelection = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePhotos()
    }
    
    func updatePhotos() {
        checkStatus { [unowned self] assets in
            self.assets.removeAll()
            self.assets.append(contentsOf: assets)
            self.collectionView.reloadData()
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
                alert.addAction(title: NSLocalizedString("Close", comment: ""), style: .cancel) { [weak self] action in
                    self?.alertController?.dismiss(animated: true)
                }
                if let topVC = UIApplication.shared.topMostViewController() {
                    topVC.present(alert, animated: true)
                }
            }
        default:
            break
        }
    }
    
    func fetchPhotos(completionHandler: @escaping ([PHAsset]) -> ()) {
        Assets.fetch(assetFormatePredicate: NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)) { [unowned self] result in
            switch result {
                
            case .success(let assets):
                completionHandler(assets)
                
            case .error(let error):
                let alert = UIAlertController(style: .alert, title: "Error", message: error.localizedDescription)
                alert.addAction(title: "OK") { [unowned self] action in
                    self.alertController?.dismiss(animated: true)
                }
                alert.show()
            }
        }
    }
}

// MARK: - CollectionViewDelegate

extension PhotoLibraryPickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.item]
        switch selection {
        case .single(let action)?:
            action?(asset)
        case .multiple(let action)?:
            selectedAssets.contains(asset)
                ? selectedAssets.remove(asset)
                : selectedAssets.append(asset)
            action?(selectedAssets)
            
        case .none: break }
    }
}

// MARK: - CollectionViewDataSource

extension PhotoLibraryPickerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemWithImage.self), for: indexPath) as? ItemWithImage else { return UICollectionViewCell() }
        let asset = assets[indexPath.item]
        Assets.resolve(asset: asset, size: item.bounds.size) { new in
            item.imageView.image = new
        }
        return item
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension PhotoLibraryPickerViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
