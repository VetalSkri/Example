//
//  UIButton+Extension.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 15/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIButton {
    
    // MARK: - Public methods
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
}
