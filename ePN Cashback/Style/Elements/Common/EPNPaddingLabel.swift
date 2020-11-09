//
//  EPNPaddingLabel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 19/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//
import UIKit

@IBDesignable
class EPNPaddingLabel: UILabel {
    
    var padding : UIEdgeInsets!
    
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }
    
    init() {
        padding = UIEdgeInsets.zero
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero
        super.init(coder: aDecoder)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}

