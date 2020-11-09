//
//  AccountMenuViewCell.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 22/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AccountMenuViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleMenu: UILabel!
    @IBOutlet weak var logoMenu: UIImageView!
    
    var viewModel: AccountMenuViewCellViewModel? {
        willSet(viewModel) {
            backgroundColor = .zurich
            layer.masksToBounds = true
            layer.cornerRadius = CommonStyle.cornerRadius
//            layer.borderWidth = CommonStyle.borderWidth
//            layer.borderColor = UIColor.bg.cgColor
            guard let viewModel = viewModel else { return }
            let (title, image) = viewModel.data()
            titleMenu.text = title
            titleMenu.textColor = .sydney
            titleMenu.font = .semibold17
            titleMenu.numberOfLines = 0
            logoMenu.image = image
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttributes.bounds.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        return layoutAttributes
    }
}
