//
//  PopUpViewController.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 03/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class PopUpViewController: UIViewController {

    @IBOutlet weak var popup: EPNPopUp!
    
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var button: EPNButton!
    
    @IBOutlet weak var viewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAlignCenterYConstraint: NSLayoutConstraint!
    
    var viewModel: PopUpModelType?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    let blueView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupBlurView() {
        blueView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blueView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blueView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .light)
        view.insertSubview(blueView, at: 0)
        blueView.effect = blurEffect
        setupBlurView()
        ProgressHUD.colorSpinner(UIColor.sydney)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        guard let viewModel = viewModel else {
            print("The viewModel is empty")
            return
        }
        setupConstraint(viewModel: viewModel)
        defaultInit(viewModel: viewModel)
        showKeyboard()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popup.firstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func defaultInit(viewModel: PopUpModelType) {
        let type = viewModel.getType()
        popup.type = type
        button.text = viewModel.getButtonTitle()
        popup.setHeadInfoText(title: viewModel.getHeadTitle())
        popup.setTitle(title: viewModel.getTitleText())
        popup.setInfoText(info: viewModel.getInfoText(0))
        popup.setPlaceHolderText(title: viewModel.getPlaceholderText())
        popup.handlerClosePopUp = { [weak self] (popup) in
            self?.dismiss(animated: true)
        }
        
        switch type {
        case .info:
            button.isHidden = true
        case .hint:
            button.isHidden = true
            popup.handlerTransitionButton = {(button) in
                OldAPI.performTransition(type: .searchOrder)
            }
        case .promo:
            button.style = .disabled
            popup.handlerPrintingInPopup = { [unowned self] (string) in
                if string.count > 0 {
                    self.button.style = .primary
                } else {
                    self.button.style = .disabled
                }
            }
            
            button.handler = { [unowned self] (button) in
                ProgressHUD.show()
                button.style = .disabled
                viewModel.sendRequestToCheckPromoCode(promo: self.popup.text ?? "", completion: { [weak self] in
                    OperationQueue.main.addOperation { [weak self] in
                        ProgressHUD.dismiss()
                        self?.button.style = .primary
                        viewModel.setPromocode(promo: self?.popup.text ?? "")
                        NotificationCenter.default.post(name: .savePromocodePopUp, object: self)
                        self?.dismiss(animated: true)
                    }
                }, failureHandle: { [weak self] (failureMessage) in
                    if failureMessage == 400030 || failureMessage == 400031 || failureMessage == 400032 || failureMessage == 400033 {
                        OperationQueue.main.addOperation { [weak self] in
                            ProgressHUD.dismiss()
                            self?.button.style = .primary
                            self?.popup.setErrorStyle(true, info: viewModel.getInfoText(failureMessage), animated: true)
                        }
                    }
                    OperationQueue.main.addOperation { [weak self] in
                        ProgressHUD.dismiss()
                        self?.button.style = .primary
                    }
                })
            }
        default:
            return
        }
        
        popup.handlerClosePopUp = { [weak self] button in
            self?.dismiss(animated: true)
        }
    }
    
    private func setupConstraint(viewModel: PopUpModelType) {
        let type = viewModel.getType()
        switch type {
        case .hint:
            viewAlignCenterYConstraint.isActive = true
            viewTopSpaceConstraint.isActive = false
        default:
            viewAlignCenterYConstraint.isActive = false
            viewTopSpaceConstraint.isActive = true
        }
    }
    
    func performTransitionToWriteCaptcha() {
//        let captchaVC: CaptchaVC = CaptchaVC.controllerFromStoryboard(.captcha)
//        captchaVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        captchaVC.viewModel = viewModel?.sendCaptcha()
//        self.present(captchaVC, animated: true)
    }

}

extension PopUpViewController: UITextViewDelegate {
    
    func showKeyboard() {
        popup.becomeFirstResponder()
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: duration) {
            self.buttonBottomConstraint.constant = finalRect.height
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: duration) {
            self.buttonBottomConstraint.constant = 0
        }
    }
}
extension PopUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        print("replacementString \(string)")
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let result = newString.length <= maxLength
        return result
    }
}
