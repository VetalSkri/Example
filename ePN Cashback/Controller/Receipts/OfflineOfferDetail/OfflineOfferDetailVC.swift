//
//  OfflineOfferDetailVCViewController.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD
import Lottie
import markymark
import TransitionButton

class OfflineOfferDetailVC: UIViewController {
    
    @IBOutlet weak var headerLogoImageView: UIRemoteImageView!
    @IBOutlet weak var headerLogoLabel: UILabel!
    
    @IBOutlet weak var singleScanButton: TransitionButton!
    @IBOutlet weak var singleScanButtonContainerView: UIView!
    
    @IBOutlet weak var multiScanButton: UIView!
    
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var averageTimeValueLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionsMarkdownView: MarkDownTextView!
    
    @IBOutlet weak var multiScanButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var singleScanButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratesContainerView: UIView!
    @IBOutlet weak var ratesLabel: UILabel!
    @IBOutlet weak var ratesStackViewContainer: UIStackView!
    
    private var viewModel: OfflineOfferDetailViewModel!
    
    private var animationView = AnimationView(name: "scan_button_animation")
    
    private var observer: NSObjectProtocol?
    
    func bindViewModel(viewModel: OfflineOfferDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        observer = NotificationCenter.default.addObserver(forName: viewModel.getKeyNotificationName(), object: nil, queue: .main, using: { [weak weakSelf = self] (notification) in
            print("qrcode string after scan or manually enter DetailPageVC")
            guard let qrcode = notification.object as? String else { return }
            print("qrcode is \(qrcode) ")
            ProgressHUD.show()
            weakSelf?.viewModel.displayResult(qrString: qrcode) {
                ProgressHUD.dismiss()
            }
            
        })
        setupView()
        setupMarkdownStyle()
        loadData()
        addAnimationOnScanButton()
        
        viewModel.sendOpenPageAnalytics()
    }
    
