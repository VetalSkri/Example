//
//  AccountHeaderReusableView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AccountHeaderReusableView: UICollectionViewCell {
    
    @IBOutlet weak var headerViewContainer: UIView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
