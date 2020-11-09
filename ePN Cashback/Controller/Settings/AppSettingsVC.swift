//
//  AppSettingsVC.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class AppSettingsVC: UIViewController {

    @IBOutlet var viewModel: AppSettingsViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningLabelBottomConstraint: NSLayoutConstraint!
    
    
    private let settingCellId = "settingsCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .zurich
        self.tableView.backgroundColor = .zurich
        setUpNavigationBar()
        setupTableView()
        setupView()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    private func setupView() {
        warningLabel.font = .medium15
        warningLabel.textColor = .sydney
        warningLabel.text = viewModel.warningText
        warningLabelBottomConstraint.constant = viewModel.isConfirmed() ?? false ? 0 : 10
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setUpNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    
}

extension AppSettingsVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 54))
        let headLabel: UILabel = UILabel()
        headerView.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 25).isActive = true
        headLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -11).isActive = true
        headLabel.textColor = .sydney
        headLabel.text = viewModel.getSectionName(forSection: section)
        headLabel.font = .bold17
        headerView.backgroundColor = .zurich
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath) as! SettingsTableViewCell
        cell.setupCell(title: viewModel.getTitleOfItem(forIndexPath: indexPath), description: viewModel.getDescriptionOfItem(forIndexPath: indexPath), checked: viewModel.getCheckedOfItem(forIndexPath: indexPath), type: viewModel.getTypeOfItem(forIndexPath: indexPath), isEmailConfirmed: viewModel.isConfirmed() ?? false)
        //for make separator line full width
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.selectedItem(atIndexPath: indexPath)
//        let cell = tableView.cellForRow(at: indexPath) as! SettingsTableViewCell
//        cell.checked()
    }
    
}

extension AppSettingsVC : SettingsTableViewCellDelegate {
    
    func switched(cellType: SettingItemType, toState: Bool) {
        ProgressHUD.show()
        viewModel.setSetting(ofType: cellType, toState: toState, completion: {
            OperationQueue.main.addOperation {
                ProgressHUD.dismiss()
            }
            
        }, behaviourHandle: {
            OperationQueue.main.addOperation {
                ProgressHUD.dismiss()
            }
        }) { [weak self] in
            OperationQueue.main.addOperation {
                ProgressHUD.dismiss()
                let selectedItemIndexPath = self?.viewModel.getIndexPathForItem(withType: cellType)
                if let selectedItemIndexPath = selectedItemIndexPath {
                    (self?.tableView.cellForRow(at: selectedItemIndexPath) as! SettingsTableViewCell).setSwitcher(isOn: !toState)
                }
            }
        }
    }
    
}
