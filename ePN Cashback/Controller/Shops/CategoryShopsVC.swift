//
//  CategoryShopsvC.swift
//  Backit
//
//  Created by Ivan Nikitin on 18/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class CategoryShopsVC: UIViewController {

    private var loadingFooterView : EPNLoadingFooterView!
    private let footerViewIdentifier = "searchFooterIdentifier"
    @IBOutlet weak var collectionView: UICollectionView!
    private let leftAndRightPaddings : CGFloat = 16
    private let spacingBetweenItems: CGFloat = 14
    private var numberOfItemPerRow: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIScreen.main.bounds.height <= 568 ? 2 : 3
        case .pad:
            return 5
        default:
            return 2
        }
    }
    private var refreshControl: UIRefreshControl!
    private var isFirstLayout = true
    private let identifier = "storeCell"
    var viewModel: FavoriteShopsModelType!
    private var observer: NSObjectProtocol?
    
    @IBOutlet weak var topPaddingOfCollectionView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action:
            #selector(refreshOffers(_:)),
                                 for: UIControl.Event.valueChanged)
        
        setUpNavigationBar()
        observer = NotificationCenter.default.addObserver(forName: .changedFavouriteStatusShop, object: nil, queue: .main, using: { [weak weakSelf = self] (notification) in
            print("changedFavouriteStatusShopInsideCategory in ")
            let currentShop = notification.object as! Store
            if let updatedIndexPath = weakSelf?.viewModel.updateList(by: currentShop) {
                weakSelf?.collectionView?.reloadItems(at: [updatedIndexPath])
            }
        })
        loadData()
        self.collectionView.register(EPNLoadingCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        self.collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .zurich
        self.view.backgroundColor = .zurich
    }
    
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }

    override func viewWillLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            self.navigationItem.searchController?.hairlineView?.isHidden = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
        if viewModel.hasBeenChanged() {
            NotificationCenter.default.post(name: .changedMainStoreList, object: nil)
        }
    }
    
    @objc private func refreshOffers(_ sender: Any) {
        loadData(isForced: true)
    }
    
    func setUpNavigationBar() {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        filterButton.setImage(UIImage(named: "sortBy")?.withRenderingMode(.alwaysOriginal), for: .normal)
        filterButton.addTarget(self, action:#selector(sortOfShopsTapped) , for: .touchUpInside)
        filterButton.setTitle(nil, for: .normal)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItems = [filterBarButton]
        navigationController?.navigationBar.barTintColor = .zurich
//        navigationController?.navigationBar.shadowImage = UIImage()
        title = viewModel.showTitle()
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLargeTitleDisplayMode(.never)
        refreshControl.endRefreshing()
    }
    
    @objc private func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    @objc func sortOfShopsTapped() {
        guard let viewModel = viewModel else { return }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionPopular = UIAlertAction(title: viewModel.prioritySortTitle, style: .default) { [weak self] (action) in
            self?.viewModel?.changeSorting(StatusOfSort.Priority)
            self?.loadData()
        }
        actionPopular.setValue(UIColor.sydney, forKey: "titleTextColor")
        let actionAlphabet = UIAlertAction(title: viewModel.alphaSortTitle, style: .default) { [weak self] (action) in
            self?.viewModel?.changeSorting(StatusOfSort.Alpha)
            self?.loadData()
        }
        actionAlphabet.setValue(UIColor.sydney, forKey: "titleTextColor")
        let actionNew = UIAlertAction(title: viewModel.newSortTitle, style: .default) { [weak self] (action) in
            self?.viewModel?.changeSorting(StatusOfSort.New)
            self?.loadData()
        }
        actionNew.setValue(UIColor.sydney, forKey: "titleTextColor")
        let type = viewModel.getSorting()
        switch type {
        case .Alpha:
            actionAlphabet.setValue(true, forKey: "checked")
        case .Priority:
            actionPopular.setValue(true, forKey: "checked")
        case .New:
            actionNew.setValue(true, forKey: "checked")
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        cancelAction.setValue(UIColor.sydney, forKey: "titleTextColor")
        alert.addAction(actionPopular)
        alert.addAction(actionAlphabet)
        alert.addAction(actionNew)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true)
    }
    
    func loadData(isForced: Bool = false) {
        viewModel.setActivePaging(true)
        viewModel.presentShops(isForced: isForced, completion: { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
            self?.collectionView.performBatchUpdates({
                self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
            }, completion: nil )
        }) { (errorCode) in
            Alert.showErrorToast(by: errorCode)
        }
    }
}

