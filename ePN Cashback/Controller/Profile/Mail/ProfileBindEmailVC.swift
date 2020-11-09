//
//  ProfileBindEmailVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 10.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import TransitionButton
import ProgressHUD

protocol ProfileBindEmailVCDelegate: class {
    func successBindEmail(email: String)
}

class ProfileBindEmailVC: UIViewController {
    
    // MARK: - Instance Properties

    var viewModel: ProfileBindEmailViewModel!
    
    // MARK: -
    
    @IBOutlet private weak var mainContainerView: UIView!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailUnderlineView: UIView!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupView()
    }
    
    private func setUpNavigationBar() {
        title = viewModel.title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.backButtonTitle, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.medium15], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.medium15], for: .selected)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.doneButtonTitle, style: .done, target: self, action: #selector(onDoneButtonTouchUpInside(sender:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.semibold15], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.semibold15], for: .disabled)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.semibold15], for: .selected)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.semibold15]
    }

    private func setupView() {
        setEnableDoneButton(false)
        emailTextField.becomeFirstResponder()
        
        emailTextField.font = .medium15
        emailTextField.textColor = .moscow
        emailTextField.placeholder = NSLocalizedString("Enter your email", comment: "")
        emailTextField.text = ""
        emailUnderlineView.backgroundColor = .vilnius
        
        descriptionLabel.font = .medium13
        descriptionLabel.textColor = .london
        descriptionLabel.text = NSLocalizedString("Link and confirm your email to protect your account and gain access to payouts ", comment: "")
    }
    
    private func setEnableDoneButton(_ isEnable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnable
    }
    
    @IBAction private func emailTextFieldChanged(_ sender: Any) {
        if !EmailValidator(text: (emailTextField.text ?? "")).isCorrect {
            setEnableDoneButton(false)
        } else {
            setEnableDoneButton(true)
        }
    }
    
    @IBAction private func emailTextFieldEndEditing(_ sender: Any) {
        emailUnderlineView.backgroundColor = .montreal
    }
    
    @IBAction private func emailTextFieldBeginEditing(_ sender: Any) {
        emailUnderlineView.backgroundColor = .vilnius
    }
    
    @objc private func onDoneButtonTouchUpInside(sender: Any) {
        ProgressHUD.show()
        ProfileApiClient.bindEmail(email: emailTextField.text ?? "") { [weak self] (result) in
            ProgressHUD.dismiss()
            
            switch result {
            case .success(_):
                self?.viewModel.success(email: self?.emailTextField.text ?? "")
                
            case .failure(let error):
                self?.view.endEditing(true)
                Alert.showErrorToast(by: error)
            }
        }
    }
    
    @objc private func backButtonClicked() {
        viewModel.back()
    }
}
