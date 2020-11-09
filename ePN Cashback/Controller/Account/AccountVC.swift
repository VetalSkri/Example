//
//  AccountVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 16/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class AccountVC: UIViewController {

    //@IBOutlet weak var collectionView: UICollectionView!
    var viewModel: AccountMainModelType!
    private let leftAndRightPaddings : CGFloat = 40
    private var refreshControl: UIRefreshControl!
    private var tableHeaderView: UIView!
    
    private let accountMenuIdentifier = "accountMenuCell"
    private let headerIdentifier = "accountHeader"
    private let tableViewCellIdentifier = "accountMenuCellId"

    @IBOutlet weak var tableView: UITableView!
    private let goToExit = "goToExit"

    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorSpinner(UIColor.sydney)
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action:
            #selector(refreshAccountData(_:)),
                                 for: UIControl.Event.valueChanged)
        
        self.view.backgroundColor = .zurich
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        tableView.backgroundColor = .zurich
        tableView.tableFooterView = UIView()
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        setupHeaderView(viewModel.header(), tableHeaderView)
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        tableHeaderView.layoutIfNeeded()
        subscribeToNotificationCenter()
        updateUnreadCount()
    }
    
    deinit {
        unsubscribeFromNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
        ProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        refreshControl.endRefreshing()
    }
    
    private func subscribeToNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadUsetData), name: Notification.Name("NeedToUpdateUserData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUnreadCount), name: NSNotification.Name("updateUnreadCount"), object: nil)
    }
    
    private func unsubscribeFromNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshAccountData(_ sender: Any) {
        loadUsetData()
        updateUnreadCount()
    }
    
    @objc private func loadUsetData() {
        viewModel.header().loadUserData(completion: { [weak self] in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation { [weak self] in
                if let self = self {
                    self.refreshControl.endRefreshing()
                    self.setupHeaderView(self.viewModel.header(), self.tableHeaderView)
                }
            }
            }, failure: { [weak self] in
            ProgressHUD.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        })
    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .zurich
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let notificationsButton = UIButton(type: .system)
        if(viewModel.hasUnreadMessages()) {
            notificationsButton.setImage(#imageLiteral(resourceName: "notifications").withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            notificationsButton.setImage(#imageLiteral(resourceName: "noNotifications").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        notificationsButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        notificationsButton.addTarget(self, action: #selector(notificationsTapped), for: .touchUpInside)

        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal), for: .normal)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingsButton), UIBarButtonItem(customView: notificationsButton)]

        let faqButton = UIButton(type: .system)
        faqButton.setImage(#imageLiteral(resourceName: "accountMenu_faq").withRenderingMode(.alwaysOriginal), for: .normal)
        faqButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        faqButton.addTarget(self, action: #selector(faqTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: faqButton)
    }
    
    @objc func notificationsTapped() {
        viewModel.goOnNotifications()
    }
    
    @objc func settingsTapped() {
        viewModel.goOnSettings()
    }
    
    @objc func faqTapped() {
        viewModel.goOnFAQ()
    }
    
    func logout() {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure to logout?", comment: ""), message: nil, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: NSLocalizedString("Exit", comment: ""), style: .destructive) { [unowned self] (action) in
            self.viewModel.logout()
            alert.dismiss(animated: true)
        }
        let actionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        actionCancel.setValue(UIColor.sydney, forKey: "titleTextColor")
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    func setupHeaderView(_ viewModel: AccountMenuHeaderReusableViewModel, _ container: UIView){
        container.subviews.forEach({$0.removeFromSuperview()})
        let headerViewContainer = UIView()
        container.addSubview(headerViewContainer)
        
        headerViewContainer.backgroundColor = .zurich
        headerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        headerViewContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        headerViewContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        headerViewContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
        
        let mainProfileContainer = UIView()
        let mainBalanceContainer = UIView()
        
        headerViewContainer.addSubview(mainProfileContainer)
        mainProfileContainer.translatesAutoresizingMaskIntoConstraints = false
        mainProfileContainer.topAnchor.constraint(equalTo: headerViewContainer.topAnchor, constant: 0).isActive = true
        mainProfileContainer.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor, constant: 0).isActive = true
        mainProfileContainer.centerXAnchor.constraint(equalTo: headerViewContainer.centerXAnchor, constant: 0).isActive = true
        mainProfileContainer.backgroundColor = .zurich
        
        setupUserProfileView(currentViewModel: viewModel, mainProfileContainer)
        
        headerViewContainer.addSubview(mainBalanceContainer)
        mainBalanceContainer.translatesAutoresizingMaskIntoConstraints = false
        mainBalanceContainer.topAnchor.constraint(equalTo: mainProfileContainer.bottomAnchor, constant: 16).isActive = true
        mainBalanceContainer.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor, constant: 16).isActive = true
        mainBalanceContainer.centerXAnchor.constraint(equalTo: headerViewContainer.centerXAnchor, constant: 0).isActive = true
        mainBalanceContainer.bottomAnchor.constraint(equalTo: headerViewContainer.bottomAnchor, constant: -10).isActive = true
        mainBalanceContainer.backgroundColor = .zurich
        mainBalanceContainer.layer.cornerRadius = CommonStyle.cornerRadius
        mainBalanceContainer.layer.borderWidth = CommonStyle.borderWidth
        mainBalanceContainer.layer.borderColor = UIColor.montreal.cgColor

        setupBalanceView(currentViewModel: viewModel, mainBalanceContainer)
    }
    
    func setupUserProfileView(currentViewModel viewModel: AccountMenuHeaderReusableViewModel, _ container: UIView) {
        let userName = viewModel.userName() ?? ""
        let userPhotoImage = UIRemoteImageView()
        container.addSubview(userPhotoImage)
        userPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        userPhotoImage.isUserInteractionEnabled = true
        userPhotoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfileSettings)))
        userPhotoImage.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
        userPhotoImage.widthAnchor.constraint(equalToConstant: CommonStyle.imageProfileLogoWidth).isActive = true
        userPhotoImage.heightAnchor.constraint(equalTo: userPhotoImage.widthAnchor).isActive = true
        userPhotoImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        userPhotoImage.contentMode = .scaleAspectFit
        userPhotoImage.layer.masksToBounds = true
        userPhotoImage.layer.cornerRadius = CommonStyle.imageProfileLogoCornerRadius
        userPhotoImage.loadImageUsingUrlString(urlString: viewModel.urlStringOfLogo(), defaultImage: viewModel.defaultUserLogo())
        
        
        if !userName.isEmpty {
            let userNameLabel = UILabel()
            container.addSubview(userNameLabel)
            userNameLabel.translatesAutoresizingMaskIntoConstraints = false
            userNameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
            userNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
            userNameLabel.topAnchor.constraint(equalTo: userPhotoImage.bottomAnchor, constant: 10).isActive = true
            userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            userNameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
            userNameLabel.text = userName
            userNameLabel.textColor = .sydney
            userNameLabel.numberOfLines = 1
            userNameLabel.font = .semibold17
            userNameLabel.textAlignment = .center
        } else {
            userPhotoImage.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        }
        
    }
    
    func setupBalanceView(currentViewModel viewModel: AccountMenuHeaderReusableViewModel, _ container: UIView) {
        let button = EPNButton(style: .primary, size: .large1)
        container.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20).isActive = true
        
        if let countOfBalance = viewModel.numberOfAvailableBalance() {
            if countOfBalance > 0 {
                let balanceContainer = UIStackView()
                container.addSubview(balanceContainer)
                balanceContainer.translatesAutoresizingMaskIntoConstraints = false
                balanceContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
                balanceContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
                balanceContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true


                balanceContainer.axis = .horizontal
                balanceContainer.distribution = .fillEqually
                balanceContainer.alignment = .fill
                balanceContainer.spacing = 0

                let leftBalance = UIStackView()
                balanceContainer.addArrangedSubview(leftBalance)
                
                leftBalance.axis = .vertical
                leftBalance.distribution = .fill
                leftBalance.alignment = .leading
                leftBalance.spacing = 5
                
                let holdBalanceTitle = UILabel()
                leftBalance.addArrangedSubview(holdBalanceTitle)
                holdBalanceTitle.translatesAutoresizingMaskIntoConstraints = false
                holdBalanceTitle.heightAnchor.constraint(equalToConstant: 18).isActive = true
                
                holdBalanceTitle.numberOfLines = 1
                holdBalanceTitle.text = viewModel.holdBalanceTitle()
                holdBalanceTitle.textColor = .minsk
                holdBalanceTitle.font = .medium15
                
                let leftBalanceHold = UIStackView()
                leftBalance.addArrangedSubview(leftBalanceHold)
                
                leftBalanceHold.axis = .vertical
                leftBalanceHold.distribution = .fillEqually
                leftBalanceHold.alignment = .leading
                leftBalanceHold.spacing = 5
                
                let rightBalance = UIStackView()
                balanceContainer.addArrangedSubview(rightBalance)

                rightBalance.axis = .vertical
                rightBalance.distribution = .fill
                rightBalance.alignment = .leading
                rightBalance.spacing = 5

                let availableBalanceTitle = UILabel()
                rightBalance.addArrangedSubview(availableBalanceTitle)
                availableBalanceTitle.translatesAutoresizingMaskIntoConstraints = false
                availableBalanceTitle.heightAnchor.constraint(equalToConstant: 18).isActive = true
                
                availableBalanceTitle.numberOfLines = 1
                availableBalanceTitle.text = viewModel.availableBalanceTitle()
                availableBalanceTitle.textColor = .sydney
                availableBalanceTitle.font = .medium15

                let rightBalanceAvailable = UIStackView()
                rightBalance.addArrangedSubview(rightBalanceAvailable)

                rightBalanceAvailable.axis = .vertical
                rightBalanceAvailable.distribution = .fillEqually
                rightBalanceAvailable.alignment = .leading
                rightBalanceAvailable.spacing = 5

                button.style = .disabled
                
                for index in 0..<countOfBalance {
                    let availableBalance = UILabel()
                    let holdBalance = UILabel()
                    rightBalanceAvailable.addArrangedSubview(availableBalance)
                    leftBalanceHold.addArrangedSubview(holdBalance)
                    availableBalance.translatesAutoresizingMaskIntoConstraints = false
                    availableBalance.heightAnchor.constraint(equalToConstant: 20).isActive = true
                    holdBalance.translatesAutoresizingMaskIntoConstraints = false
                    holdBalance.heightAnchor.constraint(equalToConstant: 20).isActive = true
                    
                    
                    
                    availableBalance.numberOfLines = 1
                    availableBalance.text = viewModel.getTitleOfAvailableBalance(index)
                    availableBalance.textColor = .sydney
                    availableBalance.font = .bold17

                    holdBalance.numberOfLines = 1
                    holdBalance.text = viewModel.getTitleOfHoldBalance(index)
                    holdBalance.textColor = .minsk
                    holdBalance.font = .bold17
                    
                    if viewModel.getAvailableBalance(index) > 0 {
                        button.style = .primary
                    }
                }

                button.topAnchor.constraint(equalTo: balanceContainer.bottomAnchor, constant: 20).isActive = true
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
                button.heightAnchor.constraint(equalToConstant: 45).isActive = true
                
                //button.style = .enabledCR
//                button.fontSize = 16
                button.text = viewModel.buttonText()
                button.handler = { (button) in
                    viewModel.goOnOrderPayment()
                }
            } else {
                let infoLabel = UILabel()
                let navigatorButton = EPNLinkLabel(style: .full)
                container.addSubview(infoLabel)
                infoLabel.translatesAutoresizingMaskIntoConstraints = false
                infoLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
                infoLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
                infoLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
                infoLabel.numberOfLines = 0
                infoLabel.text = viewModel.infoText()
                infoLabel.textColor = .sydney
                infoLabel.font = .medium15
                infoLabel.textAlignment = .center

                container.addSubview(navigatorButton)
                navigatorButton.translatesAutoresizingMaskIntoConstraints = false
                navigatorButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10).isActive = true
//                navigatorButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
                navigatorButton.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
                navigatorButton.changeColorOfLink(for: viewModel.navigatorButtonText())
                navigatorButton.font = .medium15
                let tap = UITapGestureRecognizer(target: self, action: #selector(goToShop))
                navigatorButton.isUserInteractionEnabled = true
                navigatorButton.addGestureRecognizer(tap)
                
                button.topAnchor.constraint(equalTo: navigatorButton.bottomAnchor, constant: 20).isActive = true
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
                button.heightAnchor.constraint(equalToConstant: 45).isActive = true
                
                button.style = .disabled
                button.text = viewModel.buttonText()
//                button.fontSize = 16
            }
        } else {
            let infoLabel = UILabel()
            container.addSubview(infoLabel)
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            infoLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
            infoLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
            infoLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
            infoLabel.font = .medium15
            infoLabel.text = viewModel.errorInfoText()
            infoLabel.numberOfLines = 0
            infoLabel.textColor = .sydney
            infoLabel.textAlignment = .center
            infoLabel.sizeToFit()

            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            button.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10).isActive = true
            button.widthAnchor.constraint(equalToConstant: 190).isActive = true
            

            button.style = .secondary
            button.text = viewModel.buttonTryAgainText()
