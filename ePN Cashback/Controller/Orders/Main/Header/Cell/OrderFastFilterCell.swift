//
//  OrderFastFilterCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 10/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class OrderFastFilterCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var closeOrderImageView: UIImageView!
    @IBOutlet weak var closeOrderImageViewWidthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(with title: String, isSelected: Bool) {
        containerView.cornerRadius = 8
        containerView.backgroundColor = (isSelected) ? .moscow : .zurich
        containerView.borderColor = (isSelected) ? .moscow : .montreal
        containerView.borderWidth = 1
        
        filterTitleLabel.text = title
        filterTitleLabel.font = .semibold13
        filterTitleLabel.textColor = (isSelected) ? .zurich : .sydney
        
        closeOrderImageView.isHidden = !isSelected
        closeOrderImageViewWidthConstraint.constant = (isSelected) ? 16 : 0
    }
    
    func setSelected(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else { return }
            self.containerView.backgroundColor = (isSelected) ? .moscow : .zurich
            self.containerView.borderColor = (isSelected) ? .moscow : .montreal
            self.filterTitleLabel.textColor = (isSelected) ? .zurich : .sydney
            self.closeOrderImageView.isHidden = !isSelected
            self.closeOrderImageViewWidthConstraint.constant = (isSelected) ? 16 : 0
            self.view.layoutIfNeeded()
        })
        
    }
    
}
