//
//  CaptchaVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 05/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import TransitionButton
import KeyboardAvoidingView

class CaptchaVC: UIViewController {

    var captcha: ErrorCaptcha?
    var enterHandler: ((String)->())?
    var cancel: (()->())?
    
    //MainContainer
    @IBOutlet weak var mainContainerView: UIView!
    
    //Title & subtitle
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var subtitleTopConstraint: NSLayoutConstraint!
    
    
    //Captcha image
    @IBOutlet weak var captchaImageView: UIImageView!
    
    //Refresh button
    @IBOutlet weak var refreshButton: UIButton!
    
    //Text Input
    @IBOutlet weak var captchaTextInputContainerView: UIView!
    @IBOutlet weak var captchaTextField: UITextField!
    @IBOutlet weak var captchaPlaceholderLabel: UILabel!
    
    //Separator line views
    @IBOutlet weak var horizontalSeparatorView: UIView!
    @IBOutlet weak var verticalSeparatorView: UIView!
    
    //Buttons
    @IBOutlet weak var sendButton: TransitionButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
    }
    
    private func setupView() {
        guard let captcha = captcha else {
            return
        }
        captchaImageView.image = tranformImageFromBase64(stringImage: captcha.captcha.image)
        
        mainContainerView.backgroundColor = .paris
        mainContainerView.cornerRadius = 14
        
        mainTitleLabel.text = NSLocalizedString("Number of appeals is exceeded", comment: "")
        mainTitleLabel.font = .bold17
        mainTitleLabel.textColor = .sydney
        
        if UIScreen.main.nativeBounds.height < 1200 { //small screen of iPhone 4, 4s, 5, 5s, se
            subtitleLabel.text = ""
            subtitleTopConstraint.constant = 0
        } else {
            subtitleLabel.text = NSLocalizedString("Enter the code from the image and confirm that you are not a robot", comment: "")
            subtitleLabel.font = .medium15
            subtitleLabel.textColor = .moscow
            subtitleTopConstraint.constant = 17
        }
        
        captchaTextInputContainerView.backgroundColor = .paris
        captchaTextInputContainerView.cornerRadius = 5
        
        captchaTextField.text = ""
        captchaTextField.font = .medium15
        captchaTextField.textColor = .moscow
        
        captchaPlaceholderLabel.text = NSLocalizedString("Code from the picture", comment: "")
        captchaPlaceholderLabel.font = .medium15
        captchaPlaceholderLabel.textColor = .minsk
        
        closeButton.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        closeButton.setTitleColor(.moscow, for: .normal)
        closeButton.backgroundColor = .clear
        
        sendButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        sendButton.backgroundColor = .clear
        
        
        horizontalSeparatorView.backgroundColor = .minsk
        verticalSeparatorView.backgroundColor = .minsk
        
        setSendButtonEnabled(isEnable: false)
        captchaTextField.becomeFirstResponder()
    }
    
    private func setSendButtonEnabled(isEnable: Bool) {
        sendButton.isEnabled = isEnable
        sendButton.alpha = (isEnable) ? 1 : 0.5
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            if let self = self {
                let captchaText = self.captchaTextField.text ?? ""
                self.enterHandler?(captchaText)
            }
        }
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.enterHandler?("")
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.cancel?()
        }
    }
    
    @IBAction func captchaTextFieldEditing(_ sender: Any) {
        self.captchaPlaceholderLabel.isHidden = (captchaTextField.text?.count ?? 0) > 0
        setSendButtonEnabled(isEnable: (captchaTextField.text?.count ?? 0) > 0)
    }
    
    func tranformImageFromBase64(stringImage: String) -> UIImage? {
        var imageBase64 = stringImage
        let firstIndex = imageBase64.firstIndex(of: ",")!
        imageBase64.replaceSubrange(imageBase64.startIndex...firstIndex, with: "")
        let strBase64 = imageBase64
        let dataDecoded : Data = Data(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedImage = UIImage(data: dataDecoded)
        return decodedImage
    }
    
}
