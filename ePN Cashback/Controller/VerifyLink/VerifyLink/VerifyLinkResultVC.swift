//
//  VerifyLinkResultVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 25/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class VerifyLinkResultVC: UIViewController {

    var dynamicButton = EPNButton(style: .secondary, size: .large2)
    var goToShopButton = EPNButton(style: .primary, size: .large2)
    var scrollView = UIScrollView()
    
    private var contentView = UIView()
    private var countryInfoContainer = UIView()
    private var infoLabel = UILabel()
    private var cashBackAnotherView = UIView()
    private var cashBackAnotherLabel = UILabel()
    private var cashBackAnotherAmountLabel = UILabel()
    private var stackCountry = UIStackView()
    
    private var cashBackNotificationView = UIView()
    private var cashBackNotificationLabel = UILabel()
    private var cashBackNotificationImage = UIImageView()
    
    private var productLabel = UILabel()
    private var productCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    @IBOutlet weak var affiliateViewContainer: UIView!
    @IBOutlet weak var affiliateShopImage: UIRemoteImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var affiliatePercentLabel: UILabel!
    @IBOutlet weak var affiliateProductNameLabel: UILabel!
    @IBOutlet weak var affiliateLabel: UILabel!
    @IBOutlet weak var hotsale: EPNPaddingLabel!
    @IBOutlet weak var bottomStack: UIStackView!
    
    var viewModel: VerifyLinkResultModelType!
    
    private var countries: [String: UIImage] = [NSLocalizedString("flag_Russia", comment: ""):UIImage(named: "flag_russia")!, NSLocalizedString("flag_Tajikistan", comment: ""): UIImage(named: "flag_tajikistan")!,NSLocalizedString("flag_Turkmenistan", comment: ""): UIImage(named: "flag_tyrkmenistan")!,NSLocalizedString("flag_Uzbekistan", comment: ""):UIImage(named: "flag_uzbekistan")!, NSLocalizedString("flag_Azerbaijan", comment: ""):UIImage(named:"flag_azerbaijan")!,NSLocalizedString("flag_Kyrgyzstan", comment: ""):UIImage(named: "flag_kirgizstan")!,NSLocalizedString("flag_Moldova", comment: ""):UIImage(named: "flag_moldova")!,NSLocalizedString("flag_Armenia", comment: ""):UIImage(named:"flag_armenia")!,NSLocalizedString("flag_Belarus", comment:""):UIImage(named: "flag_belarus")!,NSLocalizedString("flag_Kazakhstan", comment: ""):UIImage(named: "flag_kazakhstan")!, NSLocalizedString("flag_Georgia", comment: ""):UIImage(named: "flag_georgia")!]
    
    private var stacksView: [UIStackView] = [UIStackView()]
    private var stackIndex: Int = 0
    private var stackInsertPosition: Int = 0
    private var affilate: Bool = false
    
    
    func setupBorder(view container: UIView, color: UIColor) {
        container.cornerRadius = 10
        container.shadowColor = .shadow
        container.shadowOffset = CGSize(width: 0, height: 0)
        container.layer.shadowRadius = 5.0
        container.shadowOpacity = 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setUpNavigationBar()
        setUpMainContainer()
        setUpButtonsContainer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        bottomStack.addArrangedSubview(dynamicButton)
        bottomStack.addArrangedSubview(goToShopButton)
        view.addSubview(scrollView)
        
        contentView.addSubview(cashBackNotificationView)
        
        cashBackNotificationView.addSubview(cashBackNotificationImage)
        cashBackNotificationView.addSubview(cashBackNotificationLabel)
        
        cashBackNotificationImage.image = UIImage(named: "history")
        cashBackNotificationLabel.text = NSLocalizedString("Cashback will appear in Orders section in 3-5 days", comment: "")
        cashBackNotificationView.cornerRadius = 8
        cashBackNotificationLabel.font = .semibold13
        cashBackNotificationLabel.textColor = .sydney
        cashBackNotificationLabel.numberOfLines = 0
        
        cashBackNotificationView.backgroundColor = UIColor(red: 0.71, green: 1, blue: 0.451, alpha: 0.4)
        
        contentView.addSubview(countryInfoContainer)
        countryInfoContainer.backgroundColor = .paris
        countryInfoContainer.cornerRadius = 8
        
        countryInfoContainer.addSubview(infoLabel)
        countryInfoContainer.addSubview(cashBackAnotherView)
        countryInfoContainer.addSubview(stackCountry)
        
        cashBackAnotherView.addSubview(cashBackAnotherLabel)
        cashBackAnotherView.addSubview(cashBackAnotherAmountLabel)
        
        countries.enumerated().forEach { index, elem in
            if index == 5 || index == 10 {
                stackIndex += 1
                stacksView.append(UIStackView())
                stackInsertPosition = 0
            }
            let view = CountryAliInfo()
            view.setup(flag: elem.value, name: elem.key)
            stacksView[stackIndex].insertArrangedSubview(view, at: stackInsertPosition)
            
            stacksView[stackIndex].distribution  = UIStackView.Distribution.fillEqually
            
            stacksView[stackIndex].spacing = 5.0
            stackInsertPosition += 1
        }
        stacksView.enumerated().forEach { index, elem in
            stackCountry.insertArrangedSubview(elem, at: index)
        }
        stackCountry.spacing = 20
        stackCountry.axis = .vertical
        cashBackAnotherView.backgroundColor = .white
        cashBackAnotherView.cornerRadius = 8
        
        cashBackAnotherLabel.text = NSLocalizedString("Cashback in Georgia and the CIS", comment: "")
        cashBackAnotherLabel.textColor = .moscow
        cashBackAnotherLabel.font = .medium13
        
        cashBackAnotherAmountLabel.text = viewModel.unaffiliatePercentCashbackTitle()
        cashBackAnotherAmountLabel.font = .semibold17
        cashBackAnotherAmountLabel.textColor = .moscow
        cashBackAnotherLabel.numberOfLines = 0
//        cashBackAnotherAmountLabel.numberOfLines = 0
        
        infoLabel.text = NSLocalizedString("Due to AliExpress terms you get cashback", comment: "")
        infoLabel.numberOfLines = 0
        infoLabel.font = .medium13
        infoLabel.textColor = .london
        
        affiliatePercentLabel.numberOfLines = 0
        contentView.addSubview(affiliateViewContainer)
        scrollView.addSubview(contentView)
        dynamicButton.handler = {[weak self] button in
            self?.showDynamicPriceTapped()
        }
    }
    
    private func setupConstraints() {
        dynamicButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        goToShopButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationController?.navigationBar.snp.bottom ?? self.view.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomStack.snp.top)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        cashBackNotificationView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
