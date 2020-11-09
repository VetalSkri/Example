//
//  EvaluateSupportAlertViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 03.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import ProgressHUD

class EvaluateSupportAlertViewController: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Images {
        static let selectedStar = UIImage(named: "SelectedStar")
        static let unselectedStar = UIImage(named: "UnselectedStar")
    }
    
    // MARK: - Instance Properties
    
    var viewModel: EvaluateSupportAlertViewModel!
    
    private let floatingView = UIView()
    private let alertView = UIView()
    private let pinView = UIView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let textView = PlaceholderTextView()
    private let button = UIButton()
    
    private var selectedButtonTag: Int?
    
    private var isSmallScreen: Bool {
        // iPhone 5, iPhone 4, iPhone SE (1st)
        UIScreen.main.bounds.height <= 568
    }
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupStackView()
        setupContraints()
        setupGestures()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showFloatingView()
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.clear
        
        floatingView.backgroundColor = UIColor.clear
        
        pinView.backgroundColor = UIColor.montreal
        pinView.cornerRadius = 3
        
        alertView.backgroundColor = UIColor.zurich
        alertView.cornerRadius = 11
        alertView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        titleLabel.text = viewModel.alertTitle
        titleLabel.font = UIFont.bold17
        titleLabel.textColor = UIColor.moscow
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        textView.placeholder = viewModel.textViewPlaceholder
        textView.placeholderFont = UIFont.medium15
        textView.font = UIFont.medium15
        textView.placeholderColor = UIColor.minsk
        textView.textColor = UIColor.moscow
        textView.cornerRadius = 8
        textView.borderColor = UIColor.montreal
        textView.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 16,
                                                   left: 11,
                                                   bottom: 20,
                                                   right: 11)
        
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.cornerRadius = 2
        button.backgroundColor = UIColor.moscow
        button.setTitleColor(UIColor.zurich, for: .normal)
        button.titleLabel?.font = UIFont.semibold15
        button.addTarget(self, action: #selector(onEvaluateButtonTouckUpInside(sender:)), for: .touchUpInside)
        
        self.view.addSubview(floatingView)
        
        floatingView.addSubview(pinView)
        floatingView.addSubview(alertView)
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(stackView)
        alertView.addSubview(textView)
        alertView.addSubview(button)
    }
    
    private func setupStackView() {
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        for i in 1...5 {
            let button = UIButton()
            button.setImage(Images.unselectedStar, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(onStarTouchUpInside(sender:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupContraints() {
        floatingView.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(self.view.snp.bottom)
        })
        
        pinView.snp.makeConstraints({ maker in
            maker.height.equalTo(4)
            maker.width.equalTo(40)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(alertView.snp.top).inset(-8)
            maker.top.equalToSuperview().inset(10)
        })
        
        alertView.snp.makeConstraints({ maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({ maker in
            maker.top.equalToSuperview().inset(40)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().inset(20)
        })
        
        let safeAreaBottomHeight = UIApplication.shared.windows[0].view.safeAreaInsets.bottom
        
        stackView.snp.makeConstraints({ maker in
            maker.top.equalTo(titleLabel.snp.bottom).inset(-24)
            maker.leading.greaterThanOrEqualToSuperview().inset(36)
            maker.trailing.greaterThanOrEqualToSuperview().inset(36)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(textView.snp.top).inset(-20 - safeAreaBottomHeight)
        })
        
        textView.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().inset(20)
            maker.height.greaterThanOrEqualTo(110)
        })
        
        button.snp.makeConstraints({ maker in
            maker.top.equalTo(textView.snp.bottom).inset(-24)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().inset(20)
            maker.height.equalTo(48)
            maker.bottom.equalToSuperview().inset(16)
        })
    }
    
    private func setupGestures() {
        let closeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognized(_:)))
        closeGesture.direction = .down
        
        self.view.addGestureRecognizer(closeGesture)
    }
    
    @objc private func onSwipeGestureRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        hideFloatingView(completion: { [unowned self] in
            self.viewModel.closeController()
        })
    }
    
    private func hideFloatingView(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.textView.resignFirstResponder()
            self.setupTextViewConstraints()
            
            self.button.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.textView.snp.bottom).inset(-24)
                maker.leading.equalToSuperview().inset(20)
                maker.trailing.equalToSuperview().inset(20)
                maker.height.equalTo(48)
                maker.bottom.equalToSuperview().inset(16)
            })
            
            self.floatingView.snp.remakeConstraints({ maker in
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.top.equalTo(self.view.snp.bottom)
            })
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
    
    private func showFloatingView() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.floatingView.snp.remakeConstraints({ maker in
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            })
            
            self.textView.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.view.snp.bottom)
                maker.leading.equalToSuperview().inset(20)
                maker.trailing.equalToSuperview().inset(20)
                maker.height.greaterThanOrEqualTo(110)
            })
            
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    private func showTextView(keyboardHeight: Int) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.stackView.spacing = 10
            self.setupTextViewConstraints()
                        
            self.floatingView.snp.remakeConstraints({ maker in
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.bottom.equalToSuperview()
            })
            
            self.button.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.textView.snp.bottom).inset(-24)
                maker.leading.equalToSuperview().inset(20)
                maker.trailing.equalToSuperview().inset(20)
                maker.height.equalTo(48)
                maker.bottom.equalToSuperview().inset(16 + keyboardHeight)
            })
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupTextViewConstraints() {
        self.textView.snp.removeConstraints()
        
        if self.isSmallScreen {
            self.titleLabel.snp.remakeConstraints({ maker in
                maker.top.equalToSuperview().inset(16)
                maker.leading.equalToSuperview().inset(20)
                maker.trailing.equalToSuperview().inset(20)
            })
            
            self.stackView.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.titleLabel.snp.bottom).inset(-16)
                maker.leading.greaterThanOrEqualToSuperview().inset(56)
                maker.trailing.greaterThanOrEqualToSuperview().inset(56)
                maker.height.equalTo(30)
                maker.centerX.equalToSuperview()
            })
        } else {
            self.stackView.snp.remakeConstraints({ maker in
                maker.top.equalTo(self.titleLabel.snp.bottom).inset(-16)
                maker.leading.greaterThanOrEqualToSuperview().inset(56)
                maker.trailing.greaterThanOrEqualToSuperview().inset(56)
                maker.centerX.equalToSuperview()
            })
        }
            
        self.textView.snp.remakeConstraints({ maker in
            maker.top.equalTo(self.stackView.snp.bottom).inset(-20)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().inset(20)
            maker.height.greaterThanOrEqualTo(90)
        })
    }
    
    @objc private func onStarTouchUpInside(sender: UIButton) {
        selectedButtonTag = sender.tag
        
        for view in stackView.arrangedSubviews {
            guard let button = view as? UIButton else {
                fatalError()
            }
            
            if button.tag <= selectedButtonTag! {
                button.setImage(Images.selectedStar, for: .normal)
            } else {
                button.setImage(Images.unselectedStar, for: .normal)
            }
        }
        
        self.textView.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: Int = Int(keyboardSize.height)
            
            showTextView(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc private func onEvaluateButtonTouckUpInside(sender: Any) {
        ProgressHUD.show()
        
        guard let starCount = selectedButtonTag else {
            fatalError()
        }
        
        viewModel.evaluateSupport(starCount: starCount, comment: textView.text, onSuccess: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            ProgressHUD.dismiss()
            self.hideFloatingView(completion: {
                self.viewModel.closeController()
            })
        }, onFailure: { error in
            ProgressHUD.dismiss()
            Alert.showErrorAlert(by: error)
        })
    }
}
