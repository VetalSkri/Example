//
//  StockFilterCollectionViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class StockFilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCellWithFilterName(name: String, selected: Bool) {
        layer.cornerRadius = CommonStyle.cornerRadius
        layer.masksToBounds = true
        self.filterNameLabel.text = name
        self.changeLayoutStatus(isSelected: selected)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func changeLayoutStatus(isSelected: Bool) {
        layer.borderColor = UIColor.sydney.cgColor
        layer.borderWidth = CommonStyle.borderWidth
        if isSelected {
            filterNameLabel.textColor = .zurich
            backgroundColor = UIColor.sydney
            
        } else {
            filterNameLabel.textColor = UIColor.sydney
            backgroundColor = UIColor.zurich
        }
    }
    
}
