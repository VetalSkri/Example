//
//  BindMailVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import KeyboardAvoidingView
import TransitionButton

class BindMailVC: UIViewController {

    var viewModel: BindMailViewModel!
    
    //Main container
    @IBOutlet weak var mainContainerView: KeyboardAvoidingView!
    
    //Back button
    @IBOutlet weak var backButtonContainerView: UIView!
    @IBOutlet weak var backButtonClickZoneView: UIView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    //Main title
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    //Password fields
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordContainerView: UIView!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    
    //Error label
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorLabelTopConstraint: NSLayoutConstraint!
    
    //Info label
    @IBOutlet weak var infoLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var recoveryPasswordButton: UIButton!
    @IBOutlet weak var continueButton: TransitionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func setupView() {
        mainContainerView.backgroundColor = .zurich
        backButtonContainerView.backgroundColor = .zurich
        
        mainTitleLabel.text = NSLocalizedString("Account binding", comment: "")
        mainTitleLabel.font = .extrabold28
        mainTitleLabel.textColor = .sydney
        
        passwordContainerView.backgroundColor = .paris
        passwordContainerView.cornerRadius = 5
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .medium15
        passwordTextField.textColor = .moscow
        passwordTextField.isSecureTextEntry = true
        
        errorMessageLabel.textColor = .prague
        errorMessageLabel.font = .medium13
        setErrorText(errorMessage: "")
        
        infoLabel.font = .medium15
        infoLabel.textColor = .london
        infoLabel.text = "\(NSLocalizedString("Enter your password from your", comment: "")) \(viewModel.email) \(NSLocalizedString("account in Backit.", comment: ""))"
        
        continueButton.backgroundColor = .sydney
        continueButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
        continueButton.setTitleColor(.zurich, for: .normal)
        (continueButton as UIButton).cornerRadius = 5
        invalidateContinueButtonButtonEnableState()
        
        recoveryPasswordButton.backgroundColor = .clear
        recoveryPasswordButton.setTitle(NSLocalizedString("Forgot your password?", comment: ""), for: .normal)
        recoveryPasswordButton.setTitleColor(.sydney, for: .normal)
        recoveryPasswordButton.cornerRadius = 5
        recoveryPasswordButton.borderColor = .montreal
        recoveryPasswordButton.borderWidth = 1
        
        view.bringSubviewToFront(backButtonContainerView)
    }
    
    private func setErrorText(errorMessage: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorMessageLabel.text = errorMessage
            self?.errorLabelTopConstraint.constant = (errorMessage.count > 0) ? 15 : 0
            self?.view.layoutIfNeeded()
        }
    }
    
    private func invalidateContinueButtonButtonEnableState() {
        continueButton.isEnabled = (passwordTextField.text?.count ?? 0) >= 8
        continueButton.alpha = ((passwordTextField.text?.count ?? 0) >= 8) ? 1.0 : 0.5
    }
    
    private func showSuccess() {
        view.endEditing(true)
        let successVC = BottomPopupVC.controllerFromStoryboard(.authorization)
        successVC.configureView(data: BottomPopupData(title: "\(NSLocalizedString("Account", comment: "")) \(viewModel.socialName) \(NSLocalizedString("is successfully bound!", comment: ""))", buttonTitle: NSLocalizedString("Go shopping!", comment: ""), imageName: "successCreateAccount"))
        successVC.modalPresentationStyle = .overCurrentContext
        successVC.modalTransitionStyle = .crossDissolve
        successVC.delegate = self
        present(successVC, animated: false)
    }
    
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        setErrorText(errorMessage: "")
        continueButton.startAnimation()
        viewModel.bind(password: self.passwordTextField.text ?? "") { [weak self] (errorMessage) in
            if let errorMessage = errorMessage {
                self?.continueButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                self?.setErrorText(errorMessage: errorMessage)
            } else {
                self?.continueButton.stopAnimation()
                self?.showSuccess()
            }
        }
    }
    
    @IBAction func recoveryPasswordButtonClicked(_ sender: Any) {
        viewModel.recoveryPassword()
    }
    
    @IBAction func passwordTextEditing(_ sender: Any) {
        invalidateContinueButtonButtonEnableState()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        viewModel.back()
    }
    
    @IBAction func showPasswordClicked(_ sender: Any) {
        showPasswordImageView.image = UIImage(named: (passwordTextField.isSecureTextEntry ? "activeEye" : "inactiveEye"))
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
}

extension BindMailVC: BottomPopupVCDelegate {
    func buttonClicked() {
        viewModel.goToMain()
    }
}
