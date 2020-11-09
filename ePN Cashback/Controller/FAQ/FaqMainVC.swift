//
//  FaqVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 24/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD
import Lottie

class FaqMainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: FAQModelType!
    
    var refreshControl = UIRefreshControl()
    
    private var heightAtIndexPath = NSMutableDictionary()
    private var searchController: UISearchController!
    private lazy var bottomButtonToSupport: EPNButton = {
        let bottomButtonToSupport = EPNButton(style: .primary, size: .medium)
        bottomButtonToSupport.backgroundColor = #colorLiteral(red: 0.9403855801, green: 0.9484909177, blue: 1, alpha: 1)
        bottomButtonToSupport.clipsToBounds = true
        bottomButtonToSupport.layer.cornerRadius = CommonStyle.cornerRadius
        bottomButtonToSupport.text = viewModel.buttonToSupportText
        bottomButtonToSupport.handler = { [weak self] (button) in
            self?.viewModel.goOnSupport()
        }
        return bottomButtonToSupport
    }()
    
    private lazy var bottomInfoLabel: UILabel = {
        let bottomInfoLabel = UILabel()
        bottomInfoLabel.numberOfLines = 0
        bottomInfoLabel.text = viewModel.bottomInfoText
        bottomInfoLabel.textColor = UIColor.zurich
        bottomInfoLabel.font = UIFont.medium15
        bottomInfoLabel.textAlignment = .center
        return bottomInfoLabel
    }()
    
    private lazy var  bottomImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "toSupport")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var  bottomMainContainer: UIView = {
        let bottomMainContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 226))
        bottomMainContainer.backgroundColor = .zurich
        return bottomMainContainer
    }()
    
    private lazy var  bottomContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.toronto
        container.cornerRadius = CommonStyle.cornerRadius
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        if(viewModel.getType() == .normal){
            setupSearch()
        }
        self.tableView.backgroundColor = .zurich
        self.view.backgroundColor = .zurich
        setupTableViewHeader()
        setupBottom()
        ProgressHUD.show()
        loadData()
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        if(viewModel.getType() == .normal) {
            tableView.addSubview(refreshControl)
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.endRefreshing()
        ProgressHUD.dismiss()
    }
    
    func setupTableViewHeader() {
        if(viewModel.getType() == .normal) {
            let headerView = FaqTableViewHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 307))
            headerView.delegate = self
            tableView.tableHeaderView = headerView
        } else if(viewModel.getType() == .fromOfflineCB) {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
            headerView.backgroundColor = .zurich
            let tap = UITapGestureRecognizer(target: self, action:#selector(self.headerViewHandleTap(_:)))
            headerView.addGestureRecognizer(tap)
            let imageView = UIImageView(image: UIImage(named: "animation_preview"))
            imageView.frame = CGRect(x: 10, y: 0, width: self.view.frame.width-20, height: 300)
            imageView.contentMode = .scaleAspectFit
            headerView.addSubview(imageView)
            tableView.tableHeaderView = headerView
        } else if(viewModel.getType() == .webmasterInfo) {
            let headerView = UIView()
            let closeButton = UIButton()
            let headerImage = UIImageView(image: UIImage(named: "epnotForWebmaster"))
            let headerTitleLabel = UILabel()
            let headerDescriptionLabel = UILabel()
            headerView.addSubview(closeButton)
            headerView.addSubview(headerImage)
            headerView.addSubview(headerTitleLabel)
            headerView.addSubview(headerDescriptionLabel)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            headerImage.translatesAutoresizingMaskIntoConstraints = false
            headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            headerDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            closeButton.setTitle("", for: .normal)
            closeButton.setImage(UIImage(named: "Close"), for: .normal)
            closeButton.sizeToFit()
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -13).isActive = true
            closeButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 13).isActive = true
            closeButton.addTarget(self, action:#selector(closeButtonTapped), for: .touchUpInside)
            headerImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 13).isActive = true
            headerImage.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            headerTitleLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 10).isActive = true
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0).isActive = true
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0).isActive = true
            headerDescriptionLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 10).isActive = true
            headerDescriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0).isActive = true
            headerDescriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0).isActive = true
            headerDescriptionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -13).isActive = true
            headerImage.contentMode = .scaleAspectFit
            headerTitleLabel.numberOfLines = 0
            headerTitleLabel.font = .bold17
            headerTitleLabel.textAlignment = .center
            headerTitleLabel.textColor = .sydney
            headerTitleLabel.text = viewModel.yourAccountNotSuitableText
            headerDescriptionLabel.numberOfLines = 0
            headerDescriptionLabel.font = .medium15
            headerDescriptionLabel.textAlignment = .center
            headerDescriptionLabel.textColor = .sydney
            headerDescriptionLabel.text = viewModel.yourRegisterWebmasterAccountText
            tableView.tableHeaderView = headerView
        }
    }
    
    @objc func closeButtonTapped() {
        viewModel.goOnBack()
    }
    
    @objc func headerViewHandleTap(_ sender: UITapGestureRecognizer) {
        viewModel.goOnPopUpGuid()
    }
    
    @objc func refresh(sender:AnyObject) {
        loadData(fromRefreshControl: true)
    }
    
    func setupBottom() {
        if(viewModel.getType() == .webmasterInfo) {
            return
        }
        
        bottomMainContainer.addSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.topAnchor.constraint(equalTo: bottomMainContainer.topAnchor, constant: 11).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: bottomMainContainer.leadingAnchor, constant: 20).isActive = true
        bottomContainerView.centerXAnchor.constraint(equalTo: bottomMainContainer.centerXAnchor).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: bottomMainContainer.bottomAnchor, constant: -20).isActive = true
        
        bottomContainerView.addSubview(bottomImage)
        bottomImage.translatesAutoresizingMaskIntoConstraints = false
        bottomImage.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20).isActive = true
        bottomImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bottomImage.widthAnchor.constraint(equalTo: bottomImage.heightAnchor).isActive = true
        bottomImage.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        
        bottomContainerView.addSubview(bottomInfoLabel)
        bottomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoLabel.numberOfLines = 0
        bottomInfoLabel.topAnchor.constraint(equalTo: bottomImage.bottomAnchor, constant: 5).isActive = true
        bottomInfoLabel.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        bottomInfoLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20).isActive = true
        
        bottomContainerView.addSubview(bottomButtonToSupport)
        bottomButtonToSupport.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonToSupport.topAnchor.constraint(equalTo: bottomInfoLabel.bottomAnchor, constant: 14).isActive = true
        bottomButtonToSupport.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        bottomButtonToSupport.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20).isActive = true
        bottomButtonToSupport.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bottomButtonToSupport.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -20).isActive = true
        
        tableView.tableFooterView = bottomMainContainer
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setUpNavigationBar() {
        if(viewModel.getType() == .webmasterInfo) {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.setNavigationBarHidden(true, animated: false)
            return
        }
        navigationItem.hidesSearchBarWhenScrolling = false
        title = viewModel.titleFAQ
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.sydney,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        navigationController?.navigationBar.backgroundColor = .zurich
        navigationController?.navigationBar.view.backgroundColor = .zurich
        navigationController?.navigationBar.backgroundColor = .zurich
        navigationController?.view.backgroundColor = .zurich
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    @objc private func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    func setupSearch() {
        let searchResultsController = SearchQuestionAnswerVC.controllerFromStoryboard(.faq)
        searchResultsController.viewModel = viewModel.searchViewModel()
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.backgroundColor = .zurich
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = NSLocalizedString("EnterQuestion", comment: "")
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
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = .clear
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.endRefreshing()
    }
    
    func loadData(fromRefreshControl: Bool = false) {
        viewModel.loadData(forceRefresh: fromRefreshControl, completion: {
            [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                if self?.refreshControl.isRefreshing ?? false {
                    self?.refreshControl.endRefreshing()
                }
                ProgressHUD.dismiss()
                self?.tableView.reloadData()
            }
            }, failure: { [weak self] in
            ProgressHUD.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        })
    }
    
}

