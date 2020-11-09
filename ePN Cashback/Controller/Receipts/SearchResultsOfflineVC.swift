//
//  SearchResultsOfflineVC.swift
//  Backit
//
//  Created by Ivan Nikitin on 14/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class SearchResultsOfflineVC: UITableViewController {
    
    private let MultyReceiptTableViewCell = "MultyReceiptTableViewCell"
    private var searchBar: UISearchBar?
    var viewModel: SearchOfflineModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        tableView.register(UINib(nibName: MultyReceiptTableViewCell, bundle: nil), forCellReuseIdentifier: MultyReceiptTableViewCell)
        tableView.backgroundColor = .zurich
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
        
        setLargeTitleDisplayMode(.always)
        navigationController?.navigationBar.barTintColor = .zurich
        
        viewModel.searchOfflineOffer.bind { [weak self] (store) in
            OperationQueue.main.addOperation {
                self?.tableView.reloadData()
                guard let searchBar = self?.searchBar else { return }
                searchBar.isLoading = false
            }
        }
    }
    
    
    deinit {
        viewModel.dispose()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MultyReceiptTableViewCell, for: indexPath) as! MultyReceiptTableViewCell
        cell.viewModel = viewModel.itemViewModel(for: indexPath.row)
        cell.backgroundColor = .zurich
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbersOfSections(in: tableView, count: viewModel.numberOfItems())
    }
    
    func numbersOfSections(in tableView: UITableView, count numOfItems: Int) -> Int {
        if numOfItems > 0 {
            tableView.backgroundView = nil
        } else {
            let container: UIView = UIView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height))
            container.backgroundColor = UIColor.zurich
            let type = viewModel.getTypeOfResponse()
            switch type {
            case .search:
                let imageView: UIImageView = UIImageView()
                let titleLabel: EPNLabel = EPNLabel(style: .titleHelperText)
                let textLabel: EPNLabel = EPNLabel(style: .helperText)
                
                
                textLabel.text = viewModel.getTextForEmptyPage
                textLabel.numberOfLines = 0
                textLabel.textAlignment = .center
                container.addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                textLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
                textLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 60).isActive = true
                textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
                textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
                
                titleLabel.text = viewModel.getTitleForEmptyPage
                titleLabel.numberOfLines = 1
                titleLabel.textAlignment = .center
                container.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
                titleLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -10).isActive = true
                titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
                
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
            tableView.backgroundView = container
        }
        return numOfItems
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? MultyReceiptTableViewCell {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) as? MultyReceiptTableViewCell {
                cell.transform = .identity
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? MultyReceiptTableViewCell {
            viewModel.goOnDetailPageForSelected(at: indexPath.row)
        }
    }
    
}
extension SearchResultsOfflineVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
        searchBar = searchController.searchBar
        viewModel.observerSearch.onNext(searchController.searchBar.text ?? "")
        if !searchController.isActive || searchController.isBeingPresented {
            searchBar?.isLoading = false
        }
    }
}

extension SearchResultsOfflineVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar?.isLoading = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.isLoading = true
    }
}
