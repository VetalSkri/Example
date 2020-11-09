//
//  ShopDetailViewController.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 22/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import QuartzCore
import SwipeMenuViewController
import Toast_Swift
import ProgressHUD

class ShopDetailViewController: UIViewController {
    
    // MARK: - ErrorConstants
    
    private enum ErrorConstants {
        static let offerDisabledCode = 422001
        static let offerDisabledMessage = NSLocalizedString("Offer is disabled", comment: "")
    }

    private var viewModel: ShopDetailViewModel!
    private var tabs = [UIViewController]()
    //Banner
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerBackgroundImageView: UIRemoteImageView!
    @IBOutlet weak var bannerMainImageView: UIRemoteImageView!
    @IBOutlet weak var bannerShopLogoImageView: UIRemoteImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    @IBOutlet weak var bannerSubtitleLabel: UILabel!
    //ShopInfo
    @IBOutlet weak var shopInfoView: UIView!
    @IBOutlet weak var shopLogoImageView: UIRemoteImageView!
    @IBOutlet weak var shopAverageWaitTimeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var shopWaitTimeValueLabel: UILabel!
    //SwipeView container
    @IBOutlet weak var swipeMenuView: SwipeMenuView!
    //Button
    var buyWithCbButton = EPNButton(style: .primary, size: .large1)
    var retryButton = EPNButton(style: .primary, size: .large1)
    
    private var favoriteTabButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Send event to analytic about Detail My Order info
        Analytics.detailStoreEventPressed()
        Analytics.detailStoreEventPressed(byTitle: viewModel.title())
        
        viewModel.sendOpenPageAnalytics()
        
        buyWithCbButton.text = NSLocalizedString("Buy with cashback", comment: "")
        
