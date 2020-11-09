//
//  EnterCodeView.swift
//  Backit
//
//  Created by Elina Batyrova on 27.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

protocol EnterCodeViewDelegate: AnyObject {
    
    // MARK: - Instance Methods
    
    func didFinishEntering(code: String)
}

class EnterCodeView: UIView {
    
    // MARK: - Instance Properties
    
    weak var delegate: EnterCodeViewDelegate?
    
    // MARK: -
    
    private var numberOfDigits = 5
    
    private var stackView = UIStackView()
    
    var isLock: Bool = false
    
    // MARK: - Instance Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startToFill() {
        let firstTextFieldTag = 1
        
        let textField = stackView.arrangedSubviews[0]
        
        if textField.tag == firstTextFieldTag {
            textField.becomeFirstResponder()
        }
    }
    
    func setErrorState() {
        for view in stackView.arrangedSubviews {
            view.layer.borderColor = UIColor.prague.cgColor
        }
    }
    
    func setDefaultState() {
        for view in stackView.arrangedSubviews {
            view.layer.borderColor = UIColor.montreal.cgColor
        }
    }
    
    func getCode() -> String {
        var code = ""
        
        for tag in 1...numberOfDigits {
            guard let textField = viewWithTag(tag) as? UITextField else {
                continue
            }
            
            code += textField.text!
        }
        
        return code
    }
    
    // MARK: -
    
    private func setupTextFields() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints({ maker in
            maker.width.height.centerX.centerY.equalToSuperview()
        })
        
        for tag in 1...numberOfDigits {
            let textField = EnterCodeTextField()
            
            textField.tag = tag
            
            setup(textField)
            
            stackView.addArrangedSubview(textField)
        }
    }
    
    private func setup(_ textField: UITextField) {
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.layer.cornerRadius = 1
        textField.layer.borderColor = UIColor.montreal.cgColor
        textField.tintColor = .sydney
        textField.layer.borderWidth = 1
        textField.textColor = .sydney
        textField.font = .medium34
    }
}

// MARK: - UITextFieldDelegate

extension EnterCodeView: UITextFieldDelegate {
    
    // MARK: - Instance Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isLock {}
        else {
            var nextTag = -1
            
            if string.checkBackspace() {
                textField.deleteBackward()
                
                return false
            } else if string.count == 1 {
                textField.text = string
                nextTag = textField.tag + 1
            } else if string.count == numberOfDigits {
                var pastedCode = string
                
                for tag in 1...numberOfDigits {
                    guard let textField = viewWithTag(tag) as? UITextField else {
                        continue
                    }
                    
                    textField.text = String(pastedCode.removeFirst())
                }
                
                delegate?.didFinishEntering(code: self.getCode())
            }
            
            if let nextTextField = viewWithTag(nextTag) as? EnterCodeTextField {
                nextTextField.becomeFirstResponder()
            } else {
                if nextTag == numberOfDigits + 1 {
                    delegate?.didFinishEntering(code: self.getCode())
                }
            }
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setDefaultState()
        
        textField.layer.borderColor = UIColor.sydney.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setDefaultState()
        
        textField.layer.borderColor = UIColor.montreal.cgColor
    }
}
