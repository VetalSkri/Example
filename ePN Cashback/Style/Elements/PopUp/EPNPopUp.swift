//
//  EPNPopUp.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 31/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPNPopUp: UIView {

    private let button = EPNButton(style: .primary, size: .large1)
    private let closeButton = EPNCloseButton()
    private let container = UIView()
    private let textField = EPNInputView()
    private let titleLabel = EPNLabel(style: .headPopUp)
    private let infoLabel = EPNLabel(style: .additional)
    private let imageInfo = UIImageView()
    private let headInfo = EPNLabel(style: .info)
    
    enum ContentType: Int {
        case none = 0
        case info
        case promo
        case hint
    }
    
    var type: ContentType = .none {
        didSet { applyStyle() }
    }
    
    @IBInspectable private var contentType: Int {
        get { return type.rawValue }
        set {
            if let newType = ContentType(rawValue: newValue) {
                type = newType
            }
        }
    }
    
    var handlerClosePopUp: ((EPNCloseButton) -> ())?
    var handlerPrintingInPopup: ((String) -> ())?
    var handlerTransitionButton: ((EPNButton) -> ())?
    
    @IBInspectable var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    init(frame: CGRect = CGRect.zero, type: ContentType) {
        super.init(frame: frame)
        commonInit()
        self.type = type
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyStyle()
    }
    
    
    func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = CommonStyle.cornerRadius
        backgroundColor = .zurich
        
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(didClosePopUp), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true

        
        
        
    }
    
    func applyStyle() {
        updateConstraintsIfNeeded()
        switch self.type {
        case .none:
            setNeedsLayout()
        case .info:
            addSubview(imageInfo)
            imageInfo.translatesAutoresizingMaskIntoConstraints = false
            imageInfo.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 5).isActive = true
            imageInfo.heightAnchor.constraint(equalToConstant: 60).isActive = true
            imageInfo.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            imageInfo.widthAnchor.constraint(equalTo: imageInfo.heightAnchor).isActive = true
            imageInfo.contentMode = .scaleAspectFit
            imageInfo.image = UIImage(named: "zeroInterface")
            
            addSubview(headInfo)
            headInfo.translatesAutoresizingMaskIntoConstraints = false
            
            headInfo.topAnchor.constraint(equalTo: imageInfo.bottomAnchor, constant: 15).isActive = true
            headInfo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
            headInfo.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            headInfo.text = NSLocalizedString("Where can I get a promo code?", comment: "")
            headInfo.textAlignment = .center
            headInfo.numberOfLines = 0
            
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: headInfo.bottomAnchor, constant: 15).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
            titleLabel.text = NSLocalizedString("Promo code can be obtained from our partners or in social media: Vkontakte, Facebook, Instagram.", comment: "")
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            setNeedsLayout()
            
        case .promo:

            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 15).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            titleLabel.text = NSLocalizedString("Enter a promo code", comment: "")
            titleLabel.textAlignment = .center

            addSubview(textField)
            textField.backgroundColor = .paris
            textField.type = .promo
            textField.handlerPrinting = { [unowned self] (string) in
                self.handlerPrintingInPopup?(string ?? "")
            }
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            
            addSubview(infoLabel)
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            infoLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15).isActive = true
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
            infoLabel.isHidden = true
            infoLabel.textAlignment = .center
            infoLabel.numberOfLines = 2
            infoLabel.textColor = .prague
            setInfoText(info: "Incorrect promo code")
            setNeedsLayout()
        case .hint:
            
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            titleLabel.text = NSLocalizedString("If you did not find the order in the list, use the order search form in the mobile version of epn.bz", comment: "")
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font = .medium15
            titleLabel.textColor = .sydney
            
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.handler = { [unowned self] (epnButton) in
                self.handlerTransitionButton?(epnButton)
            }
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 45).isActive = true
            button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
            button.text = NSLocalizedString("To mobile version", comment: "")
//            button.fontSize = 16
            setNeedsLayout()
        }
    }
    
    
}



extension EPNPopUp {

    func firstResponder() {
        self.textField.firstResponder()
    }
    
    func setErrorStyle(_ isEnabled: Bool, info text: String, animated: Bool) {
        textField.backgroundColor = isEnabled ? .prague : .paris
        infoLabel.isHidden = false
        infoLabel.text = text
    }
    
    func setPlaceHolderText(title text: String) {
        textField.placeholder = text
    }
    
    func removeContentFromField() {
        textField.text = ""
    }

    func setTitle(title text: String) {
        titleLabel.text = text
    }
    
    func setHeadInfoText(title text: String) {
        headInfo.text = text
    }

    func setInfoText(info text: String) {
        infoLabel.text = text
    }
    
    func getButtonInsidePopUp() -> EPNButton {
        return button
    }
    
}

extension EPNPopUp {

    @objc private func didClosePopUp() {
        self.closeButton.alpha = 0.5
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.closeButton.alpha = 1.0
        }) { [weak self] (_) in
            if self != nil {
                self!.handlerClosePopUp?(self!.closeButton)
            }
        }
    }
    
    
}
