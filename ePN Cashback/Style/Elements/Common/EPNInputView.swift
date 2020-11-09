//
//  EPNInputView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@objc protocol EPNInputViewDelegate {
    @objc optional func inputView(_ inputView: EPNInputView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

@IBDesignable
final class EPNInputView: UIView {

    enum ContentType: Int {
        case none
        case email
        case password
        case captcha
        case promo
        case link
    }
    
    private let textField = UITextField()
    private let secureButton = UIButton(type: .custom)
    
    var type: ContentType = .none {
        didSet { applyType() }
    }
    
    
    @IBInspectable private var contentType: Int {
        get { return type.rawValue }
        set {
            if let newType = ContentType(rawValue: newValue) {
                type = newType
            }
        }
    }
    var handlerPrinting: ((String?) -> ())?
    
    var delegate: EPNInputViewDelegate?
    
    
    @IBInspectable var placeholder: String? {
        get { return textField.placeholder }
        set {
            textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.minsk, NSAttributedString.Key.font : UIFont.semibold17])
        }
    }
    
    @IBInspectable var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    @IBInspectable var isSecureText: Bool {
        get { return textField.isSecureTextEntry}
        set {
            textField.isSecureTextEntry = newValue
            textField.clearsOnBeginEditing = false
            setActualSecureButtonImage()
        }
    }
    
    @IBInspectable var isSecureButtonVisible: Bool {
        get { return secureButton.isHidden }
        set {
            if newValue {
                setActualSecureButtonImage()
            }
            secureButton.isHidden = !newValue
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundColor = .paris
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = CommonStyle.cornerRadius
        backgroundColor = .paris
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.sydney])
        textField.font = .medium15
        textField.tintColor = .sydney
        
    }
    
    private func applyType() {
        switch type {
        case .none:
            textField.keyboardType = .default
            if #available(iOS 11, *) {
                textField.textContentType = nil
            }
        case .link:
            addSubview(textField)
            textField.keyboardType = .default
            textField.delegate = self
            textField.borderStyle = .none
            textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.sydney])
            textField.font = .semibold17
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
            textField.autocorrectionType = .no
        case .email:
            textField.keyboardType = .emailAddress
            if #available(iOS 11, *) {
                textField.textContentType = .username
            }

            // TextField
            addSubview(textField)
            textField.delegate = self
            textField.borderStyle = .none
            textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.sydney])
            textField.font = .semibold17
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
            textField.autocorrectionType = .no
            
            
        case .password:
            textField.keyboardType = .default
            if #available(iOS 11, *) {
                textField.textContentType = .password
            }
            addSubview(secureButton)
            secureButton.addTarget(self, action: #selector(didTapSecureButton), for: .touchUpInside)
            
            secureButton.translatesAutoresizingMaskIntoConstraints = false
            secureButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            secureButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            secureButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            secureButton.widthAnchor.constraint(equalTo: secureButton.heightAnchor).isActive = true
            
            // TextField
            addSubview(textField)
            textField.delegate = self
            textField.borderStyle = .none
            textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.sydney])
            textField.font = .semibold17
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: secureButton.leadingAnchor).isActive = true
            textField.autocorrectionType = .no
            
           
            
        
        case .captcha:
            
            addSubview(textField)
            textField.delegate = self
            textField.borderStyle = .none
            textField.keyboardType = .default
            textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.moscow])
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            textField.autocorrectionType = .no
        case .promo:
            
            addSubview(textField)
            textField.delegate = self
            textField.borderStyle = .none
            textField.keyboardType = .default
            textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.moscow])
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
            textField.autocorrectionType = .no
        }
    }
    
    private func setActualSecureButtonImage() {
        let image = isSecureText ?
            UIImage(named: "HidePassword", in: Bundle(for: classForCoder), compatibleWith: nil)
            : UIImage(named: "ShowPassword", in: Bundle(for: classForCoder), compatibleWith: nil)
        
        secureButton.setImage(image, for: .normal)
    }
    
    @objc private func didTapSecureButton() {
        isSecureText = !isSecureText
        setActualSecureButtonImage()
    }
    
    func firstResponder() {
        self.textField.becomeFirstResponder()
    }
}

extension EPNInputView {
    
    func setErrorStyle(_ isEnabled: Bool, animated: Bool) {
        layer.backgroundColor = isEnabled ? UIColor.prague.cgColor : UIColor.paris.cgColor
        
        if isEnabled == true, animated == true {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 8, y: center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 8, y: center.y))
            
            layer.add(animation, forKey: "position")
        }
    }
    
    
}


extension EPNInputView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch type {
        case .none:
            return true
        case .link:
            return true
        case .email:
            let isShouldChange = self.delegate?.inputView?(self, shouldChangeCharactersIn: range, replacementString: string)
            let maxLength = 256
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            let result = newString.length <= maxLength
            
            return (result && (isShouldChange ?? true))

        case .password:
            let isShouldChange = self.delegate?.inputView?(self, shouldChangeCharactersIn: range, replacementString: string)
//            let maxLength = 2
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            let result = newString.length <= maxLength
//            return (result || isShouldChange ?? true)
            
            return isShouldChange ?? true
        case .captcha:
            let isShouldChange = self.delegate?.inputView?(self, shouldChangeCharactersIn: range, replacementString: string)
            
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            let result = newString.length <= maxLength
            
            return (result && (isShouldChange ?? true))
        case .promo:
            let isShouldChange = self.delegate?.inputView?(self, shouldChangeCharactersIn: range, replacementString: string)
            return isShouldChange ?? true
        }
        
    }
    
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.handlerPrinting?(textField.text)
        
    }
    
}






// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
