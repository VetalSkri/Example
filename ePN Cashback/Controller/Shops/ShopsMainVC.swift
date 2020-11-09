//
//  ShopsMainVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 01/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Toast_Swift

class ShopsMainVC: UIViewController {

    @IBOutlet weak var topPaddingOfTableView: NSLayoutConstraint!
    var viewModel: ShopsMainModelType!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var loadingFooterView : EPNLoadingFooterView!
    private let headerViewIdentifier = "headerViewIdentifier"
    private let headerViewHeight = 20
    private let expandedHeaderViewHeight = 140
    private let footerViewIdentifier = "searchFooterIdentifier"
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
    private let identifierOfSearchResultsShopsVC = "SearchResultsShopsVC"
    private let cellIdentifier = "storeCell"
    private let emptyStoreCell = "emptyStoreCell"
    private var refreshControl: UIRefreshControl!
    private var observerFavorite: NSObjectProtocol?
    private var observerChanges: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action:
            #selector(refreshOffers(_:)),
                                 for: UIControl.Event.valueChanged)
        
        title = NSLocalizedString("Stores", comment: "")
        setupBarButtons()
        setupSearch()
        self.collectionView.register(ShopsCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)
        self.collectionView.register(EPNLoadingCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        self.collectionView.refreshControl = refreshControl
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.reloadData()
        self.view.backgroundColor = .zurich
        self.collectionView.backgroundColor = .zurich
        observerFavorite = NotificationCenter.default.addObserver(forName: .changedFavouriteStatusShop, object: nil, queue: .main, using: { [weak weakSelf = self] (notification) in
            print("changedFavouriteStatusShopInsideCategory in ")
            let currentShop = notification.object as! Store
            if let updatedIndexPath = weakSelf?.viewModel.updateList(by: currentShop) {
                weakSelf?.collectionView?.reloadItems(at: [updatedIndexPath])
            }
        })
        observerChanges = NotificationCenter.default.addObserver(forName: .changedMainStoreList, object: nil, queue: .main, using: { [weak weakSelf = self] (_) in
            print("changeMainList by update")
            weakSelf?.loadData()
        })
        if viewModel.needUpdate {
            loadData()
            viewModel.loadUserBalance()
            viewModel.loadUserProfile()
        }
    }
    
    private func requestPushAuth() {
        Notifications.shared.requestAuthorization()
    }
    
    deinit {
        guard let observer = observerFavorite, let observerMain = observerChanges else { return }
        NotificationCenter.default.removeObserver(observer)
        NotificationCenter.default.removeObserver(observerMain)
    }

    func setUpNavigationBar() {
        setLargeTitleDisplayMode(.always)
        navigationController?.navigationBar.barTintColor = .zurich
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    private func setupBarButtons() {
        let faqButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        faqButton.setImage(UIImage(named: "infoReceipt")?.withRenderingMode(.alwaysOriginal), for: .normal)
        faqButton.addTarget(self, action:#selector(faqTapped) , for: .touchUpInside)
        faqButton.setTitle(nil, for: .normal)
        let favoriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        favoriteButton.setImage(UIImage(named: "favoriteNavBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        favoriteButton.addTarget(self, action:#selector(favoriteTapped) , for: .touchUpInside)
        favoriteButton.setTitle(nil, for: .normal)
        let categoryButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        categoryButton.setImage(UIImage(named: "category")?.withRenderingMode(.alwaysOriginal), for: .normal)
        categoryButton.addTarget(self, action:#selector(categoryTapped), for: .touchUpInside)
        categoryButton.setTitle(nil, for: .normal)
        let faqBarButton = UIBarButtonItem(customView: faqButton)
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        let categoryBarButton = UIBarButtonItem(customView: categoryButton)
        navigationItem.rightBarButtonItems = [faqBarButton, favoriteBarButton, categoryBarButton]
    }
    
    func setupSearch() {
        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: identifierOfSearchResultsShopsVC) as! SearchResultsShopsVC
        searchResultsController.viewModel = SearchShopsViewModel(router: viewModel.getRouter(), storeRepository: viewModel.getRepository())
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.delegate = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = NSLocalizedString("shop search placeholder", comment: "")
        textFieldInsideSearchBar?.font = .medium15
        textFieldInsideSearchBar?.textColor = .sydney
        textFieldInsideSearchBar?.tintColor = .sydney
        searchController.dimsBackgroundDuringPresentation = false
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = .clear
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        refreshControl?.endRefreshing()
        requestPushAuth()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl?.endRefreshing()
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc private func refreshOffers(_ sender: Any) {
        loadData(isForced: true)
    }
        
    @objc private func favoriteTapped(_ sender: Any) {
        viewModel.goOnFavorites()
    }
    
    @objc private func categoryTapped(_ sender: Any) {
        viewModel.goOnCategories()
    }
    
    @objc private func faqTapped(_ sender: Any) {
        viewModel.goOnFAQHowToBuy()
    }
    
    func loadData(isForced: Bool = false) {
        print("is loadData")
        viewModel.setActivePaging(true)
        viewModel.presentShops(isForced: isForced, completion: { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl?.endRefreshing()
        }) { (errorCode) in
            Alert.showErrorToast(by: errorCode)
        }
              
        self.viewModel.presentDoodles(completion: { [weak self] in
            if let headerView = self?.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? ShopsCollectionHeaderView {
                headerView.viewModel = self?.viewModel.headerViewModel()
            }
            self?.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
}
//MARK: -OfferCollectionView

extension ShopsMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 10, left: leftAndRightPaddings, bottom: 10, right: leftAndRightPaddings)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? StoreCardCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width / numberOfItemPerRow) - leftAndRightPaddings - spacingBetweenItems/2
        let itemHeight = itemWidth + CGFloat(79)
        return CGSize(width: itemWidth, height: itemHeight)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showShopDetailPage(at: indexPath.item)
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
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: CGFloat(viewModel.sizeForLoadingFooter()))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: (viewModel.hasDoodles() ? CGFloat(expandedHeaderViewHeight) : CGFloat(headerViewHeight)) )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: footerViewIdentifier,
                                                                             for: indexPath) as! EPNLoadingCollectionFooterView
            footerView.layoutIfNeeded()
            return footerView
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerViewIdentifier,
                                                                             for: indexPath) as! ShopsCollectionHeaderView
            headerView.viewModel = viewModel.headerViewModel()
            headerView.frame.size.height = (viewModel.hasDoodles() ? CGFloat(expandedHeaderViewHeight) : CGFloat(headerViewHeight))
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

