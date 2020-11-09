//
//  AllCategoryVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 18/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Toast_Swift

class AllCategoryVC: UIViewController {

    var viewModel: AllCategoryModelType!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let categoryMenuIdentifier = "categoryMenuCell"
    private let identifierGoToShopsByCategory = "ShopListByCategoryVC"
    private var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = .sydney
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.refreshControl = refresher
        
        self.view.backgroundColor = .zurich
        loadData(isForced: true)
    }
    
    @objc private func refresh() {
        loadData(isForced: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLargeTitleDisplayMode(.never)
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc private func loadData(isForced: Bool = false) {
        viewModel.presentCategories(isForced: isForced, completion: { [weak self] in
            self?.refresher.endRefreshing()
            self?.tableView.reloadData()
        }) { [weak self] (errorCode) in
            self?.refresher.endRefreshing()
            Alert.showErrorToast(by: errorCode)
        }
    }
    
    func setUpNavigationBar() {
        title = NSLocalizedString(viewModel.headTitle, comment: "")
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney, NSAttributedString.Key.font : UIFont.semibold17]
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
}

extension AllCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryMenuIdentifier, for: indexPath) as! CategoryMenuViewCell
        cell.selectionStyle = .none
        cell.setupCell(category: viewModel.category(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let self = self, let cell = self.tableView.cellForRow(at: indexPath) as? CategoryMenuViewCell {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let self = self, let cell = self.tableView.cellForRow(at: indexPath) as? CategoryMenuViewCell {
                cell.transform = .identity
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goOnShops(atIndexPath: indexPath)
    }
    
}
