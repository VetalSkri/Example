//
//  LoginVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 17/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import KeyboardAvoidingView
import TransitionButton

class LoginVC: UIViewController {

    var viewModel: LoginViewModel!

    
    @IBOutlet weak var mainContainerView: KeyboardAvoidingView!
    
    //Back button fields
    @IBOutlet weak var backMainContainerView: UIView!
    @IBOutlet weak var backButtonContainerView: UIView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    
    //Title label
    @IBOutlet weak var largeTitleLabel: UILabel!
    
    //Login field
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    
    //Password field
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    
    
    
    //Error label
    @IBOutlet weak var errorLabel: UILabel!
    
    //Button fields
    @IBOutlet weak var buttonsContainerView: UIView!
    var forgetPassButton = EPNButton(style: .secondary, size: .large2)
    var continueButton = EPNButton(style: .primary, size: .large2)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupView()
        self.navigationController?.navigationBar.barStyle = .default;
    }
    
    private func setupSubviews() {
        forgetPassButton.handler = { [weak self ]button in
            self?.forgetPasswordButtonClicked()
        }
        continueButton.handler = {[weak self] button in
            self?.continueButtonClicked()
        }
        buttonsContainerView.addSubview(continueButton)
        buttonsContainerView.addSubview(forgetPassButton)
    }
    
    private func setupConstraints() {
        forgetPassButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(continueButton)
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        continueButton.snp.makeConstraints { (make) in
            make.left.equalTo(forgetPassButton.snp.right).offset(14)
            make.height.equalTo(50)
            make.width.equalTo(forgetPassButton)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupView() {
        largeTitleLabel.text = NSLocalizedString("Backit login", comment: "")
        largeTitleLabel.font = .extrabold28
        largeTitleLabel.textColor = .sydney
        
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
        
        errorLabel.textColor = .prague
        errorLabel.font = .medium13
        errorLabel.text = ""
        
        buttonsContainerView.backgroundColor = .clear
        
        forgetPassButton.text = NSLocalizedString("Forgot your password?", comment: "")
        
        continueButton.text = NSLocalizedString("Continue", comment: "")
        
        mainContainerView.bringSubviewToFront(backMainContainerView)
        
        let email = Session.shared.user_login
        if !email.elementsEqual("") {
            loginTextField.text = email
        }
        
        setContinueButtonEnable(enable: false)
    }
    
    private func updateContinueButtonState() {
        setContinueButtonEnable(enable: ((self.loginTextField.text ?? "").count > 0 && (self.passwordTextField.text ?? "").count >= 8))
    }
    
    private func setContinueButtonEnable(enable: Bool) {
        self.continueButton.style = enable ? .primary : .disabled
    }

    private func forgetPasswordButtonClicked() {
        viewModel.recoverPassword(startEmail: loginTextField.text ?? "")
    }
    
    private func continueButtonClicked() {
        continueButton.getTransionButton.startAnimation()
        viewModel.enter(login: loginTextField.text!, password: passwordTextField.text!) { [weak self] (result) in
            if let result = result {
                if result.count >= 0 {
                    self?.errorLabel.text = result
                    self?.continueButton.getTransionButton  .stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                } else {
                    self?.continueButton.getTransionButton .stopAnimation()
                }
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        viewModel.back()
    }
    
    @IBAction func showPasswordClicked(_ sender: Any) {
        showPasswordImageView.image = UIImage(named: (passwordTextField.isSecureTextEntry ? "activeEye" : "inactiveEye"))
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func loginTextFieldEditing(_ sender: Any) {
        updateContinueButtonState()
    }
    
    @IBAction func passwordTextFieldEditing(_ sender: Any) {
        updateContinueButtonState()
    }
    
    
}