        retryButton.text = NSLocalizedString("Repeat", comment: "")
        setupSubviews()
        setupConstraints()
        setupNavigationBar(hasBanner: false)
        setupSwipeMenuView()
        loadData()
    }
    
    private func setupSubviews() {
        
        bottomView.addSubview(retryButton)
        bottomView.addSubview(buyWithCbButton)
        
        buyWithCbButton.handler = { [weak self] button in
            self?.buyWithCbButtonClicked()
        }
        retryButton.handler = { [weak self] button in
            self?.retryButtonClicked()
        }
    }
    
    private func setupConstraints() {
        buyWithCbButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        retryButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLargeTitleDisplayMode(.always)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setupSwipeMenuView() {
        let rateViewController = ShopDetailRatesViewController.controllerFromStoryboard(.shops)
        rateViewController.bindViewModel(viewModel: viewModel)
        let conditionViewController = ShopDetailConditionViewController.controllerFromStoryboard(.shops)
        conditionViewController.bindViewModel(viewModel: viewModel)
        tabs.append(rateViewController)
        tabs.append(conditionViewController)
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.addition = .underline
        
        options.tabView.itemView.font = .bold17
        options.tabView.itemView.selectedTextColor = .sydney
        options.tabView.itemView.textColor = .minsk
        
        options.tabView.additionView.backgroundColor = .sydney
        options.tabView.additionView.underline.height = 2
        options.tabView.backgroundColor = .zurich
        
        swipeMenuView.delegate = self
        swipeMenuView.dataSource = self
        swipeMenuView.reloadData(options: options, default: nil, isOrientationChange: false)
    }
    
    private func setupNavigationBar(hasBanner: Bool) {
        navigationController?.navigationBar.barTintColor = .zurich
//        navigationController?.navigationBar.shadowImage = UIImage()
        if hasBanner {
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        } else {
            title = viewModel.title()
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
        setupFavoriteBarButton()
    }
    
    private func setupFavoriteBarButton() {
        guard let favoriteButton = self.favoriteTabButton else {
            return
        }
        switch viewModel.favoriteState() {
        case .favorite:
            favoriteButton.image = UIImage(named: "favoriteOld")!.withRenderingMode(.alwaysOriginal)
            break;
        case .notFavorite:
            favoriteButton.image = UIImage(named: "notFavoriteStore")!.withRenderingMode(.alwaysOriginal)
            break
        case .inProgress:
            favoriteButton.image = UIImage(named: "favoriteInProgress")!.withRenderingMode(.alwaysOriginal)
            break
        }
    }
    
    @objc func favoriteButtonTapped() {
        switch viewModel.favoriteState() {
        case .favorite:
            viewModel.startFavoriteLoad()
            setupFavoriteBarButton()
            viewModel.changeFavouriteStatus(to: false) { [weak self] in
                self?.setupFavoriteBarButton()
            }
            break
        case .notFavorite:
            viewModel.startFavoriteLoad()
            setupFavoriteBarButton()
            viewModel.changeFavouriteStatus(to: true) { [weak self] in
                self?.setupFavoriteBarButton()
            }
            break
        case .inProgress:
            return
        }
    }
    
    func bindViewModel(viewModel: ShopDetailViewModel) {
        self.viewModel = viewModel
    }

    @objc func backButtonClicked() {
        viewModel.goOnBack()
    }
    
    private func loadData() {
        OperationQueue.main.addOperation {
            ProgressHUD.show()
            UIView.transition(with: self.buyWithCbButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.retryButton.isHidden = true
            })
        }
        self.viewModel.loadShopInfo(completion: { [weak self]  in
            ProgressHUD.dismiss()
            self?.favoriteTabButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(self?.favoriteButtonTapped))
            self?.navigationItem.rightBarButtonItem = self?.favoriteTabButton
            self?.setupView()
            self?.setupFavoriteBarButton()
            if let self = self {
                UIView.transition(with: self.buyWithCbButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.buyWithCbButton.isHidden = false
                })
            }
        }) { [weak self] (errorString) in
            ProgressHUD.dismiss()
            var toastStyle = ToastStyle()
            toastStyle.messageAlignment = .center
            toastStyle.messageFont = .medium13
            self?.view.makeToast(errorString, duration: 0.5, position: .bottom, style: toastStyle)
            if let self = self {
                UIView.transition(with: self.buyWithCbButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.retryButton.isHidden = false
                })
            }
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .zurich
        guard let viewModel = self.viewModel else { return }
        self.shopLogoImageView.loadImageUsingUrlString(urlString: viewModel.shopLogoUrl(), defaultImage: UIImage())
        self.shopWaitTimeValueLabel.text = viewModel.confirmTime()
        
        tabs.forEach { (viewController) in
            (viewController as? SwipeUiViewController)?.updateContent()
        }
        if viewModel.hasBanner() {
            bannerTitleLabel.text = viewModel.bannerTitle()
            bannerSubtitleLabel.text = viewModel.bannerSubtitle()
            bannerBackgroundImageView.loadImageUsingUrlString(urlString: viewModel.bannerBackground(), defaultImage: UIImage())
            bannerMainImageView.loadImageUsingUrlString(urlString: viewModel.bannerMainImage(), defaultImage: UIImage())
            bannerShopLogoImageView.loadImageUsingUrlString(urlString: viewModel.bannerShopLogo(), defaultImage: UIImage())
            setupNavigationBar(hasBanner: true)
            bannerView.isHidden = false
            bannerViewHeight.constant = 160
        } else {
            bannerViewHeight.constant = 0
            bannerView.isHidden = true
            setupNavigationBar(hasBanner: false)
        }
    }
    
    private func buyWithCbButtonClicked() {
        ProgressHUD.show()
        ///Send event to analytic about go to the Store
        Analytics.openTargetStoreEventPressed()
        viewModel.openStore(completion: { (url) in
            OperationQueue.main.addOperation {
                ProgressHUD.dismiss()
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }) { [weak self] (failureCode) in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation {
                guard let self = self else {
                    return
                }
                
                if failureCode == ErrorConstants.offerDisabledCode {
                    Alert.showErrorAlert(by: failureCode,
                                         message: ErrorConstants.offerDisabledMessage,
                                         on: self,
                                         okHandler: { [weak self] in
                        self?.viewModel.goOnBack()
                    })
                } else {
                    Alert.showErrorAlert(by: failureCode, on: self)
                }
            }
        }
    }
    
    private func retryButtonClicked() {
        loadData()
    }
    
}

extension ShopDetailViewController: SwipeMenuViewDelegate, SwipeMenuViewDataSource {

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        return tabs[index]
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return (index == 0) ? NSLocalizedString("Rates", comment: "") : NSLocalizedString("Conditions", comment: "")
    }

    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return tabs.count
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
