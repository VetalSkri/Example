//
//  PurseCollectionViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 01/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Toast_Swift
import Repeat
import SnapKit
import ProgressHUD
import TransitionButton

public protocol PurseCollectionViewCellDelegate: class {
    func menuButtonClicked(purseId: Int)
}

class PurseCollectionViewCell: UICollectionViewCell {
 
    enum CellPurseType {
        case normal
        case toConfirm
        case confirmEmail
        case confirmSms
        case charity
    }
    
    weak var delegate: PurseCollectionViewCellDelegate?
    private var purseId: Int!
    private var purseType: PurseType!
    private var viewModel: PaymentsModelType!
    
    //ToConfirmView
    @IBOutlet weak var toConfirmContainerView: UIView!
    @IBOutlet weak var confirmWalletTitleLabel: UILabel!
    @IBOutlet weak var confirmWalletNumberLabel: UILabel!
    @IBOutlet weak var toConfirmButton: TransitionButton!
    
    //Confirm in phone view
    @IBOutlet weak var confirmInPhonePurseNumberLabel: UILabel!
    @IBOutlet weak var confirmInPhoneNumberView: UIView!
    @IBOutlet weak var confirmInPhoneNumberTitleLabel: UILabel!
    @IBOutlet weak var confirmPhoneNumberLabel: UILabel!
    @IBOutlet weak var confirmCodeTextField: UITextField!
    @IBOutlet weak var confirmCodeContainerView: UIView!
    @IBOutlet weak var phoneResendAgainTimerLabel: UILabel!
    @IBOutlet weak var phoneResendAgainButton: EPNLinkLabel!
    @IBOutlet weak var phoneResendAgainActivityIndicator: UIActivityIndicatorView!
    
    
    //Confirm In email View
    @IBOutlet weak var confirmInEmailPurseNumberLabel: UILabel!
    @IBOutlet weak var confirmInEmailView: UIView!
    @IBOutlet weak var confirmInEmailTitleLabel: UILabel!
    @IBOutlet weak var confirmInEmailLabel: UILabel!
    @IBOutlet weak var resendInEmailButton: EPNLinkLabel!
    @IBOutlet weak var resendActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resendAgainTimerLabel: UILabel!
    
    
    //CommonCardPurseView
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardNumberTitle: UILabel!
    @IBOutlet weak var purseNumberValue: UILabel!
    @IBOutlet weak var validityDateLabel: UILabel!
    @IBOutlet weak var validityTitleLabel: UILabel!
    @IBOutlet weak var purseLogoImageView: UIImageView!
    var logoPurse = PurseLogoView()
    @IBOutlet weak var deleteButton: UIButton!
    
    
    //Charity Purse View Fields
    @IBOutlet weak var charityPurseView: UIView!
    @IBOutlet weak var charityTitleLabel: UILabel!
    @IBOutlet weak var charitySubtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    private func setupSubviews() {
    containerView.addSubview(logoPurse)

        logoPurse.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(CommonStyle.modalCornerRadius)
            make.right.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        logoPurse.singleImageView.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.lessThanOrEqualTo(120)
        }
    }
    
    
    func setupCell(purse: UserPurseObject, viewModel: PaymentsModelType, selected: Bool, rotated: Bool, purseId: Int) {
        self.purseId = purseId
        self.viewModel = viewModel
        self.setupStyle(selected: selected)
        
        deleteButton.setImage(UIImage(named: "deleted"), for: .normal)
        
        //IF PURSE IS CHARITY
        if purse.isCharity {
            charityPurseView.isHidden = false
            charityPurseView.backgroundColor = .toronto
            containerView.isHidden = true
            toConfirmContainerView.isHidden = true
            confirmInEmailView.isHidden = true
            confirmInPhoneNumberView.isHidden = true
            charityTitleLabel.font = .medium15
            charityTitleLabel.textColor = .zurich
            charityTitleLabel.text = NSLocalizedString("CharityTitle", comment: "")
            
            
            charitySubtitleLabel.font = .bold17
            charitySubtitleLabel.textColor = .zurich
            charitySubtitleLabel.text = NSLocalizedString("CharitySubitle", comment: "")
            
            return
        }
        setupPurseFields(purse: purse)
        if purse.isConfirm {    //CONFIRMED PURSE
            setupVisibilityViews(for: .normal)
        } else {      //NON CONFIRMED PURSE
            setupUnconfirmedFields(rotated: rotated, purseNumber: (purse.purseCardObject != nil ? purse.purseCardObject?.account : purse.purse) ?? "")
        }
    }
    
    private func binding() {
        viewModel.isCounting.subscribe(onNext: {
            print($0)
        })
    }
    
    private func setupUnconfirmedFields(rotated: Bool, purseNumber: String) {
        guard let type = viewModel.confirmType(forPurseId: self.purseId) else {
            confirmInEmailTitleLabel.text = ""
            confirmInEmailLabel.text = ""
            resendInEmailButton.changeColorOfLink(for: "")
            setupVisibilityViews(for: .toConfirm)
            confirmWalletTitleLabel.text = NSLocalizedString("Сonfirm a wallet", comment: "")
            if let findedPurse = viewModel.purse(forId: purseId) {
                confirmWalletNumberLabel.text = findedPurse.purseCardObject != nil ? findedPurse.purseCardObject?.account : findedPurse.purse
            } else {
                confirmWalletNumberLabel.text = ""
            }
            toConfirmButton.isHidden = false
            return
        }
        switch type {
        case .email:
            confirmInEmailTitleLabel.text = NSLocalizedString("The wallet confirmation email is sent", comment: "")
            confirmInEmailLabel.text = viewModel.confirmValue(forPurseId: self.purseId)
            resendInEmailButton.changeColorOfLink(for: NSLocalizedString("Send again", comment: ""))
            resendInEmailButton.layoutIfNeeded()
//            resendInEmailButton.addSyblayerDashed(name: "dashedLine")
            break
        case .phone:
            confirmInPhoneNumberTitleLabel.text = NSLocalizedString("Activation code is sent to", comment: "")
            confirmPhoneNumberLabel.text = viewModel.confirmValue(forPurseId: self.purseId)
            phoneResendAgainButton.style = .full
            phoneResendAgainButton.changeColorOfLink(for: NSLocalizedString("Send again", comment: ""))
//            phoneResendAgainButton.backgroundColor = .clear
            phoneResendAgainButton.font = .medium15
            phoneResendAgainButton.textColor = .sydney
            phoneResendAgainButton.layoutIfNeeded()
//            phoneResendAgainButton.addSyblayerDashed(name: "dashedLine")
            confirmCodeTextField.text = ""
            break
        }
        if !rotated {   //SHOW TO CONFIRM BUTTON
            setupVisibilityViews(for: .toConfirm)
            confirmWalletTitleLabel.text = NSLocalizedString("Сonfirm a wallet", comment: "")
            if let findedPurse = viewModel.purse(forId: purseId) {
                confirmWalletNumberLabel.text = findedPurse.purseCardObject != nil ? findedPurse.purseCardObject?.account : findedPurse.purse
            } else {
                confirmWalletNumberLabel.text = purseNumber
            }
            toConfirmButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
            toConfirmButton.isHidden = false
        } else {                //CONFIRM ACTION
            self.tryToFindExistTimerAndApply()
            switch type {
            case .email:
                setupVisibilityViews(for: .confirmEmail)
                break
            case .phone:
                setupVisibilityViews(for: .confirmSms)
                break
            }
        }
    }
    
    private func setupVisibilityViews(for type: CellPurseType) {
        containerView.isHidden = type != .normal
        charityPurseView.isHidden = type != .charity
        toConfirmContainerView.isHidden = type != .toConfirm
        confirmInEmailView.isHidden = type != .confirmEmail
        confirmInPhoneNumberView.isHidden = type != .confirmSms
    }
    
    private func setupPurseFields(purse: UserPurseObject) {
        if (purse.purseType == PurseType.cardpay || purse.purseType == PurseType.cardpayUsd || purse.purseType == PurseType.cardUrk || purse.purseType == PurseType.cardUrkV2) {
            cardNumberTitle.text = purse.name
            validityTitleLabel.text = NSLocalizedString("Valid period", comment: "")
            purseNumberValue.text = purse.purseCardObject?.account
            confirmInPhonePurseNumberLabel.text = purse.purseCardObject?.account
            confirmInEmailPurseNumberLabel.text = purse.purseCardObject?.account
            validityDateLabel.text = "\(purse.purseCardObject?.expMonth ?? 0)/\(purse.purseCardObject?.expYear ?? 0)"
            validityDateLabel.isHidden = false
            validityTitleLabel.isHidden = false
        } else {
            cardNumberTitle.text = purse.name
            purseNumberValue.text = purse.purse
            confirmInPhonePurseNumberLabel.text = purse.purse
            confirmInEmailPurseNumberLabel.text = purse.purse
            validityDateLabel.isHidden = true
            validityTitleLabel.isHidden = true
        }
        purseLogoImageView.image = purse.purseType != nil ? UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseLogo(forType: purse.purseType!)) : UIImage()
        
        if purse.purseType == PurseType.khabensky {
            logoPurse.setup(type: .single, image: UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseSmalllogo(forType: purse.purseType!)))
        } else {
            if purse.purseType == PurseType.cardpay {
                logoPurse.setup(type: .multiCard, image: nil)
            } else {
                logoPurse.setup(type: .single, image: purse.purseType != nil ? UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseLogo(forType: purse.purseType!)) : UIImage())
            }
        }
    }
    
    private func setupStyle(selected: Bool) {
        containerView.cornerRadius = CommonStyle.cornerRadius
        containerView.borderColor = selected ? .sydney : .montreal
        containerView.borderWidth = CommonStyle.borderWidth
        charityPurseView.borderColor = selected ? .sydney : .montreal
        charityPurseView.borderWidth = CommonStyle.borderWidth
        toConfirmContainerView.borderWidth = CommonStyle.borderWidth
        toConfirmContainerView.borderColor = .montreal
        confirmInPhoneNumberView.borderWidth = CommonStyle.borderWidth
        confirmInPhoneNumberView.borderColor = .montreal
        confirmInEmailView.borderWidth = CommonStyle.borderWidth
        confirmInEmailView.borderColor = .montreal
        cardNumberTitle.font = .medium15
        purseNumberValue.font = .semibold17
        validityTitleLabel.font = .medium15
        validityDateLabel.font = .semibold17
        cardNumberTitle.textColor = .sydney
        validityTitleLabel.textColor = .sydney
        purseNumberValue.textColor = .london
        validityDateLabel.textColor = .london
        confirmWalletTitleLabel.font = .medium15
        confirmWalletTitleLabel.textColor = .sydney
        confirmWalletNumberLabel.font = .bold17
        confirmWalletNumberLabel.textColor = .sydney
        toConfirmButton.titleLabel?.font = .semibold17
        toConfirmButton.setTitleColor(.zurich, for: .normal)
        toConfirmButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        (toConfirmButton as UIButton).cornerRadius = CommonStyle.cornerRadius
        toConfirmButton.backgroundColor = .sydney
        confirmInEmailTitleLabel.font = .medium15
        confirmInEmailTitleLabel.textColor = .sydney
        confirmInEmailTitleLabel.adjustsFontSizeToFitWidth = true
        confirmInEmailTitleLabel.minimumScaleFactor = 0.5
        confirmInEmailPurseNumberLabel.font = .medium15
        confirmInEmailPurseNumberLabel.textColor = .sydney
        confirmInEmailPurseNumberLabel.adjustsFontSizeToFitWidth = true
        confirmInEmailPurseNumberLabel.minimumScaleFactor = 0.5
        confirmInEmailLabel.font = .semibold15
        confirmInEmailLabel.textColor = .sydney
        resendInEmailButton.style = .full
        resendInEmailButton.font = .medium15
        resendInEmailButton.textColor = .sydney
    
        switch viewModel.confirmType(forPurseId: self.purseId) {
        case .phone:
            phoneResendAgainButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendInPhoneButtonClicked)))
            phoneResendAgainButton.backgroundColor = .clear
            phoneResendAgainButton.isUserInteractionEnabled = true
        case .email:
            resendInEmailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendInEmailButtonClicked)))
            resendInEmailButton.backgroundColor = .clear
            resendInEmailButton.isUserInteractionEnabled = true
        default:
            resendInEmailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendInEmailButtonClicked)))
            resendInEmailButton.backgroundColor = .clear
            resendInEmailButton.isUserInteractionEnabled = true

        }
        

        confirmInEmailLabel.font = .semibold15
        confirmInEmailLabel.textColor = .sydney
        resendActivityIndicator.isHidden = true
        resendAgainTimerLabel.font = .medium15
        resendAgainTimerLabel.textColor = .minsk
        resendAgainTimerLabel.isHidden = true
        confirmInPhoneNumberTitleLabel.font = .medium15
        confirmInPhoneNumberTitleLabel.textColor = .sydney
        confirmInPhoneNumberTitleLabel.adjustsFontSizeToFitWidth = true
        confirmInPhoneNumberTitleLabel.minimumScaleFactor = 0.5
        confirmInPhoneNumberTitleLabel.font = .medium15
        confirmInPhoneNumberTitleLabel.textColor = .sydney
        confirmInPhoneNumberTitleLabel.adjustsFontSizeToFitWidth = true
        confirmInPhoneNumberTitleLabel.minimumScaleFactor = 0.5
        confirmPhoneNumberLabel.font = .medium15
        confirmPhoneNumberLabel.textColor = .sydney
        confirmCodeTextField.font = .medium15
        confirmCodeTextField.textColor = .sydney
        confirmCodeTextField.placeholder = NSLocalizedString("Code", comment: "")
        phoneResendAgainTimerLabel.font = .medium15
        phoneResendAgainTimerLabel.textColor = .minsk
        phoneResendAgainTimerLabel.isHidden = true
        phoneResendAgainActivityIndicator.isHidden = true
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        delegate?.menuButtonClicked(purseId: purseId)
    }
    
    @IBAction func toConfirmButtonClicked(_ sender: Any) {
        self.tryToFindExistTimerAndApply()
        let type = viewModel.confirmType(forPurseId: self.purseId)
        if type == nil {    //PURSE CONFIRMATION INFO NOT CONTAINS IN LOCAL SETTINGS, TRY TO GET FROM SERVER
            toConfirmButton.startAnimation()
            viewModel.resendCode(forPurseId: self.purseId) { [weak self] (errorString, confirmObject) in
                if let self = self {
                    if let errorString = errorString {     //RESEND CODE REQUEST FAILURE
                        self.toConfirmButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                        if var topController = UIApplication.shared.keyWindow?.rootViewController {
                            while let presentedViewController = topController.presentedViewController {
                                topController = presentedViewController
                            }
                            var toastStyle = ToastStyle()
                            toastStyle.messageAlignment = .center
                            toastStyle.messageFont = .medium15
                            topController.view.makeToast(errorString, duration: 0.6, position: .bottom, style: toastStyle)
                        }
                    } else {                                                //RESEND CODE REQUEST SUCCESS
                        self.toConfirmButton.stopAnimation()
                        PaymentUtils.shared.saveNewPurse(purse: confirmObject!, purseId: self.purseId)
                        self.tryToFindExistTimerAndApply(existTimer: self.viewModel.createNewTimer(forPurseId: self.purseId))
                        self.viewModel.rotatePurseCard(purseId: self.purseId)
                        
                        if (confirmObject?.type ?? NewPurseConfirmType.email == NewPurseConfirmType.email) {
                            self.confirmInEmailTitleLabel.text = NSLocalizedString("The wallet confirmation email is sent", comment: "")
                            self.confirmInEmailLabel.text = confirmObject!.value
                            if let purse = self.viewModel.purse(forId: self.purseId) {
                            }
                            UIView.transition(from:self.toConfirmContainerView, to:self.confirmInEmailView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                        } else {
                            self.confirmInPhoneNumberTitleLabel.text = NSLocalizedString("Activation code is sent to", comment: "")
                            self.confirmPhoneNumberLabel.text = confirmObject!.value
                            if let purse = self.viewModel.purse(forId: self.purseId) {
                            }
                            UIView.transition(from:self.toConfirmContainerView, to:self.confirmInPhoneNumberView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                        }
                    }
                }
            }
            return
        }
        
        self.viewModel.rotatePurseCard(purseId: self.purseId)
        if (type ?? NewPurseConfirmType.email == NewPurseConfirmType.email) {
            resendInEmailButtonClicked(true)
            UIView.transition(from:self.toConfirmContainerView, to:self.confirmInEmailView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        } else {
            resendInPhoneButtonClicked(true)
            UIView.transition(from:self.toConfirmContainerView,
                              to:self.confirmInPhoneNumberView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    @objc func resendInEmailButtonClicked(_ sender: Any) {
        resendActivityIndicator.isHidden = false
        resendActivityIndicator.startAnimating()
        resendInEmailButton.isHidden = true
        viewModel.resendCode(forPurseId: self.purseId) { [weak self] (errorString, confirmObject) in
            self?.resendActivityIndicator.isHidden = true
            self?.resendActivityIndicator.stopAnimating()
            if let self = self {
                if let errorString = errorString {     //RESEND CODE REQUEST FAILURE
                    self.resendInEmailButton.isHidden = false
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        var toastStyle = ToastStyle()
                        toastStyle.messageAlignment = .center
                        toastStyle.messageFont = .medium15
                        topController.view.makeToast(errorString, duration: 0.6, position: .bottom, style: toastStyle)
                    }
                } else {                                                //RESEND CODE REQUEST SUCCESS
                    if let confirmObject = confirmObject {
                        self.setupUnconfirmedFields(rotated: true, purseNumber: confirmObject.value)
                    }
                    self.tryToFindExistTimerAndApply(existTimer: self.viewModel.createNewTimer(forPurseId: self.purseId))
                }
            }
        }
    }
    
    @objc func resendInPhoneButtonClicked(_ sender: Any) {
        phoneResendAgainActivityIndicator.isHidden = false
        phoneResendAgainActivityIndicator.startAnimating()
        phoneResendAgainButton.isHidden = true
        viewModel.resendCode(forPurseId: self.purseId) { [weak self] (errorString, confirmObject) in
            self?.phoneResendAgainActivityIndicator.isHidden = true
            self?.phoneResendAgainActivityIndicator.stopAnimating()
            if let self = self {
                if let errorString = errorString {     //RESEND CODE REQUEST FAILURE
                    self.phoneResendAgainButton.isHidden = false
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        var toastStyle = ToastStyle()
                        toastStyle.messageAlignment = .center
                        toastStyle.messageFont = .medium15
                        topController.view.makeToast(errorString, duration: 0.6, position: .bottom, style: toastStyle)
                    }
                } else {                                                //RESEND CODE REQUEST SUCCESS
                    if let confirmObject = confirmObject {
                        self.setupUnconfirmedFields(rotated: true, purseNumber: confirmObject.value)
                    }
                    self.tryToFindExistTimerAndApply(existTimer: self.viewModel.createNewTimer(forPurseId: self.purseId))
                }
            }
        }
    }
    
    private func tryToFindExistTimerAndApply(existTimer: Repeater? = nil) {
        let timer = (existTimer == nil) ? viewModel.timer(purseId: self.purseId) : existTimer
        timer?.removeAllObservers()
        timer?.observe({ [weak self] (timer) in
            OperationQueue.main.addOperation { [weak self] in
                self?.timerObserve(timer: timer)
            }
        })
        if (viewModel.confirmType(forPurseId: self.purseId) ?? NewPurseConfirmType.email == NewPurseConfirmType.email) {    //Email
        if (timer?.remainingIterations ?? 0 > 0) {
            self.resendAgainTimerLabel.text = ""
            self.resendInEmailButton.isHidden = true
            self.resendActivityIndicator.isHidden = true
            self.resendAgainTimerLabel.isHidden = false
        } else {
            self.resendAgainTimerLabel.isHidden = true
            self.resendActivityIndicator.isHidden = true
            self.resendInEmailButton.isHidden = false
        }
        } else {                                                                                                            //Phone
            if (timer?.remainingIterations ?? 0 > 0) {
                self.phoneResendAgainTimerLabel.text = ""
                self.phoneResendAgainButton.isHidden = true
                self.phoneResendAgainActivityIndicator.isHidden = true
                self.phoneResendAgainTimerLabel.isHidden = false
            } else {
                self.phoneResendAgainTimerLabel.isHidden = true
                self.phoneResendAgainActivityIndicator.isHidden = true
                self.phoneResendAgainButton.isHidden = false
            }
        }
    }
    
    private func timerObserve(timer: Repeater) {
        if (timer.remainingIterations ?? 0 <= 0) {
            self.phoneResendAgainButton.isHidden = false
            self.phoneResendAgainTimerLabel.isHidden = true
            self.resendInEmailButton.isHidden = false
            self.resendAgainTimerLabel.isHidden = true
            PaymentUtils.shared.saveRotatedPurse(forPurseId: purseId, rotated: false)
//            viewModel.updateRotatedState(forPurseId: purseId, rotated: false)
            return
        }
        let (minutes, seconds) = secondsToMinutesSeconds(seconds: timer.remainingIterations ?? 0)
        self.resendAgainTimerLabel.text = String(format: "%@: %02d:%02d", NSLocalizedString("Send again", comment: ""), minutes, seconds)
        self.phoneResendAgainTimerLabel.text = String(format: "%@: %02d:%02d", NSLocalizedString("Send again", comment: ""), minutes, seconds)
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func confirmCodeTextFieldDidChanged(_ sender: Any) {
        if confirmCodeTextField.text?.count ?? 0 >= 5 {
            ProgressHUD.show()
            confirmCodeTextField.isEnabled = false
            confirmCodeTextField.resignFirstResponder()
            viewModel.sendConfirmCode(purseId: self.purseId, code: confirmCodeTextField.text!, success: { [weak self] in
                OperationQueue.main.addOperation { [weak self] in
                    ProgressHUD.dismiss()
                    if let self = self {
                        self.viewModel.setConfirmPurse(with: self.purseId)
                        UIView.transition(from:self.confirmInPhoneNumberView, to:self.containerView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                    }
                    self?.confirmCodeTextField.isEnabled = true
                    //self?.confirmCodeTextField.becomeFirstResponder()
                }
            }) { [weak self] (errorString) in
                OperationQueue.main.addOperation { [weak self] in
                    ProgressHUD.dismiss()
                    self?.confirmCodeTextField.text = ""
                    self?.confirmCodeTextField.isEnabled = true
                    //self?.confirmCodeTextField.becomeFirstResponder()
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        var toastStyle = ToastStyle()
                        toastStyle.messageAlignment = .center
                        toastStyle.messageFont = .medium15
                        topController.view.makeToast(errorString, duration: 1.0, position: .bottom, style: toastStyle)
                    }
                }
            }
        }
    }
    
}
