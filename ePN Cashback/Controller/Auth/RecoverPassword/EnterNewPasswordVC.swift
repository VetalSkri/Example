//
//  EnterNewPasswordVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 03/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import KeyboardAvoidingView
import TransitionButton

class EnterNewPasswordVC: UIViewController {

    var viewModel: EnterNewPasswordViewModel!
    
    //Main container view
    @IBOutlet weak var mainContainerView: KeyboardAvoidingView!
    
    //Back button fields
    @IBOutlet weak var backButtonContainerView: UIView!
    @IBOutlet weak var backButtonClickZoneView: UIView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    //Main title
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    //Password input
    @IBOutlet weak var enterPasswordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordContainerView: UIView!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    @IBOutlet weak var passwordDescriptionLabel: UILabel!
    @IBOutlet weak var passwordUnderlineView: UIView!
    @IBOutlet var passwordProgressLineEqualWidthConstraint: NSLayoutConstraint!
    
    //Error label
    @IBOutlet weak var errorLabel: UILabel!
    
    //Button fields
    @IBOutlet weak var buttonSeparatorLineView: UIView!
    var createButton = EPNButton(style: .primary, size: .large2)
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupView()
    }
    
    private func setupSubviews() {
        mainContainerView.addSubview(createButton)
    }
    
    private func setupConstraints() {
        createButton.snp.makeConstraints { (make) in
            make.top.equalTo(buttonSeparatorLineView.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
    }
    
    private func setupView() {
        mainContainerView.backgroundColor = .zurich
        backButtonContainerView.backgroundColor = .zurich
        
        mainTitleLabel.text = NSLocalizedString("Password change", comment: "")
        mainTitleLabel.font = .extrabold28
        mainTitleLabel.textColor = .sydney
        
        enterPasswordContainerView.backgroundColor = .paris
        enterPasswordContainerView.cornerRadius = 5
        passwordTextField.placeholder = NSLocalizedString("Create a new password", comment: "")
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .medium15
        passwordTextField.textColor = .moscow
        passwordTextField.isSecureTextEntry = true
        showPasswordContainerView.backgroundColor = .clear
        
        errorLabel.textColor = .prague
        errorLabel.font = .medium13
        setErrorText(errorMessage: "")
        
        passwordDescriptionLabel.text = NSLocalizedString("from 8 to 20 characters", comment: "")
        passwordDescriptionLabel.font = .medium10
        passwordDescriptionLabel.textColor = .minsk
        passwordUnderlineView.backgroundColor = .prague
        
        buttonSeparatorLineView.backgroundColor = .paris
        
        createButton.text = NSLocalizedString("Create", comment: "")
        createButton.handler = {[weak self] button in
            self?.createButtonClicked()
        }
        
        invalidateCreateButtonEnableState()
        
        mainContainerView.bringSubviewToFront(backButtonContainerView)
        
        passwordTextField.becomeFirstResponder()
        
    }
    
    private func invalidatePasswordProgress() {
        if (self.passwordTextField.text ?? "").count < 8 {
            if !self.passwordProgressLineEqualWidthConstraint.isActive {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.passwordProgressLineEqualWidthConstraint.isActive = true
                    self?.passwordUnderlineView.backgroundColor = .prague
                    self?.view.layoutIfNeeded()
                }
            }
        } else {
            if self.passwordProgressLineEqualWidthConstraint.isActive {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.passwordProgressLineEqualWidthConstraint.isActive = false
                    self?.passwordUnderlineView.backgroundColor = .budapest
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func invalidateCreateButtonEnableState() {
        if passwordTextField.text?.count ?? 0 >= 8 {
            createButton.style = .primary
        } else {
            createButton.style = .disabled
        }
    }
    
    private func setErrorText(errorMessage: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorLabel.text = errorMessage
        }
    }
    
    private func showSuccess() {
        view.endEditing(true)
        let successVC = BottomPopupVC.controllerFromStoryboard(.authorization)
        successVC.configureView(data: BottomPopupData(title: NSLocalizedString("The new password was created", comment: ""), buttonTitle: NSLocalizedString("Log in to Backit", comment: ""), imageName: "successCreateAccount"))
        successVC.modalPresentationStyle = .overCurrentContext
        successVC.modalTransitionStyle = .crossDissolve
        successVC.delegate = self
        present(successVC, animated: false)
    }
    
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        viewModel.popToRoot()
    }
    
    @IBAction func passwordTextFieldEditing(_ sender: Any) {
        invalidatePasswordProgress()
        invalidateCreateButtonEnableState()
    }
    
    private func createButtonClicked() {
        createButton.getTransionButton.startAnimation()
        viewModel.changePassword(password: passwordTextField.text ?? "") { [weak self] (errorMessage) in
            if let errorMessage = errorMessage {
                self?.createButton.getTransionButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                self?.setErrorText(errorMessage: errorMessage)
            } else {
                self?.createButton.getTransionButton.stopAnimation()
                self?.showSuccess()
            }
        }
    }
    
    @IBAction func showPasswordClicked(_ sender: Any) {
        showPasswordImageView.image = UIImage(named: (passwordTextField.isSecureTextEntry ? "activeEye" : "inactiveEye"))
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    
}

extension EnterNewPasswordVC: BottomPopupVCDelegate {
    func buttonClicked() {
        viewModel.goToLogin()
    }
}
