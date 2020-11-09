//
//  AddPhoneNumberViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 24.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import PhoneNumberKit
import ProgressHUD

class AddPhoneNumberViewController: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Images {
        static let chooseArrows = UIImage(named: "ChooseArrows")
    }
    
    // MARK: - Instance Properties
    
    var viewModel: AddPhoneNumberViewModelProtocol!
    
    // MARK: -
    
    private var textField = PhoneNumberTextField()
    private var separatorView = UIView()
    private var infoLabel = UILabel()
    private var textFieldPlaceholderLabel = UILabel()
    
    private var currentNumberCountryCode = ""
    
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
        
        textField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentNumberCountryCode = "+" + "\(phoneNumberKit.countryCode(for: textField.partialFormatter.defaultRegion)!)"
    
        if textField.text?.isEmpty ?? true {
            textField.text = currentNumberCountryCode
        }
        
        setupTextFieldPlaceholder()
    }
    
    private func setupTextFieldPlaceholder() {
        textFieldPlaceholderLabel.isHidden = true
        textFieldPlaceholderLabel.snp.removeConstraints()
        
        let textFieldFontAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: textField.font!]
        let codeWidth = currentNumberCountryCode.size(withAttributes: textFieldFontAttributes).width
            
        self.textFieldPlaceholderLabel.snp.makeConstraints({ maker in
            maker.centerY.equalTo(self.textField)
            maker.leading.equalTo(self.textField.snp.leading).inset(48 + codeWidth)
        })
        
        self.textFieldPlaceholderLabel.isHidden = (self.textField.text != self.currentNumberCountryCode)
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
        
        textField.delegate = self
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = true
        textField.maxDigits = 30
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.font = .medium15
        textField.textColor = .sydney
        textField.addTarget(self, action: #selector(checkPhoneNumber), for: .editingChanged)
        (textField.leftView as? UIButton)?.addTarget(self, action: #selector(onTFLeftButtonTouchUpInside), for: .touchUpInside)
        (textField.leftView as? UIButton)?.setImage(Images.chooseArrows, for: .normal)
        (textField.leftView as? UIButton)?.semanticContentAttribute = .forceRightToLeft
        (textField.leftView as? UIButton)?.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                                          left: 0,
                                                                          bottom: 0,
                                                                          right: 8)
        
        textFieldPlaceholderLabel.text = viewModel.textFieldPlaceholder
        textFieldPlaceholderLabel.font = .medium15
        textFieldPlaceholderLabel.textColor = .minsk
        textFieldPlaceholderLabel.isHidden = true
        
        separatorView.backgroundColor = .vilnius
        
        infoLabel.font = .medium13
        infoLabel.textColor = .london
        infoLabel.text = viewModel.infoText
        infoLabel.numberOfLines = 0
        
        view.addSubview(textField)
        view.addSubview(separatorView)
        view.addSubview(infoLabel)
        view.addSubview(textFieldPlaceholderLabel)
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
        textField.snp.makeConstraints({ maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(33)
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview().inset(16)
        })
        
        separatorView.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview().inset(24)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(textField.snp.bottom).inset(-8)
            maker.height.equalTo(1)
        })
        
        infoLabel.snp.makeConstraints({ maker in
            maker.top.equalTo(separatorView.snp.bottom).inset(-16)
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
            print("1")
            self.alertView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            self.textField.snp.remakeConstraints({ maker in
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
                self.textField.snp.remakeConstraints({ maker in
                    maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(33)
                    maker.leading.equalToSuperview().inset(24)
                    maker.trailing.equalToSuperview().inset(16)
                })
                self.alertView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().inset(-100)
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
                print("2")
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
        navigationItem.rightBarButtonItem?.isEnabled = self.textField.isValidNumber
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.semibold15]
    }
    
    @objc private func onBackButtonTouchUpInside(sender: Any) {
        viewModel.goBack()
    }
    
    @objc private func onNextButtonTouchUpInside(sender: Any) {
        let phoneNumber = self.textField.text ?? ""
        
        viewModel.sendCodeTo(number: phoneNumber)
    }
    
    @objc private func checkPhoneNumber() {
        navigationItem.rightBarButtonItem?.isEnabled = self.textField.isValidNumber
    }
    
    @objc private func onTFLeftButtonTouchUpInside() {
        textField.becomeFirstResponder()
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

extension CountryCodePickerViewController {
    
    // MARK: - Instance Properties
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Select country", comment: "")
        
        let backButtonTitle = NSLocalizedString("Back", comment: "")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: #selector(closeController))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.medium15], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.medium15], for: .selected)
    }
    
    // MARK: -
    
    @objc private func closeController() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AddPhoneNumberViewController: UITextFieldDelegate {
    
    // MARK: - Instance Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location < currentNumberCountryCode.count {
            textFieldPlaceholderLabel.isHidden = false
            
            return false
        } else {
            textFieldPlaceholderLabel.isHidden = true
             
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        separatorView.backgroundColor = .vilnius
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        separatorView.backgroundColor = .montreal
                    
        if textField.text?.isEmpty ?? true {
            textField.text = currentNumberCountryCode
        }
    }
}
