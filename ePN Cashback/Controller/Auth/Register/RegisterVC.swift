//
//  RegisterViewController.swift
//  Backit
//
//  Created by Александр Кузьмин on 21/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import KeyboardAvoidingView
import TransitionButton

class RegisterVC: UIViewController {

    var viewModel: RegisterViewModel!
    
    //Main container view
    @IBOutlet weak var mainContainerView: KeyboardAvoidingView!
    
    //Back button fields
    @IBOutlet weak var backButtonMainContainerView: UIView!
    @IBOutlet weak var backButtonSecondContainerView: UIView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    //Main title
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    //Login fields
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    
    //Password fields
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordContinerView: UIView!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    @IBOutlet weak var passwordProgressLine: UIView!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet var passwordProgressLineEqualWidthContraint: NSLayoutConstraint!
    
    //Blur shield
    @IBOutlet weak var blurShieldView: UIVisualEffectView!
    
    //News subscription accept fields
    @IBOutlet weak var newsSubscriptionContainerView: UIView!
    @IBOutlet weak var newsSubscriptionCheckBoxImageView: UIImageView!
    @IBOutlet weak var newsSubscriptionLabel: UILabel!
    
    //Error label
    @IBOutlet weak var errorInfoLabel: UILabel!
    @IBOutlet weak var errorInfoLabelTopConstraint: NSLayoutConstraint!
    
    
    //Conditions and privacy police links label
    @IBOutlet weak var conditionLabel: UILabel!
    
    //Buttons fields
    @IBOutlet weak var buttonsContainerView: UIView!
    var promocodeButton = EPNButton(style: .secondary, size: .large1)
    var continueButton = EPNButton(style: .primary, size: .large1)
    
    //Enter promocode fields
    @IBOutlet weak var promocodeContainerView: UIView!
    @IBOutlet weak var promocodeContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var promocodeTitleView: UILabel!
    @IBOutlet weak var promocodeTextFieldContainerView: UIView!
    @IBOutlet weak var promocodeTextField: UITextField!
    @IBOutlet weak var promocodeErrorLabel: UILabel!
    @IBOutlet weak var promocodeErrorLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var promocodeDescriptionLabel: UILabel!
    var promocodeBackButton = EPNButton(style: .secondary, size: .large1)
    var promocodeAddButton = EPNButton(style: .primary, size: .large1)
    
    @IBOutlet weak var closeClickZoneView: UIView!
    
    
    
    
    
