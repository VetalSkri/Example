//
//  OrderFilterCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 12/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class OrderFilterCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterNameTitle: UILabel!
    
    func setupCell(filterName: String, isSelected: Bool) {
        containerView.cornerRadius = CommonStyle.cornerRadius
        filterNameTitle.text = filterName
        changeSelectionState(isSelected: isSelected)
    }
    
    func changeSelectionState(isSelected: Bool) {
        containerView.borderColor = UIColor.sydney
        containerView.borderWidth = CommonStyle.borderWidth
        filterNameTitle.textColor = isSelected ? UIColor.zurich : UIColor.sydney
        containerView.backgroundColor = isSelected ? UIColor.sydney : UIColor.zurich
    }
    
}
