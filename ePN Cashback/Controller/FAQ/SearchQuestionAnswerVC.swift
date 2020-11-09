//
//  SearchQuestionAnswerVC.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 20/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SearchQuestionAnswerVC: UITableViewController {

    var viewModel: SearchQuestionAnswerModelType!
    private let cellIdentifier = "answerCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        setupBottom()
    }
    
    func setupBottom() {
        let bottomInfoLabel = UILabel()
        let bottomImage = UIImageView()
        let bottomMainContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 226))
        let bottomContainerView = UIView()
        let bottomButtonToSupport = EPNButton(style: .primary, size: .medium)
        
        bottomMainContainer.addSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.topAnchor.constraint(equalTo: bottomMainContainer.topAnchor, constant: 11).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: bottomMainContainer.leadingAnchor, constant: 20).isActive = true
        bottomContainerView.centerXAnchor.constraint(equalTo: bottomMainContainer.centerXAnchor).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: bottomMainContainer.bottomAnchor, constant: -20).isActive = true
        bottomContainerView.backgroundColor = .toronto
        bottomContainerView.clipsToBounds = true
        bottomContainerView.layer.cornerRadius = CommonStyle.cornerRadius
        
        bottomContainerView.addSubview(bottomImage)
        bottomImage.translatesAutoresizingMaskIntoConstraints = false
        bottomImage.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20).isActive = true
        bottomImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bottomImage.widthAnchor.constraint(equalTo: bottomImage.heightAnchor).isActive = true
        bottomImage.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        bottomImage.image = UIImage(named: "toSupport")
        bottomImage.contentMode = .scaleAspectFit
        
        bottomContainerView.addSubview(bottomInfoLabel)
        bottomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoLabel.numberOfLines = 0
        bottomInfoLabel.topAnchor.constraint(equalTo: bottomImage.bottomAnchor, constant: 5).isActive = true
        bottomInfoLabel.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        bottomInfoLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20).isActive = true
        
        bottomInfoLabel.numberOfLines = 0
        bottomInfoLabel.text = viewModel.bottomInfoText
        bottomInfoLabel.textColor = .zurich
        bottomInfoLabel.font = .medium15
        bottomInfoLabel.textAlignment = .center
        
        bottomContainerView.addSubview(bottomButtonToSupport)
        bottomButtonToSupport.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonToSupport.topAnchor.constraint(equalTo: bottomInfoLabel.bottomAnchor, constant: 14).isActive = true
        bottomButtonToSupport.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        bottomButtonToSupport.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20).isActive = true
        bottomButtonToSupport.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bottomButtonToSupport.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -20).isActive = true
        bottomButtonToSupport.text = viewModel.buttonToSupportText
        bottomButtonToSupport.handler = { [weak self] (button) in
            self?.viewModel.goOnSupport()
        }
        tableView.tableFooterView = bottomMainContainer
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.countOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 54))
        let headLabel: UILabel = UILabel()
        headerView.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 25).isActive = true
        headLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -11).isActive = true
        headLabel.textColor = .sydney
        headLabel.text = viewModel.titleOfSection(section: section)
        headLabel.font = .bold17
        headerView.backgroundColor = .zurich
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCellIdentifier", for: indexPath) as! FaqTableViewCell
        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath) as? FAQCellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellDidSelected(cellIndexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}

extension SearchQuestionAnswerVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
        search(by: searchController.searchBar.text ?? "")
    }
    
    func search(by title: String) {
        viewModel.searchWithText(searchText: title)
        self.tableView.reloadData()
    }
    
}
