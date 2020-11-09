//
//  InviteFriendsVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 20/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class InviteFriendsVC: UIViewController {

    var viewModel: InviteFriendsModelType!
    private var isFirstLayout = true
    var linkButton = EPNButton(style: .outline, size: .large1)
    
    private let mainContainer = UIView()
    private lazy var indicatorActivity: UIActivityIndicatorView = {
        let indicatorActivity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        indicatorActivity.color = .sydney
        return indicatorActivity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorSpinner(UIColor.sydney)
        
        if #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets.top = (self.navigationController?.navigationBar.frame.size.height)!
        }
        setUpNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            loadReferralLink()
            setUpMainInfo()
            loadStats()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        title = viewModel.headTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.zurich]
        navigationController?.navigationBar.barTintColor = .calgary
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backNavBar").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "faqWhite")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(infoTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func shareLink() {
        Analytics.inviteFriendsEventPressed()
        let activityController = UIActivityViewController(activityItems: [viewModel.shareReferralLink()!], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                Analytics.inviteFriendsEventPressedSuccess()
            }
        }
        if let popoverController = activityController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(activityController, animated: true)
        
    }
    
    func setUpMainInfo() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        self.view.backgroundColor = .zurich
        
        let headerViewContainer = UIView()
        headerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerViewContainer)
        headerViewContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        headerViewContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        headerViewContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        let headerImageView = Util.languageOfContent() == "ru" ? UIImageView(image: UIImage(named: "inviteFriendsHeaderRu")) : UIImageView(image: UIImage(named: "inviteFriendsHeaderEn"))
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.contentMode = .scaleAspectFit
        headerViewContainer.addSubview(headerImageView)
        headerImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        headerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        headerImageView.topAnchor.constraint(equalTo: headerViewContainer.topAnchor, constant: 20).isActive = true
        let headerTitleLabel = UILabel()
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.addSubview(headerTitleLabel)
        headerTitleLabel.textAlignment = .center
        headerTitleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 16).isActive = true
        headerTitleLabel.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor, constant: 20).isActive = true
        headerTitleLabel.trailingAnchor.constraint(equalTo: headerViewContainer.trailingAnchor, constant: -20).isActive = true
        headerTitleLabel.numberOfLines = 0
        let conditionView = UIView()
        conditionView.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.addSubview(conditionView)
        let conditionLabel = UILabel()
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        let conditionArrayImageView = UIImageView(image: UIImage(named: "rightConditions")!)
        conditionArrayImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionView.addSubview(conditionLabel)
        conditionView.addSubview(conditionArrayImageView)
        conditionLabel.leadingAnchor.constraint(equalTo: conditionView.leadingAnchor, constant: 20).isActive = true
        conditionLabel.topAnchor.constraint(equalTo: conditionView.topAnchor, constant: 5).isActive = true
        conditionLabel.bottomAnchor.constraint(equalTo: conditionView.bottomAnchor, constant: -5).isActive = true
        conditionLabel.trailingAnchor.constraint(equalTo: conditionArrayImageView.leadingAnchor, constant: 1).isActive = true
        conditionArrayImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        conditionArrayImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        conditionArrayImageView.trailingAnchor.constraint(equalTo: conditionView.trailingAnchor, constant: -20).isActive = true
        conditionArrayImageView.centerYAnchor.constraint(equalTo: conditionLabel.centerYAnchor, constant: 0).isActive = true
        conditionView.centerXAnchor.constraint(equalTo: headerViewContainer.centerXAnchor, constant: 0).isActive = true
        conditionView.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 11).isActive = true
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        headerViewContainer.addSubview(linkButton)
        linkButton.leadingAnchor.constraint(equalTo: headerViewContainer.leadingAnchor, constant: 20).isActive = true
        linkButton.trailingAnchor.constraint(equalTo: headerViewContainer.trailingAnchor, constant: -20).isActive = true
        linkButton.topAnchor.constraint(equalTo: conditionView.bottomAnchor, constant: 15).isActive = true
        linkButton.bottomAnchor.constraint(equalTo: headerViewContainer.bottomAnchor, constant: -20).isActive = true
        
        conditionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCondition)))
        
        headerViewContainer.backgroundColor = .calgary
        conditionView.backgroundColor = .clear
        headerTitleLabel.font = .bold17
        headerTitleLabel.textColor = .zurich
        conditionLabel.font = .medium15
        conditionLabel.textColor = .zurich
        
        headerTitleLabel.text = viewModel.infoText
        linkButton.changeTitleEdgeInsets()
        if let link = viewModel.shareReferralLink() {
            linkButton.text =  link
            linkButton.style = .outline
        } else {
            linkButton.style = .primary
            linkButton.text = NSLocalizedString("Try again", comment: "")
            
        }
        linkButton.contentMode = .center
        linkButton.handler = { [weak self] (button) in
            //TODO: REQUEST to check link
            if let _ = self?.viewModel.shareReferralLink() {
                self?.shareLink()
            } else {
                self?.loadReferralLink()
            }
        }
        
        headerTitleLabel.text = viewModel.infoText
        conditionLabel.text = viewModel.conditionText
        
        
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        
        let mainLabel = UILabel()
        let fullInfoButton = UIButton()
        
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(fullInfoButton)
        
        mainLabel.numberOfLines = 1
        mainLabel.text = viewModel.mainText
        mainLabel.textColor = .sydney
        mainLabel.font = .bold17
        
        fullInfoButton.setTitle(viewModel.buttonDetailText, for: .normal)
        fullInfoButton.setTitleColor(UIColor.minsk, for: .normal)
        fullInfoButton.titleLabel?.font = .medium15
        fullInfoButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        fullInfoButton.addTarget(self, action: #selector(showFullStatsDataTapped), for: .touchUpInside)
        fullInfoButton.widthAnchor.constraint(equalTo: mainLabel.widthAnchor, multiplier: 0.6, constant: 0).isActive = true
        
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: headerViewContainer.bottomAnchor, constant: 25).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        

        view.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        mainContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        mainContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        mainContainer.heightAnchor.constraint(equalToConstant: 106).isActive = true
        mainContainer.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -10).isActive = true
        
        mainLabel.text = viewModel.mainText
        mainContainer.backgroundColor = .zurich
        mainContainer.layer.masksToBounds = true
        mainContainer.layer.cornerRadius = CommonStyle.cornerRadius
        mainContainer.borderColor = .montreal
        mainContainer.borderWidth = CommonStyle.borderWidth
        
        setUpMainContainer()
    }
    
    func setUpMainContainer() {
        for view in mainContainer.subviews {
            view.removeFromSuperview()
        }
        let type = viewModel.getTypeOfResponse()
        switch type {
        case .loading:
            displayLoadingProcess()
        case .empty:
            displayEmptyMessageResponse()
        case .error:
            displayErrorResponse()
        case .notEmpty:
            displayRefferalsStats()
        }
    }
    
    func displayLoadingProcess() {
        print(displayLoadingProcess)
        mainContainer.addSubview(indicatorActivity)
        indicatorActivity.translatesAutoresizingMaskIntoConstraints = false
        indicatorActivity.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        indicatorActivity.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: 0).isActive = true
        indicatorActivity.startAnimating()
        
    }
    
    func displayEmptyMessageResponse() {
        let emptyMessageLabel = UILabel()
        emptyMessageLabel.textColor = .sydney
        emptyMessageLabel.font = .medium15
        emptyMessageLabel.numberOfLines = 0
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.text = viewModel.emptyStatsText
        
        mainContainer.addSubview(emptyMessageLabel)
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyMessageLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 20).isActive = true
        emptyMessageLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        emptyMessageLabel.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        emptyMessageLabel.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: 0).isActive = true
        
    }
    
    func displayErrorResponse() {
        let button = EPNButton(style: .secondary, size: .large2)
        mainContainer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -20).isActive = true
        
        let infoLabel = UILabel()
        mainContainer.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 20).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 20).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        infoLabel.font = .medium15
        infoLabel.text = viewModel.errorInfoText
        infoLabel.numberOfLines = 1
        infoLabel.textColor = .sydney
        infoLabel.textAlignment = .center
        infoLabel.sizeToFit()
        
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: 190).isActive = true

        button.text = viewModel.buttonTryAgainText
