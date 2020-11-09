//
//  CloseChatAlertViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 30.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import ProgressHUD

class CloseChatAlertViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var viewModel: CloseChatAlertViewModel!
    
    private let floatingView = UIView()
    private let alertView = UIView()
    private let pinView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupContraints()
        setupGestures()
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
        titleLabel.textColor = UIColor.moscow
        titleLabel.font = UIFont.bold17
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = viewModel.alertDescription
        descriptionLabel.textColor = UIColor.minsk
        descriptionLabel.font = UIFont.medium15
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        leftButton.setTitle(viewModel.alertLeftButtonTitle, for: .normal)
        leftButton.backgroundColor = UIColor.paris
        leftButton.setTitleColor(UIColor.sydney, for: .normal)
        leftButton.titleLabel?.font = UIFont.semibold15
        leftButton.cornerRadius = 2
        leftButton.addTarget(self, action: #selector(onLeftButtonTouchUpInside(sender:)), for: .touchUpInside)
        
        rightButton.setTitle(viewModel.alertRightButtonTitle, for: .normal)
        rightButton.backgroundColor = UIColor.moscow
        rightButton.setTitleColor(UIColor.zurich, for: .normal)
        rightButton.titleLabel?.font = UIFont.semibold15
        rightButton.cornerRadius = 2
        rightButton.addTarget(self, action: #selector(onRightButtonTouchUpInside(sender:)), for: .touchUpInside)
        
        self.view.addSubview(floatingView)
        
        floatingView.addSubview(pinView)
        floatingView.addSubview(alertView)
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(leftButton)
        alertView.addSubview(rightButton)
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
        
        descriptionLabel.snp.makeConstraints({ maker in
            maker.top.equalTo(titleLabel.snp.bottom).inset(-12)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().inset(20)
        })
        
        leftButton.snp.makeConstraints({ maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).inset(-32)
            maker.leading.equalToSuperview().inset(20)
            maker.height.equalTo(48)
        })
        
        let safeAreaBottomHeight = UIApplication.shared.windows[0].view.safeAreaInsets.bottom
        
        rightButton.snp.makeConstraints({ maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).inset(-32)
            maker.trailing.equalToSuperview().inset(20)
            maker.left.equalTo(leftButton.snp.right).inset(-11)
            maker.height.equalTo(48)
            maker.width.equalTo(leftButton.snp.width)
            maker.bottom.equalToSuperview().inset(16 + safeAreaBottomHeight)
        })
    }
    
    private func hideFloatingView(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else {
                return
            }
            
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
                maker.bottom.equalToSuperview()
            })
            
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
    
    @objc private func onLeftButtonTouchUpInside(sender: Any) {
        hideFloatingView(completion: { [unowned self] in
            self.viewModel.closeController()
        })
    }
    
    @objc private func onRightButtonTouchUpInside(sender: Any) {
        ProgressHUD.show()
        
        viewModel.closeChat(onSuccess: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            ProgressHUD.dismiss()
            self.hideFloatingView(completion: {
                self.viewModel.returnToChatList()
            })
        }, onFailure: { error in
            ProgressHUD.dismiss()
            Alert.showErrorAlert(by: error)
        })
    }
}
