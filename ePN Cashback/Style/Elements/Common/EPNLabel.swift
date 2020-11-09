//
//  EPNLabel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPNLabel: UILabel {
    
    
    enum Style: Int {
        case additional = 0
        case head
        case info
        case title
        case link
        case helperText
        case titleHelperText
        case headPopUp
    }

    var style: Style = .additional {
        didSet {
            applyStyle()
        }
    }
    
    @IBInspectable private var styleType: Int {
        get { return style.rawValue  }
        
        set {
            if let newStyle = Style(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    init(style: Style = .additional) {
        super.init(frame: CGRect.zero)
        commonInit()
        self.style = style
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
    }
    
    private func commonInit() {
        textAlignment = .center
        numberOfLines = 0
    }
    
    private func applyStyle() {
        switch style {
        case .additional:
            font = .medium13
            textColor = UIColor.minsk
        case .headPopUp:
            font = .medium15
            textColor = .sydney
        case .head:
            font = .bold17
            textColor = .sydney
        case .info:
            font = .semibold17
            textColor = .sydney
        case .title:
            font = .bold17
            textColor = .sydney
        case .link:
            textColor = .sydney
            backgroundColor = .clear
        case .helperText:
            font = .medium15
            textColor = .sydney
        case .titleHelperText:
            font = .bold17
            textColor = .sydney
            
        }
    }
}
