//
//  SearchResultsShopsVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 20/12/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchResultsShopsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var loadingFooterView : EPNLoadingFooterView!
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
    private let identifier = "storeCell"
    var viewModel: SearchShopsModelType!
    private var observer: NSObjectProtocol?
    private var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLargeTitleDisplayMode(.always)
        navigationController?.navigationBar.barTintColor = .zurich
        viewModel.searchStore.bind { [weak self] (store) in
            OperationQueue.main.addOperation {
                self?.collectionView.reloadData()
                guard let searchBar = self?.searchBar else { return }
                searchBar.isLoading = false
            }
        }
        observer = NotificationCenter.default.addObserver(forName: .changedFavouriteStatusShop, object: nil, queue: .main, using: { [weak weakSelf = self] (notification) in
            print("changedFavouriteStatusShopInsideSearch in ")
            let currentShop = notification.object as! Store
            if let updatedIndexPath = weakSelf?.viewModel.updateList(by: currentShop) {
                weakSelf?.collectionView?.reloadItems(at: [updatedIndexPath])
            }
        })
        self.view.backgroundColor = .zurich
        self.collectionView.register(EPNLoadingCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .zurich
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.hasBeenChanged() {
            NotificationCenter.default.post(name: .changedMainStoreList, object: nil)
        }
    }
    
    deinit {
        viewModel.dispose()
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSections(in: collectionView, count: viewModel.numberOfItems())
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
        container.backgroundColor = .zurich
        //TODO: Behaviours startSearching, not found shops
        let type = viewModel!.getTypeOfResponse()
        switch type {
        case .search:
            let imageView: UIImageView = UIImageView()
            let titleLabel: EPNLabel = EPNLabel(style: .titleHelperText)
            let textLabel: EPNLabel = EPNLabel(style: .helperText)
            
            titleLabel.text = viewModel!.getTitleForEmptyPage
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            container.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
            
            
            textLabel.text = viewModel!.getTextForEmptyPage
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            container.addSubview(textLabel)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
            
            imageView.image = UIImage(named: "noStores")
            imageView.contentMode = .scaleAspectFit
            container.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0).isActive = true
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10).isActive = true
        default:
            break
        }
        collectionView.backgroundView = container
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? StoreCardCollectionViewCell
        guard let cell = collectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.viewModel = viewModel.itemViewModel(at: indexPath.row)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showShopDetailPage(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: CGFloat(viewModel.sizeForLoadingFooter()))
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoreCardCollectionViewCell {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoreCardCollectionViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
}

extension SearchResultsShopsVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBar = searchController.searchBar
        viewModel.observerSearch.onNext(searchController.searchBar.text ?? "")
        if !searchController.isActive || searchController.isBeingPresented {
            searchBar?.isLoading = false
        }
    }
}

extension SearchResultsShopsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar?.isLoading = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.isLoading = true
    }
}
