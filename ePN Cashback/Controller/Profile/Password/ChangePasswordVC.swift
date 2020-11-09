//
//  ChangePasswordVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 14.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxRelay

class ChangePasswordVC: UIViewController {

    var viewModel: ChangePasswordViewModel!
    private var saveBarButton: UIBarButtonItem!
    private let loadAnimationView = AnimationView(name: "loader")
    
    //Main container view
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var loadIndicatorContainerView: UIView!

    //Old password fields
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var showOldPasswordImageView: UIImageView!
    @IBOutlet weak var oldPasswordUnderlineView: UIView!
    @IBOutlet weak var oldPasswordErrorLabel: UILabel!
    @IBOutlet weak var oldPasswordErrorTopSpacing: NSLayoutConstraint!
    
    //New password fields
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var showNewPasswordImageView: UIImageView!
    @IBOutlet weak var newPasswordUnderlineView: UIView!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorTopSpacing: NSLayoutConstraint!
    
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
        mainContainerView.bringSubviewToFront(topSeparatorView)
        topSeparatorView.backgroundColor = .montreal
        
        oldPasswordTextField.textColor = .moscow
        oldPasswordTextField.font = .medium15
        oldPasswordTextField.placeholder = NSLocalizedString("Old password", comment: "")
        oldPasswordUnderlineView.backgroundColor = .vilnius
        oldPasswordErrorLabel.font = .medium13
        oldPasswordErrorLabel.textColor = .prague
        oldPasswordTextField.becomeFirstResponder()
        
        newPasswordTextField.textColor = .moscow
        newPasswordTextField.font = .medium15
        newPasswordTextField.placeholder = NSLocalizedString("New password", comment: "")
        newPasswordErrorLabel.font = .medium13
        newPasswordErrorLabel.textColor = .prague
        newPasswordUnderlineView.backgroundColor = .montreal
        
        infoLabel.font = .medium13
        infoLabel.textColor = .london
        infoLabel.text = NSLocalizedString("In order to change the password", comment: "")
        
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
        _ = viewModel.newPasswordError.observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            if let errorString = event.element {
                self?.setNewPasswordErrorText(errorString)
            }
        }
        
        _ = viewModel.oldPasswordError.observeOn(MainScheduler.instance).subscribe { [weak self] (event) in
            if let errorString = event.element {
                self?.setOldPasswordErrorText(errorString)
            }
        }
    }
    
    private func setSaveButtonIsEnable(_ isEnable: Bool) {
        self.saveBarButton.isEnabled = isEnable
        (self.saveBarButton.customView as? UIButton)?.setTitleColor((isEnable) ? UIColor.linkCustom : UIColor.minsk, for: .normal)
    }
    
    private func invalidateSaveButtonState() {
        setSaveButtonIsEnable(((newPasswordTextField.text?.count ?? 0 >= 8) && (oldPasswordTextField.text?.count ?? 0 >= 8)))
    }
    
    private func setShowAnimation(_ isShow: Bool) {
        if isShow {
            self.loadAnimationView.play()
        } else {
            self.loadAnimationView.stop()
        }
        self.loadIndicatorContainerView.isHidden = !isShow
    }
    
    @objc func saveButtonClicked() {
        view.endEditing(true)
        setShowAnimation(true)
        viewModel.changePassword(oldPassword: oldPasswordTextField.text ?? "", newPassword: newPasswordTextField.text ?? "") { [weak self] in
            self?.setShowAnimation(false)
        }
    }
    
    @objc func backButtonClicked() {
        viewModel.back()
    }
    
    private func setOldPasswordErrorText(_ errorText: String) {
        if errorText.count > 0 {
            view.endEditing(true)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.oldPasswordErrorLabel.text = errorText
            self?.oldPasswordErrorTopSpacing.constant = (errorText.count > 0) ? 12 : 0
            if errorText.count > 0 {
                self?.oldPasswordUnderlineView.backgroundColor = .prague
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    private func setNewPasswordErrorText(_ errorText: String) {
        if errorText.count > 0 {
            view.endEditing(true)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.newPasswordErrorLabel.text = errorText
            self?.newPasswordErrorTopSpacing.constant = (errorText.count > 0) ? 12 : 0
            if errorText.count > 0 {
                self?.newPasswordUnderlineView.backgroundColor = .prague
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func oldPasswordEndEditing(_ sender: Any) {
        oldPasswordUnderlineView.backgroundColor = .montreal
    }
    
    @IBAction func oldPasswordBeginEditing(_ sender: Any) {
        oldPasswordUnderlineView.backgroundColor = .vilnius
        setOldPasswordErrorText("")
    }
    
    @IBAction func oldPasswordEditingChanged(_ sender: Any) {
        invalidateSaveButtonState()
    }
    
    @IBAction func newPasswordEndEditing(_ sender: Any) {
        newPasswordUnderlineView.backgroundColor = .montreal
    }
    
    @IBAction func newPasswordBeginEditing(_ sender: Any) {
        newPasswordUnderlineView.backgroundColor = .vilnius
        setNewPasswordErrorText("")
    }
    
    @IBAction func newPasswordEditingChanged(_ sender: Any) {
        invalidateSaveButtonState()
    }
    
    @IBAction func showOldPasswordClicked(_ sender: Any) {
        oldPasswordTextField.isSecureTextEntry = !oldPasswordTextField.isSecureTextEntry
        showOldPasswordImageView.image = UIImage(named: oldPasswordTextField.isSecureTextEntry ? "inactiveEye" : "activeEye")
    }
    
    @IBAction func showNewPasswordClicked(_ sender: Any) {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        showNewPasswordImageView.image = UIImage(named: newPasswordTextField.isSecureTextEntry ? "inactiveEye" : "activeEye")
    }
    
}
