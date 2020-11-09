//
//  SetPasswordVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 14.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxRelay

class SetPasswordVC: UIViewController {

    var viewModel: SetPasswordViewModel!
    private var saveBarButton: UIBarButtonItem!
    private let loadAnimationView = AnimationView(name: "loader")

    //Main container view
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var loadIndicatorContainerView: UIView!
    
    //Enter new password fields
    @IBOutlet weak var passwordUnderlineView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabelTopConstraint: NSLayoutConstraint!
    
    
    
    //Info label
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupView()
        bindVM()
    }
    
    func setUpNavigationBar() {
        title = viewModel.title()
        navigationController?.navigationBar.barTintColor = .zurich
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        saveButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        saveButton.setTitleColor(UIColor.linkCustom, for: .normal)
        saveButton.titleLabel?.font = .medium15
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)

        let backButton = UIButton(type: .system)
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        backButton.setTitleColor(UIColor.linkCustom, for: .normal)
        backButton.titleLabel?.font = .medium15
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        saveBarButton = UIBarButtonItem(customView: saveButton)
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        setSaveButtonIsEnable(false)
    }
    
    private func setupView() {
        view.bringSubviewToFront(loadIndicatorContainerView)
        view.bringSubviewToFront(topSeparatorView)
        topSeparatorView.backgroundColor = .montreal
        
        passwordTextField.font = .medium15
        passwordTextField.textColor = .moscow
        passwordTextField.placeholder = NSLocalizedString("New password", comment: "")
        passwordTextField.becomeFirstResponder()
        passwordErrorLabel.font = .medium13
        passwordErrorLabel.textColor = .prague
        passwordUnderlineView.backgroundColor = .vilnius
        
        infoLabel.font = .medium13
        infoLabel.textColor = .london
        infoLabel.text = NSLocalizedString("For security, create a password with more than 8 characters", comment: "")
        
        loadAnimationView.loopMode = .loop
        loadAnimationView.contentMode = .scaleAspectFill
        loadIndicatorContainerView.addSubview(loadAnimationView)
        loadIndicatorContainerView.isHidden = true
        loadAnimationView.translatesAutoresizingMaskIntoConstraints = false
        loadAnimationView.topAnchor.constraint(equalTo: loadIndicatorContainerView.topAnchor, constant: 0).isActive = true
        loadAnimationView.bottomAnchor.constraint(equalTo: loadIndicatorContainerView.bottomAnchor, constant: 0).isActive = true
        loadAnimationView.leadingAnchor.constraint(equalTo: loadIndicatorContainerView.leadingAnchor, constant: 0).isActive = true
        loadAnimationView.trailingAnchor.constraint(equalTo: loadIndicatorContainerView.trailingAnchor, constant: 0).isActive = true
    }
    
    private func bindVM() {
        _ = viewModel.passwordError.observeOn(MainScheduler.instance).subscribe({ [weak self] (event) in
            if let errorText = event.element {
                self?.setPasswordErrorText(errorText)
            }
        })
    }
    
    private func setShowAnimation(_ isShow: Bool) {
        if isShow {
            self.loadAnimationView.play()
        } else {
            self.loadAnimationView.stop()
        }
        self.loadIndicatorContainerView.isHidden = !isShow
    }
    
    private func setSaveButtonIsEnable(_ isEnable: Bool) {
        self.saveBarButton.isEnabled = isEnable
        (self.saveBarButton.customView as? UIButton)?.setTitleColor((isEnable) ? UIColor.linkCustom : UIColor.minsk, for: .normal)
    }
    
    private func setPasswordErrorText(_ errorText: String) {
        if errorText.count > 0 {
            view.endEditing(true)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.passwordErrorLabel.text = errorText
            self?.passwordErrorLabelTopConstraint.constant = (errorText.count > 0) ? 12 : 0
            if errorText.count > 0 {
                self?.passwordUnderlineView.backgroundColor = .prague
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func saveButtonClicked() {
        view.endEditing(true)
        setShowAnimation(true)
        viewModel.setPassword(newPassword: passwordTextField.text ?? "") { [weak self] in
            self?.setShowAnimation(false)
        }
    }
    
    @objc func backButtonClicked() {
        viewModel.back()
    }
    
    @IBAction func showPasswordClicked(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        showPasswordImageView.image = UIImage(named: passwordTextField.isSecureTextEntry ? "inactiveEye" : "activeEye")
    }
    
    @IBAction func passwordTextFieldEndEditing(_ sender: Any) {
        passwordUnderlineView.backgroundColor = .montreal
    }
    
    @IBAction func passwordBeginEditing(_ sender: Any) {
        setPasswordErrorText("")
        passwordUnderlineView.backgroundColor = .vilnius
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        setSaveButtonIsEnable((passwordTextField.text?.count ?? 0) >= 8)
    }
    
}
