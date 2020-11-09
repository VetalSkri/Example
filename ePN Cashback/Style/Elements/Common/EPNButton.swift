//
//  EPNButton.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit
import TransitionButton

@IBDesignable
final class EPNButton: UIView {

    private let button = TransitionButton(type: .custom)
    
    var getTransionButton: TransitionButton {
        return self.button
    }
    
    enum Style: Int {
        case primary
        case secondary
        case disabled
        case outline
        case overlayOutline
    }
    
    enum ButtonSize {
        case small
        case medium
        case large1
        case large2
    }
    
    var style: Style = .primary {
        didSet { applyStyle() }
    }
    
    var buttonSize: ButtonSize
    
    var handler: ((EPNButton) -> ())?
    
    @IBInspectable private var styleType: Int {
        get { return style.rawValue }
        
        set {
            if let newStyle = Style(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    @IBInspectable var text: String? {
        get { return button.title(for: .normal)  }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    
    @available(*, unavailable, message: "Use init(frame: CGRect, style: Styles) instead")
    init() {
        fatalError("Use another init")
    }
    
    override init(frame: CGRect) {
        self.buttonSize = .medium
        super.init(frame: frame)
        commonInit()
        setupConstraints()
        applyStyle()
    }
    
    init(frame: CGRect = CGRect.zero, style: Style, size: ButtonSize) {
        self.buttonSize = size
        super.init(frame: frame)
        commonInit()
        setupConstraints()
        self.style = style
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonSize = .medium
        super.init(coder: aDecoder)
        commonInit()
        setupConstraints()
        applyStyle()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        //Button
        addSubview(button)
        
        button.addTarget(self, action: #selector(didtapButton), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        button.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
        }
        
        button.titleLabel?.snp.makeConstraints({ (make) in
            switch buttonSize {
            case .small:
                make.top.equalToSuperview().inset(9)
                make.right.equalToSuperview().inset(16)
                make.left.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(9)
            case .medium:
                make.top.equalToSuperview().inset(11)
                make.right.equalToSuperview().inset(20)
                make.left.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(11)
            case .large1:
                make.top.equalToSuperview().inset(12)
                make.right.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().inset(12)
            case .large2:
                make.top.equalToSuperview().inset(13)
                make.right.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().inset(13)
            }
        })
    }
    
    private func applyStyle() {
        button.titleLabel?.textAlignment = .center
        
        switch buttonSize {
        case .small, .medium:
            button.titleLabel?.font = .semibold13
        case .large1, .large2:
            button.titleLabel?.font = .semibold15
        }
        switch style {
        case .primary:
            button.backgroundColor = .sydney
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 0
            button.setTitleColor(.zurich, for: .normal)
            button.isEnabled = true
        case .secondary:
            button.backgroundColor = .paris
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 0
            button.setTitleColor(.sydney, for: .normal)
            button.isEnabled = true
        case .disabled:
            button.backgroundColor = .paris
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 0
            button.setTitleColor(.minsk, for: .normal)
            button.isEnabled = false
        case .outline:
            button.backgroundColor = .zurich
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 0
            button.setTitleColor(.sydney, for: .normal)
            button.isEnabled = true
        case .overlayOutline:
            button.backgroundColor = .moscow
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 1

            button.layer.borderColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1).cgColor
            button.setTitleColor(.zurich, for: .normal)
            button.isEnabled = true
        }
    }
    
    var isEnable: Bool = true {
        willSet(isEnable) {
            button.isEnabled = isEnable
        }
    }
    
    func changeTitleEdgeInsets(padding: UIEdgeInsets = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)) {
        button.contentEdgeInsets = padding
        button.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
}

extension EPNButton {
    
    @objc private func didtapButton() {
        self.alpha = 0.9
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 1.0
        }) { [weak self] (_) in
            if self != nil {
                self!.handler?(self!)
            }
        }
    }
}
