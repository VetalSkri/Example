//
//  EPN_OrderCloseButton.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 15/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPN_OrderCloseButton: UIButton {
    
    private let defaultSize = CGSize(width: 30, height: 30)
    
    init() {
        super.init(frame: CGRect(origin: CGPoint.zero, size: defaultSize))
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.setTitle(nil, for: .normal)
        self.setImage(UIImage(named: "closeOrder"), for: .normal)
    }
    
}
