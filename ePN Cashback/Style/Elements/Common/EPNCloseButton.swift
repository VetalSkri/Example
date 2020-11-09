//
//  EPNCloseButton.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPNCloseButton: UIButton {

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
        self.backgroundColor = .sydney
        self.setImage(UIImage(named: "closeScan"), for: .normal)
    }

}
