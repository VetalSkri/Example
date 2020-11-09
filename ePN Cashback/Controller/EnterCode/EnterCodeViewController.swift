//
//  EnterCodeViewController.swift
//  Backit
//
//  Created by Elina Batyrova on 26.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import ProgressHUD

class EnterCodeViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var viewModel: EnterCodeViewModelProtocol!
    
    // MARK: -
    
    private var containerView = UIView()
    private var centerView = UIView()
    private var instructionLabel = UILabel()
    private var enterCodeView = EnterCodeView()
    private var errorMessageLabel = UILabel()
    private var retryInformationLabel = UILabel()
    private var retryButton = UIButton()
    private let retryButtonDashedView = UIView()
    
    private var alertView = UIView()
    private var alertImageView = UIImageView()
    private var alertTitleLabel = UILabel()
    
    private let bag = DisposeBag()
    
    private var timer: Timer?
    private var secondsLeft = 60
    
    // MARK: - Instance Methods
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
        binding()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(onTimerFires),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enterCodeView.startToFill()
    }
    
    // MARK: -
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.leftBarButtonTitle, style: .plain, target: self, action: #selector(onBackButtonTouchUpInside(sender:)))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.medium15], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.medium15], for: .selected)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.semibold15]
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
        
        self.view.addSubview(alertView)
        
        enterCodeView.delegate = self
        
        instructionLabel.font = .medium15
        instructionLabel.textColor = .moscow
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .center
        instructionLabel.attributedText = viewModel.instruction
        
        errorMessageLabel.text = viewModel.errorMessage
        errorMessageLabel.font = .medium13
        errorMessageLabel.textColor = .prague
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
        
        retryInformationLabel.text = viewModel.timerDescription + "00:\(secondsLeft)"
        retryInformationLabel.font = .medium13
        retryInformationLabel.textColor = .london
        retryInformationLabel.numberOfLines = 0
        retryInformationLabel.textAlignment = .center
        
        retryButton.setTitle(viewModel.sendAgainButtonTitle, for: .normal)
        retryButton.addTarget(self, action: #selector(onSendAgainButtonTouchUpInside), for: .touchUpInside)
        retryButton.titleLabel?.font = .semibold13
        retryButton.setTitleColor(.sydney, for: .normal)
        retryButton.isHidden = true
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: retryButton.titleLabel!.intrinsicContentSize.width, y: 0)])
        shapeLayer.path = path
        
        retryButtonDashedView.layer.addSublayer(shapeLayer)
        retryButtonDashedView.clipsToBounds = true
        retryButtonDashedView.isHidden = true
        
        self.view.addSubview(containerView)
        
        containerView.addSubview(centerView)
        containerView.addSubview(errorMessageLabel)
        containerView.addSubview(retryInformationLabel)
        containerView.addSubview(retryButton)
        containerView.addSubview(retryButtonDashedView)
        
        centerView.addSubview(instructionLabel)
        centerView.addSubview(enterCodeView)
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

        instructionLabel.snp.makeConstraints({ maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(enterCodeView.snp.top).inset(-32)
        })
        
        enterCodeView.snp.makeConstraints({ maker in
            maker.width.equalTo(272)
            maker.height.equalTo(48)
            maker.leading.trailing.bottom.equalToSuperview()
        })
        
        centerView.snp.makeConstraints({ maker in
            maker.centerY.centerX.equalToSuperview()
        })
        
        containerView.snp.makeConstraints({ maker in
            maker.edges.equalToSuperview()
        })
        
        errorMessageLabel.snp.makeConstraints({ maker in
            maker.top.equalTo(centerView.snp.bottom).inset(-12)
            maker.leading.trailing.equalToSuperview().inset(16)
        })
        
        retryInformationLabel.snp.makeConstraints({ maker in
            maker.bottom.equalToSuperview().inset(16)
            maker.centerX.equalToSuperview()
            maker.top.greaterThanOrEqualTo(errorMessageLabel).inset(8)
        })
        
        retryButton.snp.makeConstraints({ maker in
            maker.top.greaterThanOrEqualTo(errorMessageLabel).inset(8)
            maker.centerX.equalToSuperview()
        })
        
        retryButtonDashedView.snp.makeConstraints({ maker in
            maker.bottom.equalToSuperview().inset(24)
            maker.top.equalTo(retryButton.snp.bottom)
            maker.height.equalTo(1)
            maker.leading.equalTo(retryButton.snp.leading)
            maker.trailing.equalTo(retryButton.snp.trailing)
        })
    }
    
    private func showErrorToast(message: String) {
                
        enterCodeView.isLock = true
        
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
                self.alertView.snp.makeConstraints { (make) in
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
        self.enterCodeView.isLock = false
    }
    
    private func binding() {
        self.viewModel.isLoading.subscribeOn(MainScheduler.instance).subscribe(onNext: { isLoading in
            isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
        }).disposed(by: bag)
        
        self.viewModel.error.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] error in
            guard let `self` = self else {
                return
            }
            if (error as NSError).code != 400045 {
                self.showErrorToast(message: Alert.getMessage(by: error))
            }
            self.enterCodeView.setErrorState()
            self.errorMessageLabel.isHidden = false
        }).disposed(by: bag)
        
        self.viewModel.isCodeSent.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] error in
            guard let `self` = self else {
                return
            }
            
            if let error = error {
                Alert.showErrorAlert(by: error)
                
                self.retryButton.isHidden = false
                self.retryButtonDashedView.isHidden = false
                self.retryInformationLabel.isHidden = true
            } else {
                self.retryButton.isHidden = true
                self.retryButtonDashedView.isHidden = true
                self.retryInformationLabel.isHidden = false
            }
            
        }).disposed(by: bag)
    }
    
    @objc private func onTimerFires() {
        secondsLeft -= 1
        
        let secondsToShow = secondsLeft >= 10 ? " 00:\(secondsLeft)" : " 00:0\(secondsLeft)"
        
        retryInformationLabel.text = viewModel.timerDescription + secondsToShow
        
        if secondsLeft <= 0 {
            retryButton.isHidden = false
            retryButtonDashedView.isHidden = false
            retryInformationLabel.isHidden = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func onSendAgainButtonTouchUpInside() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(onTimerFires),
                                          userInfo: nil,
                                          repeats: true)
        secondsLeft = 60
        
        viewModel.retryCodeSending()
    }
    
    @objc private func onBackButtonTouchUpInside(sender: Any) {
        viewModel.goBack()
    }
    
    @objc private func onDoneButtonTouchUpInside(sender: Any) {
        viewModel.send(code: self.enterCodeView.getCode())
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: Int = Int(keyboardSize.height)
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.containerView.snp.remakeConstraints({ maker in
                    maker.top.leading.trailing.equalToSuperview()
                    maker.bottom.equalToSuperview().inset(keyboardHeight)
                })
                
                self?.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - EnterCodeViewDelegate

extension EnterCodeViewController: EnterCodeViewDelegate {
    
    // MARK: -
    
    func didFinishEntering(code: String) {
        print(code)
        
        if code.count != 5 {
            enterCodeView.setErrorState()
            errorMessageLabel.isHidden = false
        } else {
            errorMessageLabel.isHidden = true
            viewModel.send(code: code)
        }
    }
}