extension CategoryShopsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSections(in: collectionView, count: viewModel!.numberOfItems())
    }
    
    func numberOfSections(in collectionView: UICollectionView, count numOfSections: Int) -> Int {
        if numOfSections > 0 {
            collectionView.backgroundView = nil
        } else {
            setupContainer(inCollectionView: collectionView)
        }
        
        return numOfSections
    }
    
    func setupContainer(inCollectionView collectionView: UICollectionView) {
        let container: UIView = UIView(frame: CGRect(x: collectionView.frame.origin.x, y: collectionView.frame.origin.y, width: collectionView.frame.size.width, height: collectionView.frame.size.height))
        container.backgroundColor = UIColor.zurich
        let type = viewModel.getTypeOfResponse()
        switch type {
        case .empty:
            let imageView: UIImageView = UIImageView()
            let textLabel: EPNLabel = EPNLabel(style: .helperText)
            
            textLabel.text = viewModel.getTextForEmptyPage
            textLabel.font = .medium15
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            container.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            textLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 50).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30).isActive = true
            
            imageView.image = UIImage(named: "noFavoritesStores")
            imageView.contentMode = .scaleAspectFit
            container.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -10).isActive = true
        default:
            break
        }
        collectionView.backgroundView = container
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? StoreCardCollectionViewCell
        guard let cell = collectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.viewModel = viewModel.itemViewModel(at: indexPath.item)
        cell.storeCard.handlerLike = { [weak self] (likeButton, status) in
            likeButton.setStatusLiked(.inProgress)
            self?.viewModel.changeFavouriteStatus(index: indexPath.item, to: status) { [weak self] (updatedIndexPath) in
                guard let updatedIndexPath = updatedIndexPath else {
                    likeButton.setStatusLiked(status ? .notFavorite : .favorite)
                    return
                }
                self?.collectionView?.reloadItems(at: [updatedIndexPath])
            }
        }
        tryToLoadNextPage(indexPath: indexPath)
        return cell
    }
    
    func tryToLoadNextPage(indexPath: IndexPath)
    {
        if viewModel.canPagingForItem(at: indexPath) {
            viewModel.presentPage { [weak self] (paging) in
                guard let (size, start) = paging else {
                    self?.viewModel.setActivePaging(false)
                    return
                }
                if size > 0 {
                    print("completion of paging \(size) | \(start)")
                    self?.collectionView.performBatchUpdates({ [weak self] in
                        var indexPaths = [IndexPath]()
                        for index in 0..<size {
                            indexPaths.append(IndexPath(row: start+index, section: 0))
                        }
                        self?.collectionView.insertItems(at: indexPaths)
                    }, completion: nil)
                } else {
                    self?.viewModel.setActivePaging(false)
                    self?.collectionView.collectionViewLayout.invalidateLayout()      //for dismiss loading foolter
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: CGFloat(viewModel.sizeForLoadingFooter()))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width / numberOfItemPerRow) - leftAndRightPaddings - spacingBetweenItems/2
        let itemHeight = itemWidth + CGFloat(79)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: footerViewIdentifier,
                                                                             for: indexPath) as! EPNLoadingCollectionFooterView
            footerView.layoutIfNeeded()
            return footerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            viewModel.showShopDetailPage(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoreCardCollectionViewCell {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoreCardCollectionViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
}
