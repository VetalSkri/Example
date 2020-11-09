//
//  SettingsMainVC.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SettingsMainVC: UIViewController {

    var viewModel: SettingsModelType!
    @IBOutlet weak var tableView: UITableView!
    private let settingCellIdentifier = "settingTableViewCellId"
    
    
    private let appSettingSegueIdentifier = "goToAppSettings"
    private let aboutAppSegueIdentifier = "goToAboutTheApp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .zurich
        self.tableView.backgroundColor = .zurich
        tableView.delegate = self
        tableView.dataSource = self
        setUpNavigationBar()
        setupView()
    }
    
    func setUpNavigationBar() {
        title = viewModel.settingsTitle
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupView() {
        
    }
    
    @objc private func backButtonTapped() {
        viewModel.goOnBack()
    }
    
}

extension SettingsMainVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellIdentifier, for: indexPath) as! SettingTableViewCell
        cell.setupCell(settingItem: viewModel.itemForRow(row: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        //Edit profile
        case 0:
            viewModel.goOnProfile()
            break;
        //App settings
        case 1:
            performSegue(withIdentifier: appSettingSegueIdentifier, sender: self)
            break;
        //About the app
        case 2:
            performSegue(withIdentifier: aboutAppSegueIdentifier, sender: self)
            break;
        default:
            print("Clicked on undefined and unknown menu item")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                cell.transform = .identity
            }
        })
    }
    
}
