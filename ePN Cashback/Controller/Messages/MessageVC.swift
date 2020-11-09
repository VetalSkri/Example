//
//  MessageVC.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 14/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MessageModelType!
    @IBOutlet weak var topPaddingOfTableView: NSLayoutConstraint!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningImage: UIImageView!
    @IBOutlet weak var warningTitle: UILabel!
    @IBOutlet weak var warningDescription: UILabel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var loadingFooterView : EPNLoadingFooterView!
    private var footerViewHeight = 30
    private var searchBar : UISearchBar!
    private var scrollPosition : CGFloat?
    
    private let cellIdentifier = "messageCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupSearchBar()
        setupView()
        loadMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.commitReadFlags()
    }
    
    private func setupView() {
        
        loadingFooterView = EPNLoadingFooterView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(footerViewHeight)))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadingFooterView
        
        self.warningTitle.textColor = .sydney
        self.warningTitle.font = .bold17
        
        self.warningDescription.textColor = .sydney
        self.warningDescription.font = .medium15
        
        self.warningView.backgroundColor = .zurich
        self.view.backgroundColor = .zurich
        
        if !viewModel.hasMessages() {
            tableView.isHidden = true
            showNoNotificationsView()
        }
        
    }
    
    func setUpNavigationBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        title = viewModel.title
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.sydney,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        navigationController?.navigationBar.backgroundColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.barTintColor = .zurich
    }
    
    func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.isTranslucent = true
        navigationItem.searchController = searchController
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .paris
        textFieldInsideSearchBar?.placeholder = viewModel.keyWordsText
        textFieldInsideSearchBar?.font = .medium15
        textFieldInsideSearchBar?.textColor = .sydney
        textFieldInsideSearchBar?.tintColor = .sydney
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.minsk,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    @objc private func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    func showNoNotificationsView() {
        warningImage.image = UIImage(named: "zeroInterface")
        warningTitle.text = viewModel.noNotificationsYetText
        warningDescription.text = viewModel.notificationsWillBeDisplayText
        warningView.isHidden = false
    }
    
    func showNoSearchResultView() {
        warningImage.image = UIImage(named: "zeroInterface")
        warningTitle.text = viewModel.noNotificationsFoundText
        warningDescription.text = viewModel.tryToRefourmulateText
        warningView.isHidden = false
    }
    
    private func loadMessages() {
        viewModel.loadNextMessages(completion: {  [weak self] in
            if let self = self {
                self.tableView.reloadData()
                self.setupLoadFooterViewVisibility()
            }
        }) { (errorCode) in
        }
    }
    
    private func setupLoadFooterViewVisibility() {
        self.loadingFooterView.isHidden = self.viewModel.getAllIsLoad() || self.viewModel.searching()
    }
}

extension MessageVC: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        if endScrolling >= scrollView.contentSize.height {
            loadMessages()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.setupCell(title: viewModel.getItemTitle(forIndexPath: indexPath), body: viewModel.getItemBody(forIndexPath: indexPath), isRead: viewModel.getItemIsRead(forIndexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            viewModel.willDisplayItem(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.getSectionHeaderHeight())
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: CGFloat(viewModel.getSectionHeaderHeight())))
        let headLabel: UILabel = UILabel()
        headerView.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 20).isActive = true
        headLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        headLabel.textColor = .sydney
        headLabel.text = viewModel.titleForSection(section: section)
        headLabel.font = .medium15
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}

extension MessageVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        viewModel.search(withText: "", completion: nil, failure: nil)
        viewModel.setSearchingFlag(isSearching: true)
        searchBar.setShowsCancelButton(true, animated: true)
        setupLoadFooterViewVisibility()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        search(by: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        viewModel.setSearchingFlag(isSearching: false)
        search(by: "")
        searchBar.resignFirstResponder()
        setupLoadFooterViewVisibility()
    }
    
    func search(by title: String) {
        if !viewModel.hasMessages() {
            return
        }
        viewModel.search(withText: title, completion: { [weak self] in
            if let self = self {
                if(self.viewModel.numberOfSections() > 0) {
                    self.warningView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                } else {
                    self.tableView.isHidden = true
                    self.showNoSearchResultView()
                }
            }
        }) { (errorCode) in
            
        }
    }
    
}