    private func loadData() {
        singleScanButton.startAnimation()
        viewModel.showOfflineOfferInfo(completion: { [weak self] in
                if let self = self {
                    self.singleScanButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.3) {
                        self.showButton()
                        self.singleScanButton.setTitle(self.viewModel.scanButtonText, for: .normal)
                    }
                    self.averageTimeValueLabel.text = self.viewModel.averageTimeValue
                    self.setupView()
                    self.setupConditionContainer()
                    self.setupRatesContainer()
                    self.headerLogoImageView.loadImageUsingUrlString(urlString: self.viewModel.offerHeaderImageUrl, defaultImage: UIImage())
                }
        }) { [weak self] (errorCode) in
            self?.singleScanButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3) {
                self?.showButton()
            }
            Alert.showErrorToast(by: errorCode)
        }
    }
    
    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLargeTitleDisplayMode(.never)
        multiScanButton.backgroundColor = .sydney
        animationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        multiScanButton.layer.removeAnimation(forKey: "hoverAnimation")
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupView() {
        view.backgroundColor = .zurich
        headerLogoLabel.font = .bold20
        headerLogoLabel.textColor = .sydney
        headerLogoLabel.adjustsFontSizeToFitWidth = true
        headerLogoLabel.minimumScaleFactor = 0.5
        headerLogoLabel.text = viewModel.titleText
        headerLogoLabel.numberOfLines = 0

        singleScanButton.backgroundColor = .sydney
        singleScanButtonContainerView.backgroundColor = .zurich
        singleScanButton.setTitleColor(.zurich, for: .normal)
        singleScanButton.titleLabel?.font = UIFont.semibold15
        singleScanButton.setTitle(viewModel.repeatText, for: .normal)
        
        ratesLabel.text = viewModel.cashbackText
        conditionLabel.text = viewModel.conditionsText
        ratesLabel.textColor = .moscow
        conditionLabel.textColor = .moscow
        ratesLabel.font = .semibold17
        conditionLabel.font = .semibold17
        
//        averageTimeLabel.font = .medium13
        averageTimeLabel.textColor = .minsk
        averageTimeLabel.text = viewModel.averageTimeText
        
//        averageTimeValueLabel.font = .semibold13
        averageTimeValueLabel.textColor = .moscow
        
        ratesContainerView.cornerRadius = CommonStyle.newCornerRadius
        ratesContainerView.borderWidth = 1
        ratesContainerView.borderColor = .montreal
        
        ratesStackViewContainer.axis = .vertical
        ratesStackViewContainer.distribution = .fill
        ratesStackViewContainer.alignment = .fill
        ratesStackViewContainer.spacing = 10
        multiScanButtonBottomConstraint.constant = 150
        singleScanButtonBottomConstraint.constant = 0
        
    }
    
    private func setupMarkdownStyle() {
        conditionsMarkdownView.backgroundColor = .zurich
        
        conditionsMarkdownView.styling.headingStyling.textColorsForLevels = [
            .sydney, //H1 (i.e. # Title)
            .sydney, //H2, ... (i.e. ## Subtitle, ### Sub subtitle)
            .sydney  //H3
        ]
        conditionsMarkdownView.styling.headingStyling.isBold = true

        conditionsMarkdownView.styling.headingStyling.fontsForLevels = [
            .semibold17, //H1
            .bold17, //H2
            .medium15  //H3
        ]
        conditionsMarkdownView.styling.paragraphStyling.textColor = .sydney
        conditionsMarkdownView.styling.paragraphStyling.baseFont = .medium15
        conditionsMarkdownView.styling.listStyling.lineHeight = 4
        conditionsMarkdownView.styling.listStyling.bottomListItemSpacing = 10
        conditionsMarkdownView.styling.listStyling.bulletViewSize = CGSize(width: 20, height: 20)
        conditionsMarkdownView.styling.listStyling.bulletFont = .medium15
        conditionsMarkdownView.styling.listStyling.bulletImages = [UIImage.circle(diameter: 10, color: (viewModel?.isMultiOffer() ?? false) ? .budapest : .calgary)]
        conditionsMarkdownView.styling.listStyling.bulletColor = .sydney
        conditionsMarkdownView.styling.listStyling.textColor = .sydney
        conditionsMarkdownView.styling.listStyling.baseFont = .medium15
        conditionsMarkdownView.styling.linkStyling.textColor = .sydney
        conditionsMarkdownView.styling.linkStyling.baseFont = .medium15
        conditionsMarkdownView.styling.linkStyling.isBold = false
        conditionsMarkdownView.styling.linkStyling.isItalic = false
        conditionsMarkdownView.styling.linkStyling.isUnderlined = true

        conditionsMarkdownView.onDidConvertMarkDownItemToView = {
            markDownItem, view in
            view.backgroundColor = .clear
        }
    }
    
    func setupRatesContainer() {
        if viewModel.numberOfRates() == 0 {
            ratesContainerView.isHidden = true
        } else {
            for index in 0..<viewModel.numberOfRates() {
                let rateLabel = UILabel()
                let rateDescriptionLabel = UILabel()
                
                rateLabel.setContentHuggingPriority(.required, for: .horizontal)
                rateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
                rateLabel.text = viewModel.rate(row: index)?.newRate
                rateLabel.font = .semibold17
                rateLabel.textColor = .moscow
                
                rateDescriptionLabel.text = viewModel.rate(row: index)?.description
                rateDescriptionLabel.font = .medium15
                rateDescriptionLabel.textColor = .london
                rateDescriptionLabel.numberOfLines = 0
                
                let rateStackSubContainer = UIStackView()
                rateStackSubContainer.axis = .horizontal
                rateStackSubContainer.distribution = .fill
                rateStackSubContainer.alignment = .center
                rateStackSubContainer.spacing = 10
                
                rateStackSubContainer.addArrangedSubview(rateLabel)
                rateStackSubContainer.addArrangedSubview(rateDescriptionLabel)
                
                ratesStackViewContainer.addArrangedSubview(rateStackSubContainer)

            }
        }
    }
    
    func setupConditionContainer() {
        conditionsMarkdownView.text = viewModel.getConditionText()
    }
    

    private func addAnimationOnScanButton() {
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        multiScanButton.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: multiScanButton.topAnchor, constant: 10).isActive = true
        animationView.bottomAnchor.constraint(equalTo: multiScanButton.bottomAnchor, constant: -10).isActive = true
        animationView.leadingAnchor.constraint(equalTo: multiScanButton.leadingAnchor, constant: 10).isActive = true
        animationView.trailingAnchor.constraint(equalTo: multiScanButton.trailingAnchor, constant: -10).isActive = true
        view.layoutIfNeeded()
    }
    
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
    
    @IBAction func singleScanButtonClicked(_ sender: Any) {
        if !viewModel.isSuccessLoaded() {
            loadData()
            return
        }
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.singleScanButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { [weak self] (_) in
            self?.singleScanButton.transform = .identity
            self?.viewModel.goOnScan()
        }
    }
 
    @IBAction func multiScanButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.multiScanButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { [weak self] (_) in
            self?.multiScanButton.transform = .identity
            self?.viewModel.goOnScan()
        }
    }

    func showButton() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {
                return
            }
            if self.viewModel.isMultiOffer() && self.viewModel.isSuccessLoaded() {
                self.multiScanButtonBottomConstraint.constant = -15
                self.singleScanButtonBottomConstraint.constant = 100
            } else {
                self.singleScanButtonBottomConstraint.constant = 0
            }
//            self.view.layoutIfNeeded()
        }
    }
}
