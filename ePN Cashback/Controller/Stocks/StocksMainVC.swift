//
//  StocksMainVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class StocksMainVC: UIViewController {

    @IBOutlet weak var topPaddingOfCollectionView: NSLayoutConstraint!
    var viewModel: StocksMainModelType!
    @IBOutlet weak var collectionView: UICollectionView!
    private let identifier = "stockCell"
    private let footerViewIdentifier = "loadFooterIdentifier"
    private let emptyFooterViewIdentifier = "emptyFooterIdentifier"
    private let stockFilterVcIdentifier = "StockFilterVC"
    private let leftAndRightPaddings : CGFloat = 15
    private let spacingBetweenItems: CGFloat = 14
    private var numberOfItemPerRow: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 2
        case .pad:
            return 4
        default:
            return 2
        }
    }
    private let identifierOfSearchResultsStoksVC = "SearchResultsStocksVC"
    private let headerIdentifier = "headerCell"
    private var searchController: UISearchController!
    private var refreshControl: UIRefreshControl!
    private var observer: NSObjectProtocol?
    private var sortButton: UIBarButtonItem!
    private var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorSpinner(UIColor.sydney)
        refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action:
            #selector(refreshStocks(_:)),
                                 for: UIControl.Event.valueChanged)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        setUpNavigationBar()
        setupSearch()
        
        self.collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(EPNLoadingCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: emptyFooterViewIdentifier)
        self.collectionView.backgroundColor = .zurich
        self.view.backgroundColor = .zurich
        
        
        ProgressHUD.show()
        loadStocks()
        observer = NotificationCenter.default.addObserver(forName: .percentRangeSelectedForStockFilters, object: nil, queue: .main, using: { [weak self](notification) in
            print("percentRangeSelectedForStockFilters in ")
            ProgressHUD.show()
            //TODO: condition to update shopFilter cause it can be nil
            guard let viewModel = self?.viewModel else { print("error viewModel nil"); return }
            if let filterTapped = notification.object as? StockFilter {
                viewModel.updateFilter(new: filterTapped)
            } else {
                viewModel.setDefaultFilter()
            }
            self?.loadStocks()
        })
        
    }
    
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setUpNavigationBar() {
        let sortButton = UIButton(type: .system)
        sortButton.setImage(UIImage(named: "sortBy")!.withRenderingMode(.alwaysOriginal), for: .normal)
        sortButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        sortButton.addTarget(self, action: #selector(sortOfStocksTapped), for: .touchUpInside)
        
        let filtersButton = UIButton(type: .system)
        if viewModel.hasActiveFilters() {
            filtersButton.setImage(UIImage(named: "appliedFilter")!.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            filtersButton.setImage(UIImage(named: "filters")!.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        filtersButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        filtersButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        self.filterButton = UIBarButtonItem(customView: filtersButton)
        self.sortButton = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItems = [self.sortButton, self.filterButton]

        navigationController?.navigationBar.barTintColor = .zurich
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupSearch() {
        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: identifierOfSearchResultsStoksVC) as! SearchResultsStocksVC
        searchResultsController.filterDelegate = self
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.delegate = searchResultsController
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .paris
        textFieldInsideSearchBar?.placeholder = NSLocalizedString("product search placeholder", comment: "")
        textFieldInsideSearchBar?.font = .medium15
        textFieldInsideSearchBar?.textColor = .sydney
        textFieldInsideSearchBar?.tintColor = .sydney
        setupSearchAttributes()
    }
    
    private func setupSearchAttributes() {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.minsk,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }
    
    @objc func filterButtonTapped() {
        viewModel.goOnFilter(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.endRefreshing()
        setupSearchAttributes()
        if searchController.isActive {
            searchController.searchResultsController?.viewWillAppear(animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
        ProgressHUD.dismiss()
    }
    
    @objc func sortOfStocksTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionPercent = UIAlertAction(title: viewModel.percentSort, style: .default) { [unowned self] (action) in
            self.viewModel.changeSorting(StatusOfSortStock.Percent)
            self.loadStocks()
        }
        actionPercent.setValue(UIColor.sydney, forKey: "titleTextColor")
        let actionCost = UIAlertAction(title: viewModel.costSort, style: .default) { [unowned self] (action) in
            self.viewModel.changeSorting(StatusOfSortStock.Orders)
            self.loadStocks()
        }
        actionCost.setValue(UIColor.sydney, forKey: "titleTextColor")
        let actionNewDate = UIAlertAction(title: viewModel.newDateSort, style: .default) { [unowned self] (action) in
            self.viewModel.changeSorting(StatusOfSortStock.New)
            self.loadStocks()
        }
        actionNewDate.setValue(UIColor.sydney, forKey: "titleTextColor")
        let type = viewModel.getSorting()
        switch type {
        case .Percent:
            actionPercent.setValue(true, forKey: "checked")
        case .Orders:
            actionCost.setValue(true, forKey: "checked")
        case .New:
            actionNewDate.setValue(true, forKey: "checked")
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        cancelAction.setValue(UIColor.sydney, forKey: "titleTextColor")
        alert.addAction(actionPercent)
        alert.addAction(actionCost)
        alert.addAction(actionNewDate)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true)
    }
    
    @objc private func refreshStocks(_ sender: Any) {
        loadStocks()
    }
    
    func loadStocks() {
        viewModel.loadListOfStocks(completion: { [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.scrollToTopCollectionView()
            }
            }, failure: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                    self?.refreshControl.endRefreshing()
                }
                OperationQueue.main.addOperation {
                    ProgressHUD.dismiss()
                }
        })
    }
    
    func scrollToTopCollectionView() {
        self.collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}

extension StocksMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSections(in: collectionView, count: viewModel.numberOfItemsInSection(section: section), currentSection: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView, count numOfSections: Int, currentSection section: Int) -> Int {
        if section != 0 {
            if numOfSections > 0 {
                collectionView.backgroundView = nil
            } else {
                setupContainer(inCollectionView: collectionView)
            }
        }
        return numOfSections
    }
    
    func setupContainer(inCollectionView collectionView: UICollectionView) {
        let container: UIView = UIView(frame: CGRect(x: collectionView.frame.origin.x, y: collectionView.frame.origin.y, width: collectionView.frame.size.width, height: collectionView.frame.size.height))
        container.backgroundColor = .zurich
        let type = viewModel.getTypeOfResponse()
        switch type {
        case .search:
            let emptyView = UIView()
            container.addSubview(emptyView)
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
            emptyView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
            emptyView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
            let imageView: UIImageView = UIImageView()
            let titleLabel: EPNLabel = EPNLabel(style: .titleHelperText)
            let textLabel: EPNLabel = EPNLabel(style: .helperText)
            
            titleLabel.text = viewModel.getTitleForEmptyPage
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            
            textLabel.text = viewModel.getTextForEmptySearchPage
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            
            imageView.image = UIImage(named: "noGoods")
            imageView.contentMode = .scaleAspectFit
            
            emptyView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyView.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: 0).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20).isActive = true
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20).isActive = true
            textLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 0).isActive = true
            
        case .empty:
            let emptyView = UIView()
            container.addSubview(emptyView)
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
            emptyView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
            emptyView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
            let imageView: UIImageView = UIImageView()
            let titleLabel: EPNLabel = EPNLabel(style: .titleHelperText)
            let textLabel: EPNLabel = EPNLabel(style: .helperText)
            
            titleLabel.text = viewModel.getTitleForEmptyPage
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            
            textLabel.text = viewModel.getTextForEmptyPage
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            
            imageView.image = UIImage(named: "noGoods")
            imageView.contentMode = .scaleAspectFit
            
            emptyView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyView.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: 0).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20).isActive = true
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20).isActive = true
            textLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 0).isActive = true
            
        default:
            break
        }

        collectionView.backgroundView = container
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let sectionHeaderView = collectionView.dequeueReusableCell(withReuseIdentifier: headerIdentifier, for: indexPath) as? StockHeaderReusableView
            guard let cell = sectionHeaderView else { return UICollectionViewCell() }
            cell.viewModel = viewModel.headerViewModel()
            return cell
        } else {
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? StockCardCollectionViewCell
            guard let cell = collectionViewCell else { return UICollectionViewCell() }
            cell.viewModel = viewModel.itemViewModel(forIndexPath: indexPath)
            cell.stockCard.handlerLike = {[weak self] (likeButton,  status) in
                likeButton.setStatusLiked(.inProgress)
            }
            tryToLoadNextPage(indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height:  CGFloat(143))
        } else {
            let itemWidth = (collectionView.bounds.width / numberOfItemPerRow) - leftAndRightPaddings - spacingBetweenItems/2
            let itemHeight = itemWidth + CGFloat(137)
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: leftAndRightPaddings, bottom: 10, right: leftAndRightPaddings)
        }
    }
    
    func tryToLoadNextPage(indexPath: IndexPath) {
        if viewModel.canPagingForItem(at: indexPath) {
            viewModel.pagingListOfStocks(completion: { [weak self] (start,size) in
                ProgressHUD.dismiss()
                if size > 0 {
                    print("completion of paging \(size) | \(start)")
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.performBatchUpdates({
                            var indexPaths = [IndexPath]()
                            for index in 0..<size {
                                indexPaths.append(IndexPath(row: start+index, section: 1))
                            }
                            self?.collectionView.insertItems(at: indexPaths)
                            self?.collectionView.reloadSections(IndexSet(integer: 0))
                            self?.collectionView.collectionViewLayout.invalidateLayout()
                        }, completion: nil)
                    }
                } else {
                    OperationQueue.main.addOperation { [weak self] in
                        self?.collectionView.collectionViewLayout.invalidateLayout()
                    }
                }
            }, failure: {
                    ProgressHUD.dismiss()
            })
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if let cell = collectionView.cellForItem(at: indexPath) as? StockCardCollectionViewCell {
                ProgressHUD.show()
                ///Send event to analytic about go to buy Promotion
                Analytics.openTargetPromotionEventPressed()
                cell.viewModel?.openStore(completion: { (url) in
                    OperationQueue.main.addOperation {
                        ProgressHUD.dismiss()
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                }, failure: { [weak self] (failureMessage) in
                    ProgressHUD.dismiss()
                    OperationQueue.main.addOperation { [weak self] in
                        if let self = self {
                            Alert.showErrorAlert(by: failureMessage, on: self)
                        }
                    }
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            UIView.animate(withDuration: 0.2) {
                if let cell = collectionView.cellForItem(at: indexPath) as? StockCardCollectionViewCell {
                    cell.transform = .init(scaleX: 0.95, y: 0.95)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            UIView.animate(withDuration: 0.2) {
                if let cell = collectionView.cellForItem(at: indexPath) as? StockCardCollectionViewCell {
                    cell.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(section != 1){
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: self.collectionView.frame.width, height: CGFloat(viewModel.isPaging ? viewModel.sizeForLoadingFooter() : 0 ) )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            if viewModel.isPaging {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: footerViewIdentifier,
                                                                                 for: indexPath) as! EPNLoadingCollectionFooterView
                footerView.layoutIfNeeded()
                return footerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: emptyFooterViewIdentifier,
                                                                                 for: indexPath) 
                footerView.frame = .zero
                footerView.layoutIfNeeded()
                return footerView
            }
            
        default:
            return UICollectionReusableView()
        }
    }
}

extension StocksMainVC : StockFilterVCDelegate {
    
    func applyFilters(filters: [StockFilterCategory]) {
        ProgressHUD.show()
        self.viewModel.setFilters(filters: filters)
        self.setUpNavigationBar()
        self.loadStocks()
    }
    
}

extension StocksMainVC : SearchResultsStocksVCDelegate {
    
    func goodFilter() -> Int? {
        return viewModel.getGoodFilter()
    }
    
    func offerFilter() -> String? {
        return viewModel.getOffersFilter()
    }
    
    func searchCancelButtonClicked() {
        navigationItem.rightBarButtonItems = [self.sortButton, self.filterButton]
        self.scrollToTopCollectionView()
    }
    
    func searchTextFieldDidBeginEditing() {
        navigationItem.rightBarButtonItems = nil
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
