//
//  EPNCustomInputView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 18/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

@objc protocol EPNCustomInputViewDelegate {
    @objc optional func inputView(_ inputView: EPNCustomInputView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func textEditing()
}

@IBDesignable
class EPNCustomInputView: UIView {

    private let textField = UITextField()
    private let hintLabel = UILabel()
    private let textFieldView = UIView()
    fileprivate let datePicker = UIDatePicker()
    
    var delegate: EPNCustomInputViewDelegate?
    fileprivate var bottomConstraintField: NSLayoutConstraint!
    fileprivate var bottomConstraintHint: NSLayoutConstraint!
    private(set) var isError = false
    enum ContentType: Int {
        case none = 0
        case cost
        case numbers
        case datepicker
    }
    
    var type: ContentType = .none {
        didSet { applyType() }
    }
    
    var tagToTextField: Int? {
        didSet {
            textField.tag = tag
        }
    }
    
    
    var hintWillAppear: (() -> ())?
    var hintWillDisappear: (() -> ())?
    
    
    fileprivate var dateFormat: String {
        get {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
            return dateFormatter.string(from: datePicker.date)
        }
    }
    
    @IBInspectable private var contentType: Int {
        get { return type.rawValue }
        set {
            if let newType = ContentType(rawValue: newValue) {
                type = newType
            }
        }
    }
    
    
    @IBInspectable var placeholder: String? {
        get { return textField.placeholder }
        set { textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.minsk, NSAttributedString.Key.font : UIFont.medium15]) }
    }
    
    @IBInspectable var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    @IBInspectable var hintText: String? {
        didSet {
            hintLabel.text = hintText
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
        textField.font = .semibold17
        textField.textColor = .sydney
        textField.tintColor = .sydney
        backgroundColor = .clear
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = CommonStyle.cornerRadius
        textFieldView.backgroundColor = .paris
        
        addSubview(textFieldView)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        textFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        bottomConstraintField = textFieldView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomConstraintField.isActive = true
        
        textFieldView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        // TextField
        textFieldView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 0).isActive = true
        textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -10).isActive = true
        textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 0).isActive = true
        
        textField.delegate = self
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        
        addSubview(hintLabel)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 5).isActive = true
        hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        hintLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        hintLabel.isHidden = true
        bottomConstraintHint = hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottomConstraintHint.isActive = false
        
        hintLabel.font = .medium15
        hintLabel.textColor = .minsk
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    func firstResponder() {
        self.textField.becomeFirstResponder()
    }
    
    func resignResponder() {
        self.textField.resignFirstResponder()
    }
    
    
    private func applyType() {
        switch type {
        case .none:
            textField.keyboardType = .numbersAndPunctuation
            if #available(iOS 11, *) {
                textField.textContentType = nil
            }
        case .cost:
            textField.keyboardType = .decimalPad
            if #available(iOS 11, *) {
                textField.textContentType = nil
            }
        case .numbers:
            textField.keyboardType = .numberPad
            if #available(iOS 11, *) {
                textField.textContentType = nil
            }
        case .datepicker:
            datePicker.datePickerMode = .dateAndTime
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
//            let toolbar = UIToolbar()
//            toolbar.sizeToFit()
//            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
//            let doneButton = UIBarButtonItem(title: NSLocalizedString("Choose", comment: ""), style: .done, target: self, action: #selector(doneDateTime))
            
//            toolbar.setItems([flexibleSpace,doneButton], animated: true)
            
//            textField.inputAccessoryView = toolbar
            textField.inputView = datePicker
            //textField.text = dateFormat
        }
    }
    
    func checkTextField() {
        if let text = textField.text , text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            hintLabel.textColor = .prague
            hintLabel.text = NSLocalizedString("The field shoudn't be empty", comment: "")
            bottomConstraintHint.isActive = true
            bottomConstraintField.isActive = false
            hintLabel.isHidden = false
        } else {
            bottomConstraintHint.isActive = false
            bottomConstraintField.isActive = true
            hintLabel.isHidden = true
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        textField.text = dateFormat
        delegate?.textEditing?()
    }
    
    @objc func doneDateTime() {
        if (textField.text ?? "") == "" {
            textField.text = dateFormat
        }
        self.endEditing(true)
    }
    
}

extension EPNCustomInputView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
//        layoutIfNeeded()
        
        if let text = textField.text , text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
            hintLabel.textColor = .prague
            hintLabel.text = NSLocalizedString("The field shoudn't be empty", comment: "")
        } else {
            bottomConstraintHint.isActive = false
            bottomConstraintField.isActive = true
            hintLabel.isHidden = true
            hintWillDisappear?()
        }
        delegate?.textEditing?()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
//        layoutIfNeeded()
        bottomConstraintHint.isActive = true
        bottomConstraintField.isActive = false
        hintLabel.textColor = .minsk
        hintLabel.isHidden = false
        hintLabel.text = hintText
        hintWillAppear?()
        delegate?.textEditing?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.keyboardType.rawValue {
        case 8:
            let allowedCharacters = CharacterSet.decimalDigits
            let allowedCharactersPunctuation = CharacterSet.punctuationCharacters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) || allowedCharactersPunctuation.isSuperset(of: characterSet)
        case 4:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        case 2:
            return false
        default:
            return true
        }
        delegate?.textEditing?()
    }
    
}
