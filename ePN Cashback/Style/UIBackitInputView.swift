//
//  UIBackitInputView.swift
//  Backit
//
//  Created by Ivan Nikitin on 05/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class UIBackitInputView: UIView {
    
    enum InputViewStatusType: Int {
        case error = -1
        case none = 0
        case active = 1
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
//        = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "")
//        return imageView
//    }()
    
    @IBOutlet weak var errorMessageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var defaultBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageRightConstraint: NSLayoutConstraint!
    var type: InputViewStatusType = .none {
        didSet { applyType() }
    }
    
    
    @IBInspectable private var contentType: Int {
        get { return type.rawValue }
        set {
            if let newType = InputViewStatusType(rawValue: newValue) {
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
    
    @IBInspectable var isErrorImageVisible: Bool {
        get { return errorImage.isHidden }
        set { errorImage.isHidden = !newValue }
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
        textField.delegate = self
        textField.keyboardType = .default
        textField.textContentType = nil
        errorMessageBottomConstraint.constant = 1
        defaultBottomConstraint.constant = 12
        applyType()
    }
    
    private func applyType() {
        switch type {
        case .none:
            defaultBottomConstraint.constant = 12
            defaultBottomConstraint.isActive = true
            errorMessageBottomConstraint.isActive = false
            imageRightConstraint.constant = -40
            isErrorImageVisible = false
            bottomLine.backgroundColor = .montreal
        case .error:
            defaultBottomConstraint.isActive = false
            errorMessageBottomConstraint.isActive = true
            imageRightConstraint.constant = 16
            isErrorImageVisible = true
            bottomLine.backgroundColor = .prague
        case .active:
            defaultBottomConstraint.isActive = true
            errorMessageBottomConstraint.isActive = false
            imageRightConstraint.constant = -40
            isErrorImageVisible = false
            bottomLine.backgroundColor = .vilnius
        }
        self.layoutIfNeeded()
    }
    
    func firstResponder() {
        self.textField.becomeFirstResponder()
    }
}

extension UIBackitInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        type = .active
        applyType()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        if let text = textField.text, !text.isEmpty {
            type = .none
        } else {
            type = .error
        }
        applyType()
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
