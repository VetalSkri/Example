//
//  EditPhoneNumberViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 31.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import PhoneNumberKit
import ProgressHUD

class EditPhoneNumberViewController: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Images {
        static let chooseArrows = UIImage(named: "ChooseArrows")
    }
    
    // MARK: - Instance Properties
    
    var viewModel: EditPhoneNumberViewModelProtocol!
    
    // MARK: -
    
    private var currentNumberTextField = PhoneNumberTextField()
    private var newNumberTextField = PhoneNumberTextField()
    private var currentNumberSeparatorView = UIView()
    private var newNumberSeparatorView = UIView()
    private var infoLabel = UILabel()
    
    private var currentNumberPlaceholderLabel = UILabel()
    private var newNumberPlaceholderLabel = UILabel()
    
    private var currentNumberCountryCode = ""
    private var newNumberCountryCode = ""
    
    private let bag = DisposeBag()
    private let phoneNumberKit = PhoneNumberKit()
    
    private var alertView = UIView()
    private var alertImageView = UIImageView()
    private var alertTitleLabel = UILabel()
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupNavigationBar()
        binding()
        
        currentNumberTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentNumberCountryCode = "+" + "\(phoneNumberKit.countryCode(for: currentNumberTextField.partialFormatter.defaultRegion)!)"
        newNumberCountryCode = "+" + "\(phoneNumberKit.countryCode(for: newNumberTextField.partialFormatter.defaultRegion)!)"
    
        if currentNumberTextField.text?.isEmpty ?? true {
            currentNumberTextField.text = currentNumberCountryCode
        }
        
        if newNumberTextField.text?.isEmpty ?? true {
            newNumberTextField.text = newNumberCountryCode
        }
        
        setupCurrentTextFieldPlaceholder()
        setupNewTextFieldPlaceholder()
    }
    
    private func setupCurrentTextFieldPlaceholder() {
        currentNumberPlaceholderLabel.isHidden = true
        currentNumberPlaceholderLabel.snp.removeConstraints()
        
        let currentTFFontAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: currentNumberTextField.font!]
        let currentCodeWidth = currentNumberCountryCode.size(withAttributes: currentTFFontAttributes).width
            
        self.currentNumberPlaceholderLabel.snp.makeConstraints({ maker in
            maker.centerY.equalTo(self.currentNumberTextField)
            maker.leading.equalTo(self.currentNumberTextField.snp.leading).inset(48 + currentCodeWidth)
        })
        
        self.currentNumberPlaceholderLabel.isHidden = (self.currentNumberTextField.text != self.currentNumberCountryCode)
    }
    
    private func setupNewTextFieldPlaceholder() {
        newNumberPlaceholderLabel.isHidden = true
        newNumberPlaceholderLabel.snp.removeConstraints()
        
        let newTFFontAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: newNumberTextField.font!]
        let newCodeWidth = newNumberCountryCode.size(withAttributes: newTFFontAttributes).width

        newNumberPlaceholderLabel.snp.makeConstraints({ maker in
            maker.centerY.equalTo(newNumberTextField)
            maker.leading.equalTo(newNumberTextField.snp.leading).inset(48 + newCodeWidth)
        })
        
        newNumberPlaceholderLabel.isHidden = (newNumberTextField.text != newNumberCountryCode)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        alertView.addSubview(alertImageView)
        alertView.addSubview(alertTitleLabel)
        
        alertTitleLabel.font = .semibold13
        
        alertTitleLabel.textColor = .black
        
        alertTitleLabel.numberOfLines = 0
        
        alertView.cornerRadius = 12
        alertView.clipsToBounds = true
        alertView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        currentNumberTextField.delegate = self
        currentNumberTextField.withFlag = true
        currentNumberTextField.withPrefix = true
        currentNumberTextField.withExamplePlaceholder = true
        currentNumberTextField.withDefaultPickerUI = true
        currentNumberTextField.maxDigits = 30
        currentNumberTextField.attributedPlaceholder = NSAttributedString(string: currentNumberTextField.placeholder ?? "",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        currentNumberTextField.font = .medium15
        currentNumberTextField.textColor = .sydney
        currentNumberTextField.addTarget(self, action: #selector(checkPhoneNumber), for: .editingChanged)
        (currentNumberTextField.leftView as? UIButton)?.addTarget(self, action: #selector(onCurrentTFLeftButtonTouchUpInside), for: .touchUpInside)
        (currentNumberTextField.leftView as? UIButton)?.setImage(Images.chooseArrows, for: .normal)
        (currentNumberTextField.leftView as? UIButton)?.semanticContentAttribute = .forceRightToLeft
        (currentNumberTextField.leftView as? UIButton)?.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                                                       left: 0,
                                                                                       bottom: 0,
                                                                                       right: 8)
        
        currentNumberPlaceholderLabel.text = viewModel.firstTextFieldPlaceholder
        currentNumberPlaceholderLabel.font = .medium15
        currentNumberPlaceholderLabel.textColor = .minsk
        currentNumberPlaceholderLabel.isHidden = true

        newNumberTextField.delegate = self
        newNumberTextField.withFlag = true
        newNumberTextField.withPrefix = true
        newNumberTextField.withExamplePlaceholder = true
        newNumberTextField.withDefaultPickerUI = true
        newNumberTextField.maxDigits = 30
        newNumberTextField.attributedPlaceholder = NSAttributedString(string: newNumberTextField.placeholder ?? "",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        newNumberTextField.font = .medium15
        newNumberTextField.textColor = .sydney
        newNumberTextField.addTarget(self, action: #selector(checkPhoneNumber), for: .editingChanged)
        (newNumberTextField.leftView as? UIButton)?.addTarget(self, action: #selector(onNewTFLeftButtonTouchUpInside), for: .touchUpInside)
        (newNumberTextField.leftView as? UIButton)?.setImage(Images.chooseArrows, for: .normal)
        (newNumberTextField.leftView as? UIButton)?.semanticContentAttribute = .forceRightToLeft
        (newNumberTextField.leftView as? UIButton)?.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                                                   left: 0,
                                                                                   bottom: 0,
                                                                                   right: 8)
        
        newNumberPlaceholderLabel.text = viewModel.secondTextFieldPlaceholder
        newNumberPlaceholderLabel.font = .medium15
        newNumberPlaceholderLabel.textColor = .minsk
        newNumberPlaceholderLabel.isHidden = true
        
        currentNumberSeparatorView.backgroundColor = .montreal
        newNumberSeparatorView.backgroundColor = .montreal
        
        infoLabel.font = .medium13
        infoLabel.textColor = .london
        infoLabel.attributedText = viewModel.infoText
        infoLabel.numberOfLines = 0
        
        view.addSubview(currentNumberTextField)
        view.addSubview(currentNumberSeparatorView)
        view.addSubview(newNumberTextField)
        view.addSubview(newNumberSeparatorView)
        view.addSubview(infoLabel)
        view.addSubview(currentNumberPlaceholderLabel)
        view.addSubview(newNumberPlaceholderLabel)
        view.addSubview(alertView)
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-418)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        alertImageView.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(20)
        }
        alertTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(self.alertImageView.snp.right).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        currentNumberTextField.snp.makeConstraints({ maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(33)
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview().inset(16)
        })
        
        currentNumberSeparatorView.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(currentNumberTextField.snp.bottom).inset(-8)
            maker.height.equalTo(1)
        })
        
        newNumberTextField.snp.makeConstraints({ maker in
            maker.top.equalTo(currentNumberSeparatorView.snp.bottom).inset(-31)
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview().inset(16)
        })
        
        newNumberSeparatorView.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(newNumberTextField.snp.bottom).inset(-8)
            maker.height.equalTo(1)
        })
        
        infoLabel.snp.makeConstraints({ maker in
            maker.top.equalTo(newNumberSeparatorView.snp.bottom).inset(-16)
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview().inset(16)
        })
    }
    
    private func showErrorToast(message: String) {
                
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let image = UIImage(named: "error")
        let tintImage = image!.withRenderingMode(.alwaysTemplate)
        alertImageView.image = tintImage
        alertImageView.tintColor = .white
        
        alertView.backgroundColor = .black
        
        alertTitleLabel.textColor = .white
        
        alertImageView.contentMode = .scaleAspectFit
        
        let boldText  = NSLocalizedString("Error", comment: "") + ": "
        let attrs = [NSAttributedString.Key.font : UIFont.semibold13]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = message
        let attrsText = [NSAttributedString.Key.font : UIFont.medium13]
        let normalString =
            NSMutableAttributedString(string:normalText, attributes: attrsText)

        attributedString.append(normalString)
        alertTitleLabel.text = attributedString.string
        
        let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(animationСompleted), userInfo: nil, repeats: false)
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, options:  .curveEaseOut, animations: {

            self.alertView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            self.currentNumberTextField.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.alertView.snp.bottom).offset(8)
                maker.leading.equalToSuperview().inset(24)
                maker.trailing.equalToSuperview().inset(16)
            })
            self.alertImageView.snp.remakeConstraints { (make) in
                make.height.equalTo(24)
                make.width.equalTo(24)
                make.top.equalToSuperview().inset(18)
                make.left.equalToSuperview().inset(20)
            }
            self.alertTitleLabel.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().inset(20)
                make.left.equalTo(self.alertImageView.snp.right).offset(8)
                make.bottom.equalToSuperview().inset(20)
                make.right.equalToSuperview().inset(20)
            }
            self.view.layoutIfNeeded()
        }) { (result) in
            UIView.animate(withDuration: 1, delay: 2.0, options:  .curveEaseOut ,animations: {
                self.currentNumberTextField.snp.remakeConstraints({ maker in
                    maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(33)
                    maker.leading.equalToSuperview().inset(24)
                    maker.trailing.equalToSuperview().inset(16)
                })
                self.alertView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().inset(-100)
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func animationСompleted() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.leftBarButtonTitle, style: .plain, target: self, action: #selector(onBackButtonTouchUpInside(sender:)))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.medium15], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.medium15], for: .selected)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.rightBarButtonTitle, style: .plain, target: self, action: #selector(onNextButtonTouchUpInside(sender:)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.semibold15], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.semibold15], for: .selected)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.semibold15], for: .disabled)
        navigationItem.rightBarButtonItem?.isEnabled = self.currentNumberTextField.isValidNumber && self.newNumberTextField.isValidNumber
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.semibold15]
    }
    
    @objc private func onBackButtonTouchUpInside(sender: Any) {
        viewModel.goBack()
    }
    
    @objc private func onNextButtonTouchUpInside(sender: Any) {
        let currentNumber = self.currentNumberTextField.text ?? ""
        let newNumber = self.newNumberTextField.text ?? ""
        
        viewModel.sendCode(currentNumber: currentNumber, newNumber: newNumber)
    }
    
    @objc private func checkPhoneNumber() {
        navigationItem.rightBarButtonItem?.isEnabled = self.currentNumberTextField.isValidNumber && self.newNumberTextField.isValidNumber
    }
    
    @objc private func onCurrentTFLeftButtonTouchUpInside() {
        currentNumberTextField.becomeFirstResponder()
    }
    
    @objc private func onNewTFLeftButtonTouchUpInside() {
        newNumberTextField.becomeFirstResponder()
    }
    
    private func binding() {
        self.viewModel.isLoading.subscribeOn(MainScheduler.instance).subscribe(onNext: { isLoading in
            isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
        }).disposed(by: bag)
        
        self.viewModel.error.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] error in
            self?.showErrorToast(message: Alert.getMessage(by: error))
//            Alert.showErrorAlert(by: error)
        }).disposed(by: bag)
    }
}