extension FaqMainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.getSectionHeaderHeight())
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 54))
        let headLabel: UILabel = UILabel()
        headerView.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -7).isActive = true
        headLabel.textColor = .sydney
        headLabel.text = viewModel.titleOfSection(inSection: section)
        headLabel.font = .bold17
        headerView.backgroundColor = .zurich
        return headerView
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.countOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(fromSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCellIdentifier", for: indexPath) as! FaqTableViewCell
        cell.backgroundColor = .zurich
        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath) as? FAQCellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellDidSelected(cellIndexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}

extension FaqMainVC : FaqTableViewHeaderViewDelegate {
    func cardViewSelected(cardViewIndex: Int) {
        switch cardViewIndex {
        case 1:
            viewModel.goOnFAQWhatIsCB()
//            pushViewController(storyboardName: "FAQ", viewControllerIdentifier: whatIsCbVcIdentifier)
            break
        case 2:
            viewModel.goOnHowToBuy()
//            pushViewController(storyboardName: "FAQ", viewControllerIdentifier: howToBuyWithCbVcIdentifier)
            break
        case 3:
            viewModel.goOnFAQWhatToDoAfter()
//            pushViewController(storyboardName: "FAQ", viewControllerIdentifier: whatToDoAfterVcIdentifier)
            break
        case 4:
            viewModel.goOnFAQHowOrderPayments()
//            pushViewController(storyboardName: "FAQ", viewControllerIdentifier: howOrderPaymentVcIdentifier)
            break
        case 5:
            viewModel.goOnIntroduction()
//            pushViewController(storyboardName: "FAQ", viewControllerIdentifier: introductionToTheAppVcIdentifier)
            break
        case 6:
            viewModel.goOnFAQRulesToBuy()
//            pushViewController(storyboardName: "FAQ", viewControllerIdentifier: rulesOfBuyVcIdentifier)
            break
        default:
            print("select undefined unknown card view index!")
            return
        }
    }
}

