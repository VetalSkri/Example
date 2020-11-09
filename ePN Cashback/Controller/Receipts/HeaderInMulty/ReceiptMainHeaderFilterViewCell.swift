//
//  ReceiptMainHeaderFilterViewCell.swift
//  Backit
//
//  Created by Ivan Nikitin on 07/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class ReceiptMainHeaderFilterViewCell: UICollectionViewCell {

    @IBOutlet weak var filterCategoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet{
            changeLayoutStatus(isSelected: isSelected)
        }
    }
    
    func setupView(filterTitle: String, isSelected: Bool = false) {
        self.filterCategoryNameLabel.text = filterTitle
        layer.cornerRadius = CommonStyle.modalCornerRadius
        layer.masksToBounds = true
        backgroundColor = .zurich
        filterCategoryNameLabel.font = .semibold13
        filterCategoryNameLabel.textColor = UIColor.sydney
        changeLayoutStatus(isSelected: isSelected)
        layoutIfNeeded()
        
    }
    
    func changeLayoutStatus(isSelected: Bool) {
        backgroundColor = UIColor.zurich
        if isSelected {
            backgroundColor = .montreal
        } else {
            backgroundColor = .zurich
        }
    }
}
