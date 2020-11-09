//
//  EPNLabelButton.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPNLinkLabel: UILabel {
    
    private let DASHEDLINE = "dashedLine"
    
    enum Style: Int {
        case full = 0
        case partly
    }
    
    enum LinkType: Int {
        case common
        case email
    }

    var style: Style = .full {
        didSet { applyStyle() }
    }
    
    var type: LinkType = .common {
        didSet { applyStyle() }
    }
    
    @IBInspectable private var styleType: Int {
        get { return style.rawValue }
        
        set {
            if let newStyle = Style(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    init(style: Style = .full) {
        super.init(frame: CGRect.zero)
        commonInit()
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        applyStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if style == .full {
            self.addSyblayerDashed(name: DASHEDLINE)
        } else {
            self.removeSublayerBy(name: DASHEDLINE)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
    }
    
    private func commonInit() {
        numberOfLines = 0
        backgroundColor = .clear
    }
    
    private func applyStyle() {
        textColor = UIColor.sydney
    }
    
    func changeColorOfLink(for fullText: String) {
        let stringOfButton = NSMutableAttributedString(string: fullText)
        switch style {
        case .full:
            stringOfButton.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.sydney, range: NSRange(location: 0, length: stringOfButton.length))
            stringOfButton.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: stringOfButton.length))
//            let attribs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor : UIColor.minsk]
//            stringOfButton.addAttributes(attribs, range: NSRange(location: 0, length: stringOfButton.length))
            break
        case .partly:
            let firstIndex = fullText.firstIndex(of: "<")!
            let secondIndex = fullText.firstIndex(of: ">")!
            let linkRange = NSRange(location: firstIndex.encodedOffset + 1, length: secondIndex.encodedOffset - (firstIndex.encodedOffset + 1))
            switch self.type {
            case .common:
                stringOfButton.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.london, range: NSRange(location: 0, length: stringOfButton.length))
                stringOfButton.addAttribute(NSAttributedString.Key.font, value: UIFont.medium13, range: NSRange(location: 0, length: stringOfButton.length))
                let attribs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.semibold13, NSAttributedString.Key.foregroundColor : UIColor.sydney]
                stringOfButton.addAttributes(attribs, range: linkRange)
                textAlignment = .center
                break
            case .email:
                stringOfButton.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.minsk, range: NSRange(location: 0, length: stringOfButton.length))
                stringOfButton.addAttribute(NSAttributedString.Key.font, value: UIFont.medium15, range: NSRange(location: 0, length: stringOfButton.length))
                textAlignment = .left
                break
            }
            stringOfButton.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.clear], range: linkRange)
            stringOfButton.replaceCharacters(in: NSRange(location: secondIndex.encodedOffset, length: 1), with: "")
            stringOfButton.replaceCharacters(in: NSRange(location: firstIndex.encodedOffset, length: 1), with: "")
            break
        }
        attributedText = stringOfButton
    }

    
}
