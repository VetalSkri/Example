//
//  PopUpAlertViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 17.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import RxSwift

class PopUpAlertViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var viewModel: PopUpAlertViewModelProtocol!
    
    // MARK: -
    
    private let floatingView = UIView()
    private let alertView = UIView()
    private let pinView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let linkButtonActivityIndicator = UIActivityIndicatorView()
    private let linkButton = UIButton()
    private let linkButtonDashedView = UIView()
    private let button = EPNButton(style: .primary, size: .large1)
    
    private let bag = DisposeBag()
    
    weak var delegate: PopUpAlertDelegate!
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupContraints()
        setupGestures()
        binding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showFloatingView()
    }
    
    // MARK: -
    
    private func setupView() {
        self.view.backgroundColor = UIColor.clear
        
        floatingView.backgroundColor = UIColor.clear
        
        pinView.backgroundColor = UIColor.montreal
        pinView.cornerRadius = 3
        
        alertView.backgroundColor = UIColor.zurich
        alertView.cornerRadius = 11
        alertView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        titleLabel.text = viewModel.title
        titleLabel.font = UIFont.bold24
        titleLabel.textColor = UIColor.sydney
        
        descriptionLabel.text = viewModel.description
        descriptionLabel.font = UIFont.medium15
        descriptionLabel.textColor = UIColor.moscow
        descriptionLabel.numberOfLines = 0
        
        button.getTransionButton.setTitle(viewModel.buttonTitle, for: .normal)
        button.handler = { [weak self] button in
            self?.onButtonTouchUpInside(sender: button)
        }
        
        self.view.addSubview(floatingView)
        
        floatingView.addSubview(pinView)
        floatingView.addSubview(alertView)
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(button)
        
        if viewModel.isLinkRequired {
            linkButton.setTitle(viewModel.linkTitle, for: .normal)
            linkButton.titleLabel?.font = UIFont.semibold13
            linkButton.setTitleColor(UIColor.moscow, for: .normal)
            linkButton.addTarget(self, action: #selector(self.onLinkButtonTouchUpInside(sender:)), for: .touchUpInside)
            
            linkButtonActivityIndicator.hidesWhenStopped = true
            linkButtonActivityIndicator.style = .gray
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.minsk.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [4, 4]

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: linkButton.titleLabel!.intrinsicContentSize.width, y: 0)])
            shapeLayer.path = path
            
            linkButtonDashedView.layer.addSublayer(shapeLayer)
            linkButtonDashedView.clipsToBounds = true
            
            alertView.addSubview(linkButton)
            alertView.addSubview(linkButtonDashedView)
            alertView.addSubview(linkButtonActivityIndicator)
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
        
        descriptionLabel.snp.makeConstraints({ maker in
            maker.top.equalTo(titleLabel.snp.bottom).inset(-12)
            maker.leading.equalToSuperview().inset(20)
            maker.trailing.equalToSuperview().inset(20)
        })
        
        let safeAreaBottomHeight = UIApplication.shared.windows[0].view.safeAreaInsets.bottom
        
        if viewModel.isLinkRequired {
            linkButton.snp.makeConstraints({ maker in
                maker.leading.equalToSuperview().inset(20)
                maker.top.equalTo(descriptionLabel.snp.bottom).inset(-16)
            })
            
            linkButtonDashedView.snp.makeConstraints({ maker in
                maker.leading.equalTo(linkButton.snp.leading)
                maker.trailing.equalTo(linkButton.snp.trailing)
                maker.height.equalTo(1)
                maker.top.equalTo(linkButton.snp.bottom).inset(2)
            })
            
            linkButtonActivityIndicator.snp.makeConstraints({ maker in
                maker.leading.equalTo(linkButton.snp.leading)
                maker.centerY.equalTo(linkButton.snp.centerY)
            })
            
            button.snp.makeConstraints({ maker in
                maker.top.equalTo(linkButtonDashedView.snp.bottom).inset(-32)
                maker.leading.equalToSuperview().inset(20)
                maker.trailing.equalToSuperview().inset(20)
                maker.bottom.equalToSuperview().inset(20 + safeAreaBottomHeight)
            })
        } else {
            button.snp.makeConstraints({ maker in
                maker.top.equalTo(descriptionLabel.snp.bottom).inset(-32)
                maker.leading.equalToSuperview().inset(20)
                maker.trailing.equalToSuperview().inset(20)
                maker.bottom.equalToSuperview().inset(20 + safeAreaBottomHeight)
            })
        }
    }
    
    private func setupGestures() {
        let closeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGestureRecognized(_:)))
        closeGesture.direction = .down
        
        self.view.addGestureRecognizer(closeGesture)
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
    
    @objc private func onSwipeGestureRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        hideFloatingView(completion: { [unowned self] in
            self.viewModel.close()
        })
    }
    
    private func onButtonTouchUpInside(sender: Any) {
        hideFloatingView(completion: { [unowned self] in
            self.viewModel.buttonAction()
        })
    }
    
    @objc private func onLinkButtonTouchUpInside(sender: Any) {
        self.viewModel.linkAction()
    }
    
    private func binding() {
        self.viewModel.isLinkActionLoading?.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] isLoading in
            self?.linkButton.isHidden = isLoading
            self?.linkButtonDashedView.isHidden = isLoading
            
            if isLoading {
                self?.linkButtonActivityIndicator.startAnimating()
            } else {
                self?.linkButtonActivityIndicator.stopAnimating()
            }
        }).disposed(by: bag)
        
        self.viewModel.error.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] error in
//            Alert.showErrorAlert(by: error)
            self?.delegate?.showAlert(message: Alert.getMessage(by: error), error: true)
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        
        self.viewModel.alertMessage?.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] message in
//            Alert.showAlert(by: message, message: "")
            self?.delegate?.showAlert(message: message, error: false)
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
    }
}

protocol PopUpAlertDelegate: AnyObject {
    func showAlert(message: String, error: Bool)
}