// MARK: - UITextFieldDelegate

extension EditPhoneNumberViewController: UITextFieldDelegate {
    
    // MARK: - Instance Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.currentNumberTextField {
            if range.location < currentNumberCountryCode.count {
                currentNumberPlaceholderLabel.isHidden = false
                
                return false
            } else {
                currentNumberPlaceholderLabel.isHidden = true
                
                return true
            }
        } else if textField == self.newNumberTextField {
            if range.location < newNumberCountryCode.count {
                newNumberPlaceholderLabel.isHidden = false
                
                return false
            } else {
                newNumberPlaceholderLabel.isHidden = true
                
                return true
            }
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.currentNumberTextField {
            currentNumberSeparatorView.backgroundColor = .vilnius
        } else if textField == self.newNumberTextField {
            newNumberSeparatorView.backgroundColor = .vilnius
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.currentNumberTextField {
            currentNumberSeparatorView.backgroundColor = .montreal
                        
            if textField.text?.isEmpty ?? true {
                currentNumberTextField.text = currentNumberCountryCode
            }
        } else if textField == self.newNumberTextField {
            newNumberSeparatorView.backgroundColor = .montreal
            
            if textField.text?.isEmpty ?? true {
                newNumberTextField.text = newNumberCountryCode
            }
        }
    }
}
