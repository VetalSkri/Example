//
//  SearchResultsStocksVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 05/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

protocol SearchResultsStocksVCDelegate: class {
    func goodFilter() -> Int?
    func offerFilter() -> String?
    func searchCancelButtonClicked()
    func searchTextFieldDidBeginEditing()
}

class SearchResultsStocksVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    weak var filterDelegate : SearchResultsStocksVCDelegate?
    
    private let leftAndRightPaddings : CGFloat = 15
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
    private let identifier = "goodCell"
    private var observer: NSObjectProtocol?
    @IBOutlet var viewModel: SearchStocksViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorSpinner(UIColor.sydney)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSections(in: collectionView, count: viewModel.numberOfItemsInSection())
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SearchStockCardCollectionViewCell
        guard let cell = collectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.viewModel = viewModel.itemViewModel(forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width / numberOfItemPerRow) - leftAndRightPaddings
        let itemHeight = itemWidth + 137
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchStockCardCollectionViewCell {
            ProgressHUD.show()
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
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath)  as? SearchStockCardCollectionViewCell {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SearchStockCardCollectionViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
}

extension SearchResultsStocksVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
        self.filterDelegate?.searchTextFieldDidBeginEditing()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        guard let title = searchBar.text , title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            return
        }
        search(by: title)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        viewModel.clearSearchResult()
        self.collectionView?.reloadData()
        self.filterDelegate?.searchCancelButtonClicked()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func search(by title: String) {
        ProgressHUD.show()
        let filterGoods = filterDelegate?.goodFilter() ?? nil
        let filterOffers = filterDelegate?.offerFilter() ?? nil
        viewModel.findStocks(byTitle: title, filterGoods: filterGoods, filterOffers: filterOffers, completion: { [weak self] in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation { [weak self] in
                self?.collectionView?.reloadData()
            }
        }, failure: {
            ProgressHUD.dismiss()
        })
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