//            button.fontSize = 15
            
            button.handler = { [weak self] (button) in
                ProgressHUD.show()
                self?.loadUsetData()
            }
        }
    }
    
    //FIXME: - Change on XCoordinator
    @objc func goToShop() {
        guard let tabBarController = tabBarController else {
            return
        }
        guard let tapBarViewControllers = tabBarController.viewControllers else {
            return
        }
        guard let firstTapBarNavigationController = tapBarViewControllers[0] as? UINavigationController else {
            return
        }
        firstTapBarNavigationController.popToRootViewController(animated: false)
        tabBarController.selectedIndex = 0
    }
    
    @objc func openProfileSettings() {
        viewModel.goOnProfileSettings()
    }
    
    @objc func updateUnreadCount() {
        viewModel.getUnreadCount { [weak self] (success) in
            if success {
                self?.tableView.reloadData()
            }
        }
    }
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMenuItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! AccountMenuTableViewCell
        cell.setupCell(menuItem: viewModel.item(for: indexPath))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            logout()
        } else {
            viewModel.selectItem(at: indexPath)
        }
    }
 
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? AccountMenuTableViewCell {
                cell.transform = .init(scaleX: 0.9, y: 0.9)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? AccountMenuTableViewCell {
                cell.transform = .identity
            }
        })
    }
    
}
