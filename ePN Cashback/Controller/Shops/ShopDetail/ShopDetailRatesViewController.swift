//
//  ShopDetailRatesViewController.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 23/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ShopDetailRatesViewController: UIViewController, SwipeUiViewController {
    
    private let cellId = "shopDetailRatesCellId"
    private var viewModel: ShopDetailViewModel!
    private var headerView: UIView!
    private var headerShopLogoImageVIew: UIRemoteImageView!
    private var waitTimeLabel: UILabel!
    private var waitTitleLabel: UILabel!
    private var clockImageView: UIImageView!
    private var bannerView: BannerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    func bindViewModel(viewModel: ShopDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .zurich
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.reloadData()
    }
    
    func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 0))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .zurich
        headerShopLogoImageVIew = UIRemoteImageView()
        headerView.addSubview(headerShopLogoImageVIew)
        headerShopLogoImageVIew.translatesAutoresizingMaskIntoConstraints = false
                
        if viewModel.isAliExpressShop {
            bannerView = BannerView()
            bannerView.title = viewModel.linkCheckerTitle
            bannerView.descriptionTitle = viewModel.linkCheckerDescription
            bannerView.buttonTitle = viewModel.lickCheckerButtonTitle
            bannerView.onButtonTapped = { [weak self] in
                self?.viewModel.openCheckLink()
            }
            
            headerView.addSubview(bannerView)
            
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
                bannerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                bannerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20)
            ])
            
            NSLayoutConstraint.activate([
                headerShopLogoImageVIew.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 48)
            ])
        } else {
            NSLayoutConstraint.activate([
                headerShopLogoImageVIew.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10)
            ])
        }
        
        headerShopLogoImageVIew.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        headerShopLogoImageVIew.widthAnchor.constraint(lessThanOrEqualToConstant: 176).isActive = true
        headerShopLogoImageVIew.heightAnchor.constraint(equalToConstant: 60).isActive = true
        headerShopLogoImageVIew.contentMode = .scaleAspectFit
        headerShopLogoImageVIew.backgroundColor = .white
        waitTitleLabel = UILabel()
        waitTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        waitTitleLabel.text = viewModel.confirmTitleText()
        waitTitleLabel.font = .medium15
        waitTitleLabel.textColor = .minsk
        waitTitleLabel.isHidden = true
        waitTimeLabel = UILabel()
        waitTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        waitTimeLabel.text = viewModel.confirmTime()
        waitTimeLabel.font = .medium15
        waitTimeLabel.textColor = .sydney
        
        clockImageView = UIImageView(image: UIImage(named: "confirmationTime")!)
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(clockImageView)
        clockImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        clockImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clockImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        clockImageView.isHidden = true
        
        let containerView = UIView()
        headerView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        containerView.centerYAnchor.constraint(equalTo: clockImageView.centerYAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: headerShopLogoImageVIew.bottomAnchor, constant: 5).isActive = true
        containerView.addSubview(waitTitleLabel)
        containerView.addSubview(waitTimeLabel)
        waitTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        waitTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        waitTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        waitTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        waitTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        waitTimeLabel.topAnchor.constraint(equalTo: waitTitleLabel.bottomAnchor, constant: 2).isActive = true
        waitTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        waitTimeLabel.numberOfLines = 2
        waitTitleLabel.numberOfLines = 2
        if (!(viewModel.actionText()?.isEmpty ?? true)) {
            let actionContainerView = UIView()
            actionContainerView.backgroundColor = .prague
            actionContainerView.cornerRadius = 5
            actionContainerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(actionContainerView)
            actionContainerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
            actionContainerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
            actionContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16).isActive = true
            actionContainerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
            actionContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 58).isActive = true
            let actionImageView = UIImageView(image: UIImage(named: "iconElevatedCb")!)
            actionImageView.translatesAutoresizingMaskIntoConstraints = false
            actionContainerView.addSubview(actionImageView)
            let actionDescriptionLabel = UILabel()
            actionDescriptionLabel.font = .medium15
            actionDescriptionLabel.textColor = .zurich
            actionDescriptionLabel.numberOfLines = 0
            actionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            actionContainerView.addSubview(actionDescriptionLabel)
            actionImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            actionImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            actionImageView.leadingAnchor.constraint(equalTo: actionContainerView.leadingAnchor, constant: 10).isActive = true
            actionImageView.centerYAnchor.constraint(equalTo: actionContainerView.centerYAnchor).isActive = true
            actionDescriptionLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 10).isActive = true
            actionDescriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: actionContainerView.topAnchor, constant: 10).isActive = true
            actionDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: actionContainerView.bottomAnchor, constant: -10).isActive = true
            actionDescriptionLabel.trailingAnchor.constraint(equalTo: actionContainerView.trailingAnchor, constant: -20).isActive = true
            actionDescriptionLabel.text = viewModel.actionText()
        } else {
            containerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        }
        
        waitTimeLabel.text = viewModel.confirmTime()
        waitTitleLabel.isHidden = false
        clockImageView.isHidden = false
        
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.layoutIfNeeded()
        headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        headerView.layoutIfNeeded()
        tableView.tableHeaderView = headerView
        headerShopLogoImageVIew.loadImageUsingUrlString(urlString: viewModel.logoSmall(), defaultImage: UIImage(named:"defaultStore")!)
        
    }
    
    func updateContent() {
        setupHeaderView()
        self.view.backgroundColor = .zurich
        tableView.reloadData()
    }
}

extension ShopDetailRatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRates()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ShopDetailRateTableViewCell
        cell.setupCell(rate: viewModel.rate(forIndexPath: indexPath))
        return cell
    }
}