//        button.fontSize = 15
        button.handler = { [weak self] (button) in
            self?.loadStats()
        }
    }
    
    func displayRefferalsStats() {
        let referralsCountLabel = UILabel()
        let amountHoldLabel = UILabel()
        let amountTotalLabel = UILabel()
        
        let referralsCountValueLabel = UILabel()
        let amountHoldValueLabel = UILabel()
        let amountTotalValueLabel = UILabel()
        
        referralsCountLabel.textColor = UIColor.sydney
        referralsCountLabel.font = .medium15
        referralsCountLabel.numberOfLines = 1
        referralsCountLabel.contentMode = .left
        referralsCountLabel.text = viewModel.referralsCountText
        
        amountHoldLabel.textColor = .sydney
        amountHoldLabel.font = .medium15
        amountHoldLabel.numberOfLines = 1
        amountHoldLabel.contentMode = .left
        amountHoldLabel.text = viewModel.amountHoldTotalText
        
        amountTotalLabel.textColor = .sydney
        amountTotalLabel.font = .medium15
        amountTotalLabel.numberOfLines = 1
        amountTotalLabel.contentMode = .left
        amountTotalLabel.text = viewModel.amountTotalText
        
        referralsCountValueLabel.textColor = .sydney
        referralsCountValueLabel.font = .semibold15
        referralsCountValueLabel.numberOfLines = 1
        referralsCountValueLabel.contentMode = .right
        referralsCountValueLabel.text = viewModel.countOfReferrals()
        
        amountHoldValueLabel.textColor = .sydney
        amountHoldValueLabel.font = .semibold15
        amountHoldValueLabel.numberOfLines = 1
        amountHoldValueLabel.contentMode = .right
        amountHoldValueLabel.text = viewModel.holdAmount()
        
        amountTotalValueLabel.textColor = .sydney
        amountTotalValueLabel.font = .semibold15
        amountTotalValueLabel.numberOfLines = 1
        amountTotalValueLabel.contentMode = .right
        amountTotalValueLabel.text = viewModel.totalAmount()
        
        let statsContainer = UIStackView()
        mainContainer.addSubview(statsContainer)
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 16).isActive = true
        statsContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 16).isActive = true
        statsContainer.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor, constant: 0).isActive = true
        statsContainer.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor, constant: 0).isActive = true
        
        statsContainer.axis = .horizontal
        statsContainer.distribution = .fillEqually
        statsContainer.alignment = .fill
        statsContainer.spacing = 0
        
        let leftSideStackView = UIStackView()
        let rightSideStackView = UIStackView()
        
        leftSideStackView.axis = .vertical
        leftSideStackView.distribution = .fill
        leftSideStackView.alignment = .leading
        leftSideStackView.spacing = 10
        
        rightSideStackView.axis = .vertical
        rightSideStackView.distribution = .fill
        rightSideStackView.alignment = .trailing
        rightSideStackView.spacing = 10
        
        statsContainer.addArrangedSubview(leftSideStackView)
        statsContainer.addArrangedSubview(rightSideStackView)
        
        leftSideStackView.addArrangedSubview(referralsCountLabel)
        leftSideStackView.addArrangedSubview(amountTotalLabel)
        leftSideStackView.addArrangedSubview(amountHoldLabel)
        
        rightSideStackView.addArrangedSubview(referralsCountValueLabel)
        rightSideStackView.addArrangedSubview(amountTotalValueLabel)
        rightSideStackView.addArrangedSubview(amountHoldValueLabel)
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
//        dismiss(animated: true)
    }
    
    @objc func infoTapped() {
        viewModel.goOnFAQ()
//        let storyboard = UIStoryboard.init(name: "FAQ", bundle: nil)
//        let inviteFriendFaqVC = storyboard.instantiateViewController(withIdentifier: inviteFriendsFaqVcIdentifier)
//        let navController = UINavigationController(rootViewController: inviteFriendFaqVC)
//        navController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func showFullStatsDataTapped() {
        viewModel.goOnStatistic()
//        let storyboard = UIStoryboard(name: "ComingSoon", bundle: nil)
//        let comingSoonVC = storyboard.instantiateViewController(withIdentifier: "ComingSoonVC") as! ComingSoonVC
//        comingSoonVC.setPageType(type: .Statistic)
//        let rootNavigationController = UINavigationController(rootViewController: comingSoonVC)
//        rootNavigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(rootNavigationController, animated: true, completion: nil)
    }
    
    @objc func goToCondition() {
        OldAPI.performTranstionOnTheConditionStatsInviteFriends()
    }
    
    func loadStats() {
        ProgressHUD.show()
        viewModel.loadReferralsStats(completion: { [weak self] in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.setUpMainContainer()
            }
            }, failure: { [weak self] () in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.setUpMainContainer()
            }
        })
    }
    
    func loadReferralLink() {
        ProgressHUD.show()
        linkButton.isEnable = false
        viewModel.loadLink( completion: { [weak weakSelf = self] in
            OperationQueue.main.addOperation {
                ProgressHUD.dismiss()
                weakSelf?.linkButton.isEnable = true
                weakSelf?.linkButton.text = weakSelf?.viewModel.shareReferralLink()
                weakSelf?.linkButton.style = .outline
            }
        }, failure: { [weak weakSelf = self] (failureMessage) in
                OperationQueue.main.addOperation {
                    ProgressHUD.dismiss()
                    weakSelf?.linkButton.isEnable = true
                    weakSelf?.linkButton.style = .secondary
                    weakSelf?.linkButton.text = NSLocalizedString("Try again", comment: "")
                    guard let strongSelf = weakSelf else { return }
                    Alert.showErrorAlert(by: failureMessage, on: strongSelf)
                }
                print("The Error message, which should been arrived for user \(failureMessage)")
        })
    }
    
    func shopAlert(_ message: String) {
        let alert = UIAlertController(title: "\(message) Right now is not working", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func conditionsTapGesture(_ sender: Any) {
        
    }
    
    @IBAction func refferalLinkTapGesture(_ sender: Any) {
        
    }
    
}