    var termRange: NSRange?
    var privacyRange: NSRange?
    var promocodeProcess = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupView()
        self.navigationController?.navigationBar.barStyle = .default;
    }
    
    private func setupSubviews() {
        buttonsContainerView.addSubview(promocodeButton)
        buttonsContainerView.addSubview(continueButton)
        
        promocodeContainerView.addSubview(promocodeBackButton)
        promocodeContainerView.addSubview(promocodeAddButton)
    }
    
    private func setupConstraints() {
        promocodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(promocodeDescriptionLabel.snp.bottom).offset(35)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(continueButton)
            make.height.equalTo(50)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(promocodeDescriptionLabel.snp.bottom).offset(35)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(promocodeButton.snp.right).offset(15)
            make.width.equalTo(promocodeButton)
            make.height.equalTo(50)
        }
        promocodeBackButton.snp.makeConstraints { (make) in
            make.top.equalTo(promocodeDescriptionLabel.snp.bottom).offset(35)
            make.height.equalTo(50)
            make.width.equalTo(promocodeAddButton)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalTo(promocodeAddButton)
            make.bottom.equalToSuperview().inset(15)
        }
        promocodeAddButton.snp.makeConstraints { (make) in
            make.top.equalTo(promocodeDescriptionLabel.snp.bottom).offset(35)
            make.height.equalTo(50)
            make.width.equalTo(promocodeBackButton)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(promocodeBackButton.snp.right).offset(15)
            make.centerY.equalTo(promocodeBackButton)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !promocodeProcess {
            self.view.endEditing(true)
        }
    }
    
    private func setupView() {
        mainContainerView.backgroundColor = .zurich
        backButtonMainContainerView.backgroundColor = .zurich
        
        mainTitleLabel.font = .extrabold28
        mainTitleLabel.textColor = .sydney
        mainTitleLabel.text = NSLocalizedString("Create account", comment:"")
        
        loginContainerView.backgroundColor = .paris
        loginContainerView.cornerRadius = 5
        loginTextField.backgroundColor = .clear
        loginTextField.font = .medium15
        loginTextField.textColor = .moscow
        loginTextField.placeholder = NSLocalizedString("Email", comment: "")
        
        passwordContainerView.backgroundColor = .paris
        passwordContainerView.cornerRadius = 5
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .medium15
        passwordTextField.textColor = .moscow
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        passwordTextField.isSecureTextEntry = true
        
        passwordInfoLabel.text = NSLocalizedString("from 8 to 20 characters", comment: "")
        passwordInfoLabel.font = .medium10
        passwordInfoLabel.textColor = .minsk
        
        errorInfoLabel.textColor = .prague
        errorInfoLabel.font = .medium13
        errorInfoLabel.text = ""
        
        buttonsContainerView.backgroundColor = .clear
        
        promocodeButton.text = NSLocalizedString("Enter promotional code", comment: "")
        promocodeButton.handler = {[weak self] button in
            self?.promocodeButtonClicked()
        }
        
        continueButton.text = NSLocalizedString("Continue", comment: "")
        continueButton.handler = {[weak self] button in
            self?.continueButtonClicked()
        }
        
        newsSubscriptionContainerView.backgroundColor = .clear
        newsSubscriptionLabel.font = .medium13
        newsSubscriptionLabel.textColor = .moscow
        newsSubscriptionLabel.text = NSLocalizedString("I agree to receive newsletters", comment: "")
        
        var conditionsText = NSLocalizedString("By clicking Continue, you confirm that you accept the Terms and the Privacy Policy of the Backit Affiliate Program", comment: "")
        termRange = NSRange(location: conditionsText.distance(from: conditionsText.startIndex, to: conditionsText.firstIndex(of: "<")!), length: conditionsText.distance(from: conditionsText.startIndex, to: conditionsText.firstIndex(of: ">")!) - conditionsText.distance(from: conditionsText.startIndex, to: conditionsText.firstIndex(of: "<")!))
        privacyRange = NSRange(location: conditionsText.distance(from: conditionsText.startIndex, to: conditionsText.lastIndex(of: "<")!) - 2, length: conditionsText.distance(from: conditionsText.startIndex, to: conditionsText.lastIndex(of: ">")!) - conditionsText.distance(from: conditionsText.startIndex, to: conditionsText.lastIndex(of: "<")!))
        conditionsText = conditionsText.filter{ return $0 != ">" && $0 != "<" }
        let attributesString = NSMutableAttributedString(string: conditionsText, attributes: [NSAttributedString.Key.font: UIFont.medium15, NSAttributedString.Key.foregroundColor: UIColor.london])
        attributesString.addAttributes([NSAttributedString.Key.font: UIFont.semibold13, NSAttributedString.Key.foregroundColor: UIColor.sydney], range: termRange!)
        attributesString.addAttributes([NSAttributedString.Key.font: UIFont.semibold13, NSAttributedString.Key.foregroundColor: UIColor.sydney], range: privacyRange!)
        conditionLabel.attributedText = attributesString
        
        passwordProgressLine.backgroundColor = .prague
        
        mainContainerView.bringSubviewToFront(backButtonMainContainerView)
        mainContainerView.bringSubviewToFront(blurShieldView)
        mainContainerView.bringSubviewToFront(closeClickZoneView)
        mainContainerView.bringSubviewToFront(promocodeContainerView)
        
        invalidateEnableStateOfNextButton()
        invalidatePasswordProgress()
        invalidateCheckPromocodeButtonEnableStatus()
        
        self.promocodeContainerView.backgroundColor = .zurich
        self.promocodeContainerView.cornerRadius = CommonStyle.newCornerRadius
        self.promocodeContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.promocodeTitleView.font = .bold20
        self.promocodeTitleView.textColor = .sydney
        self.promocodeTitleView.text = NSLocalizedString("Add promotional code", comment: "")
        self.promocodeTextFieldContainerView.backgroundColor = .paris
        self.promocodeTextFieldContainerView.cornerRadius = 5
        self.promocodeTextField.font = .medium15
        self.promocodeTextField.textColor = .moscow
        self.promocodeTextField.placeholder = NSLocalizedString("Promo code", comment: "")
        self.promocodeErrorLabel.font = .medium13
        self.promocodeErrorLabel.textColor = .prague
        self.promocodeErrorLabel.text = ""
        self.promocodeDescriptionLabel.font = .medium13
        self.promocodeDescriptionLabel.textColor = .london
        self.promocodeDescriptionLabel.text = NSLocalizedString("The promotional code can be obtained from our partners or in the social media: Vkontakte, Facebook, Instagram.", comment: "")
        self.promocodeBackButton.text = NSLocalizedString("Back", comment: "")
        self.promocodeBackButton.handler = {[weak self] button in
            self?.promocodeBackButtonClicked()
        }
        
        self.promocodeAddButton.text = NSLocalizedString("Add", comment: "")
        self.promocodeAddButton.handler = {[weak self] button in
            self?.promocodeAddButtonClicked()
        }
    }
    
    private func setEnableNextButton(enable: Bool) {
        self.continueButton.style = enable ? .primary : .disabled
    }
    
    private func setErrorText(error: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorInfoLabel.text = error
            self?.errorInfoLabelTopConstraint.constant = (error.count > 0) ? 17 : 0
            self?.view.layoutIfNeeded()
        }
    }
    
    private func invalidateEnableStateOfNextButton() {
        let emailIsCorrect = EmailValidator(text: (loginTextField.text ?? "")).isCorrect
        setEnableNextButton(enable: (passwordTextField.text ?? "").count >= 8 && emailIsCorrect)
    }
    
    private func invalidatePasswordProgress() {
        if (self.passwordTextField.text ?? "").count < 8 {
            if !self.passwordProgressLineEqualWidthContraint.isActive {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.passwordProgressLineEqualWidthContraint.isActive = true
                    self?.passwordProgressLine.backgroundColor = .prague
                    self?.view.layoutIfNeeded()
                }
            }
        } else {
            if self.passwordProgressLineEqualWidthContraint.isActive {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.passwordProgressLineEqualWidthContraint.isActive = false
                    self?.passwordProgressLine.backgroundColor = .budapest
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func showSuccess() {
        view.endEditing(true)
        let successVC = BottomPopupVC.controllerFromStoryboard(.authorization)
        successVC.configureView(data: BottomPopupData(title: NSLocalizedString("Account is created successfully!", comment: ""), buttonTitle: NSLocalizedString("Log in to Backit", comment: ""), imageName: "successCreateAccount"))
        successVC.modalPresentationStyle = .overCurrentContext
        successVC.modalTransitionStyle = .crossDissolve
        successVC.delegate = self
        present(successVC, animated: false)
    }
    
    private func invalidateCheckPromocodeButtonEnableStatus() {
        if promocodeTextField.text?.count ?? 0 > 0 {
            promocodeAddButton.style = .primary
        } else {
            promocodeAddButton.style = .disabled
        }
    }
    
    private func closePromocodeView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.promocodeTextField.resignFirstResponder()
            self?.closeClickZoneView.isHidden = true
            self?.promocodeContainerView.isHidden = true
            self?.promocodeContainerView.alpha = 0.0
            self?.blurShieldView.isHidden = true
            self?.blurShieldView.alpha = 0.0
            self?.promocodeProcess = false
            self?.view.layoutIfNeeded()
        }
    }
    
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        viewModel.back()
    }
    
    @IBAction func loginTextDidChanged(_ sender: Any) {
        invalidateEnableStateOfNextButton()
    }
    
    @IBAction func loginTextDidEndEditing(_ sender: Any) {
        if !EmailValidator(text: (loginTextField.text ?? "")).isCorrect {
            setErrorText(error: NSLocalizedString("Wrong email format", comment: ""))
        } else {
            setErrorText(error: "")
        }
    }
    
    @IBAction func passwordTextDidChange(_ sender: Any) {
        invalidateEnableStateOfNextButton()
        invalidatePasswordProgress()
    }
    
    @IBAction func newsSubscriptionButtonClicked(_ sender: Any) {
        viewModel.acceptToNewsSubscription = !viewModel.acceptToNewsSubscription
        newsSubscriptionCheckBoxImageView.image = UIImage(named: viewModel.acceptToNewsSubscription ? "checkBoxSelected" : "checkBoxDeselected")
    }
    
    private func promocodeButtonClicked() {
        AuthAnalytics.open(page: .Promocode)
        self.promocodeProcess = true
        self.promocodeTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.promocodeContainerView.isHidden = false
            self?.promocodeContainerView.alpha = 1.0
            self?.closeClickZoneView.isHidden = false
            self?.blurShieldView.effect = UIBlurEffect(style: .dark)
            self?.blurShieldView.isHidden = false
            self?.blurShieldView.alpha = 1.0
            self?.view.layoutIfNeeded()
        }
    }
    
    private func continueButtonClicked() {
        view.endEditing(true)
        continueButton.getTransionButton.startAnimation()
        viewModel.register(email: loginTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] (errorMessage) in
            if let errorMessage = errorMessage {
                self?.continueButton.getTransionButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                self?.setErrorText(error: errorMessage)
            } else {
                self?.continueButton.getTransionButton.stopAnimation()
                self?.showSuccess()
            }
        }
    }
    
    @IBAction func conditionTapped(_ sender: UITapGestureRecognizer? = nil) {
        guard let termRange = termRange, let privacyRange = privacyRange, let sender = sender else {
            return
        }
        if sender.didTapAttributedTextInLabel(label: conditionLabel, inRange: termRange) {
            if let url = viewModel.getRulesUrl() {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else if sender.didTapAttributedTextInLabel(label: conditionLabel, inRange: privacyRange) {
            if let url = viewModel.getPrivacyUrl() {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func showPasswordButtonClicked(_ sender: Any) {
        showPasswordImageView.image = UIImage(named: (passwordTextField.isSecureTextEntry ? "activeEye" : "inactiveEye"))
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
 
    @IBAction func passwordBeginEditing(_ sender: Any) {
        passwordProgressLine.isHidden = false
        passwordInfoLabel.isHidden = false
    }
    
    @IBAction func passwordEndEditing(_ sender: Any) {
        passwordProgressLine.isHidden = true
        passwordInfoLabel.isHidden = true
    }
    
    //Promocode delegate
    @IBAction func promocodeTextFieldChanged(_ sender: Any) {
        invalidateCheckPromocodeButtonEnableStatus()
    }
    
    private func promocodeBackButtonClicked() {
        closePromocodeView()
    }
    
    private func promocodeAddButtonClicked() {
        promocodeAddButton.getTransionButton.startAnimation()
        self.promocodeErrorLabel.text = ""
        self.promocodeErrorLabelTopConstraint.constant = 0
        viewModel.checkPromocode(promocode: promocodeTextField.text ?? "") { [weak self] (errorMessage) in
            if let errorMessage = errorMessage {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.promocodeErrorLabel.text = errorMessage
                    self?.promocodeErrorLabelTopConstraint.constant = 17
                    self?.promocodeAddButton.getTransionButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                    self?.view.layoutIfNeeded()
                }
            } else {
                self?.promocodeButton.text = NSLocalizedString("Promo code entered", comment: "")
                self?.promocodeButton.style = .disabled
                self?.closePromocodeView()
                self?.promocodeAddButton.getTransionButton.stopAnimation()
            }
        }
    }
    
    @IBAction func blurShieldClicked(_ sender: Any) {
        if promocodeProcess {
            self.closePromocodeView()
        }
    }
}

extension RegisterVC: BottomPopupVCDelegate {
    func buttonClicked() {
        self.viewModel.enter()
    }
}
