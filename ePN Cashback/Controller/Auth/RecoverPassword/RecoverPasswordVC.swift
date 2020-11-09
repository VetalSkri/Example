//
//  RecoverPasswordVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 21/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import KeyboardAvoidingView
import TransitionButton

class RecoverPasswordVC: UIViewController {

    var viewModel: RecoverPasswordViewModel!
    
    //Main container
    @IBOutlet weak var mainContainerView: KeyboardAvoidingView!
    
    //back button fields
    @IBOutlet weak var backButtonContainerView: UIView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    //main title
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    //Email fields
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    //Error message
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorLabelTopConstraint: NSLayoutConstraint!
    
    //Info text field
    @IBOutlet weak var infoLabel: UILabel!
    
    //Send button
    var sendLetterButton = EPNButton(style: .primary, size: .large2)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupView()
        self.navigationController?.navigationBar.barStyle = .default;
    }
    
    private func setupSubviews() {
        mainContainerView.addSubview(sendLetterButton)
    }
    
    private func setupConstraints() {
        sendLetterButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(infoLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupView() {
        mainContainerView.backgroundColor = .zurich
        backButtonContainerView.backgroundColor = .zurich
        
        mainTitleLabel.text = NSLocalizedString("Password change", comment: "")
        mainTitleLabel.font = .extrabold28
        mainTitleLabel.textColor = .sydney
        
        emailContainerView.backgroundColor = .paris
        emailContainerView.cornerRadius = 5
        emailTextField.placeholder = NSLocalizedString("Enter your email", comment: "")
        emailTextField.backgroundColor = .clear
        emailTextField.font = .medium15
        emailTextField.textColor = .moscow
        emailTextField.text = viewModel.startEmail
        
        errorMessageLabel.textColor = .prague
        errorMessageLabel.font = .medium13
        setErrorText(errorMessage: "")
        
        infoLabel.font = .medium15
        infoLabel.textColor = .moscow
        infoLabel.text = NSLocalizedString("Recovery info message", comment: "")
        
        
        sendLetterButton.text = NSLocalizedString("Send a mail", comment: "")
        sendLetterButton.handler = {[weak self] button in
            self?.sendLetterButtonClicked()
        }
        
        invalidateSendButtonEnableState()
        
        mainContainerView.bringSubviewToFront(backButtonContainerView)
        emailTextField.becomeFirstResponder()
    }
    
    private func invalidateSendButtonEnableState() {
        let email = emailTextField.text ?? ""
        if EmailValidator(text: email).isCorrect {
            setEnableSendButton(enable: true)
        } else {
            setEnableSendButton(enable: false)
        }
    }
    
    private func setErrorText(errorMessage: String) {
        self.errorMessageLabel.text = errorMessage
        self.errorLabelTopConstraint.constant = (errorMessage.count > 0) ? 15 : 0
    }
    
    private func setEnableSendButton(enable: Bool) {
        sendLetterButton.style = enable ? .primary : .disabled
        sendLetterButton.alpha = enable ? 1.0 : 0.5
    }
    
    private func showSuccess() {
        view.endEditing(true)
        let successVC = BottomPopupVC.controllerFromStoryboard(.authorization)
        successVC.configureView(data: BottomPopupData(title: NSLocalizedString("Email is sent!", comment: ""), buttonTitle: NSLocalizedString("Take me back to the main page", comment: ""), imageName: "successSendMessage"))
        successVC.modalPresentationStyle = .overCurrentContext
        successVC.modalTransitionStyle = .crossDissolve
        successVC.delegate = self
        present(successVC, animated: false)
    }
    
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        viewModel.back()
    }
    
    @IBAction func emailTextFieldChanged(_ sender: Any) {
        invalidateSendButtonEnableState()
    }
    
    @IBAction func emailTextFieldEndEditing(_ sender: Any) {
        if !EmailValidator(text: (emailTextField.text ?? "")).isCorrect {
            setErrorText(errorMessage: NSLocalizedString("Wrong email format", comment: ""))
        } else {
            setErrorText(errorMessage: "")
        }
 
    }
    
    private func sendLetterButtonClicked() {
        sendLetterButton.getTransionButton.startAnimation()
        self.view.endEditing(true)
        viewModel.send(email: emailTextField.text ?? "") { [weak self] (errorMessage) in
            if let errorMessage = errorMessage {
                self?.sendLetterButton.getTransionButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                self?.setErrorText(errorMessage: errorMessage)
            } else {
                self?.sendLetterButton.getTransionButton.stopAnimation()
                self?.showSuccess()
            }
        }
    }
    
}

extension RecoverPasswordVC: BottomPopupVCDelegate {
    func buttonClicked() {
        self.viewModel.popToRoot()
    }
}