//            make.height.equalTo(200)
        }
        cashBackNotificationImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.left.equalToSuperview().inset(16)
        }
        cashBackNotificationLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(cashBackNotificationImage.snp.right).offset(8)
            make.bottom.equalToSuperview().inset(16)
        }
        affiliateViewContainer.snp.makeConstraints { (make) in
            if affilate {
                make.top.equalToSuperview().inset(16)
            } else {
                make.top.equalTo(cashBackNotificationView.snp.bottom).offset(16)
            }
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(self.view.frame.width - 32)
        }
        countryInfoContainer.snp.makeConstraints { (make) in
            make.top.equalTo(affiliateViewContainer.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        cashBackAnotherView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        cashBackAnotherLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(13)
        }
        cashBackAnotherAmountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.greaterThanOrEqualTo(cashBackAnotherLabel.snp.right).offset(3)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cashBackAnotherView.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        stackCountry.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
        }
        
    }
    
    private func showDynamicPriceTapped() {
        setDynamicButtonEnable(isEnable: false)
        viewModel?.priceDynamics(completion: { [weak self] in
            guard let strongSelf = self else { return }
            OperationQueue.main.addOperation {
                strongSelf.viewModel?.goOnDynamic()
                strongSelf.setDynamicButtonEnable(isEnable: true)
            }
        }, failure: { [weak self] (failureMessage) in
            OperationQueue.main.addOperation { [weak self] in
                self?.setDynamicButtonEnable(isEnable: true)
                guard let self = self else { return }
                if failureMessage == 422116 || failureMessage == 404003 {
                    self.viewModel?.goOnNoData()
                } else {
                    Alert.showErrorAlert(by: failureMessage, on: self)
                }
            }
        })
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setUpButtonsContainer() {
        goToShopButton.style = .primary
        goToShopButton.text = viewModel?.buttonInfoText
        goToShopButton.handler = { [weak self] (button) in
            self?.setGoToShopButtonEnable(isEnable: false)
            self?.viewModel?.openStore { (url) in
                OperationQueue.main.addOperation {
                    self?.setGoToShopButtonEnable(isEnable: true)
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
        }
        
        dynamicButton.text = viewModel.dynamicButtonInfoText
    }
    
    fileprivate func setGoToShopButtonEnable(isEnable: Bool) {
        self.goToShopButton.style = isEnable ? .secondary : .disabled
    }
    
    fileprivate func setDynamicButtonEnable(isEnable: Bool) {
        self.dynamicButton.style = isEnable ? .secondary : .disabled
    }
    
    fileprivate func setupHotsaleContainer() {
        
        affiliateViewContainer.isHidden = false
        countryInfoContainer.isHidden = true
        cashBackNotificationView.isHidden = true
        scrollView.isScrollEnabled = false
        affilate = true
        
        
        hotsale.textAlignment = .center
        hotsale.textColor = .zurich
        hotsale.font = .medium15
        hotsale.text = viewModel.hotSaleTitle
        hotsale.numberOfLines = 1
        hotsale.backgroundColor = .prague
        hotsale.layer.masksToBounds = true
        hotsale.layer.cornerRadius = CommonStyle.newCornerRadius
        
        affiliateShopImage.contentMode = .scaleAspectFit
        affiliateShopImage.loadImageUsingUrlString(urlString: viewModel.urlStringOfLeftLogo(), defaultImage: viewModel.defaultLogo())
        
        affiliatePercentLabel.textAlignment = .left
        affiliatePercentLabel.textColor = .prague
        affiliatePercentLabel.font = .bold20
        affiliatePercentLabel.text = viewModel.hotSalePercent()
        
        affiliateProductNameLabel.textAlignment = .left
        affiliateProductNameLabel.textColor = .london
        affiliateProductNameLabel.font = .medium13
        affiliateProductNameLabel.text = viewModel.productName()
        affiliateProductNameLabel.numberOfLines = 0
        
        affiliateLabel.numberOfLines = 1
        affiliateLabel.textAlignment = .center
        affiliateLabel.text = viewModel.affiliateMessage()
        affiliateLabel.textColor = .london
        affiliateLabel.font = .medium13
        
        hotsale.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        hotsale.layoutIfNeeded()
        hotsale.diagonalRoundCornersRight(cornerRadius: CommonStyle.newCornerRadius)
        affiliateViewContainer.layoutIfNeeded()
        
        setupBorder(view: affiliateViewContainer, color: .prague)
    }
    
    fileprivate func setupAnotherStoresContainer() {
        affiliateViewContainer.isHidden = false
        countryInfoContainer.isHidden = true
        cashBackNotificationView.isHidden = true
        scrollView.isScrollEnabled = false
        affilate = true
        
        hotsale.isHidden = true
        affiliateShopImage.contentMode = .scaleAspectFit
        affiliateShopImage.loadImageUsingUrlString(urlString: viewModel.urlStringOfLeftLogo(), defaultImage: viewModel.defaultLogo())
        
        affiliatePercentLabel.textAlignment = .left
        affiliatePercentLabel.textColor = .sydney
        affiliatePercentLabel.font = .bold20
        affiliatePercentLabel.text = viewModel.messageTitle()
        
        icon.isHidden = viewModel.productName() == "" ? false : true
        
        affiliateProductNameLabel.textAlignment = .left
        affiliateProductNameLabel.textColor = .london
        affiliateProductNameLabel.font = .medium13
        affiliateProductNameLabel.text = viewModel.productName()
        affiliateProductNameLabel.numberOfLines = 0
        
        affiliateLabel.numberOfLines = 1
        affiliateLabel.textAlignment = .center
        affiliateLabel.text = viewModel.affiliateMessage()
        affiliateLabel.textColor = .london
        affiliateLabel.font = .medium13
        
        affiliateViewContainer.layoutIfNeeded()
        
        setupBorder(view: affiliateViewContainer, color: . minsk)
    }
    
    fileprivate func setupAffiliateContainer(affiliate: Bool) {
        affiliateViewContainer.isHidden = false
        countryInfoContainer.isHidden = affiliate
        cashBackNotificationView.isHidden = affiliate
        hotsale.isHidden = true
        
        self.affilate = affiliate
        scrollView.isScrollEnabled = !affiliate
        
        affiliateShopImage.contentMode = .scaleAspectFit
        affiliateShopImage.loadImageUsingUrlString(urlString: viewModel.urlStringOfLeftLogo(), defaultImage: viewModel.defaultLogo())
        
        affiliatePercentLabel.textAlignment = .left
        affiliatePercentLabel.textColor = .sydney
        affiliatePercentLabel.font = .bold20
        affiliatePercentLabel.text = affiliate ? viewModel.messageTitle() : NSLocalizedString("Cashback is not credited for this product", comment: "")
        
        affiliateProductNameLabel.textAlignment = .left
        affiliateProductNameLabel.textColor = .london
        affiliateProductNameLabel.font = .medium13
        affiliateProductNameLabel.text = viewModel.productName()
        affiliateProductNameLabel.numberOfLines = 0
        
        affiliateLabel.numberOfLines = 1
        affiliateLabel.textAlignment = .center
        affiliateLabel.text = viewModel.affiliateMessage()
        affiliateLabel.textColor = .london
        affiliateLabel.font = .medium13
        
        affiliateViewContainer.layoutIfNeeded()
        
        setupBorder(view: affiliateViewContainer, color: . minsk)
    }
    
    func setUpMainContainer() {
        switch viewModel.affiliateStatus() {
        case 2:
            setupAffiliateContainer(affiliate: false)
        case 0:
            setupAnotherStoresContainer()
        case 1:
            if let isHot = viewModel.hotSaleStatus(), isHot {
                setupHotsaleContainer()
            } else {
                setupAffiliateContainer(affiliate: true)
            }
        default:
            break
        }
    }
    
    @objc func backButtonTapped() {
        viewModel?.goOnBack()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

class CountryAliInfo: UIView {
    private var flag = UIImageView()
    private var name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.addSubview(flag)
        self.addSubview(name)
        name.textAlignment = .center
        name.font = .medium10
        setupConstraints()
    }
    
    private func setupConstraints() {
        flag.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        name.snp.makeConstraints { (make) in
            make.top.equalTo(flag.snp.bottom).offset(3)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(48)
        }
    }
    
    public func setup(flag: UIImage, name: String) {
        self.flag.image = flag
        self.name.text = name
    }
}
