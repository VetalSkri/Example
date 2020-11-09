//
//  CategoryMenuViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 18/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class CategoryMenuViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(category: (Categories, String)) {
        backgroundColor = .zurich
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = CommonStyle.cornerRadius
        containerView.layer.borderWidth = CommonStyle.borderWidth
        containerView.layer.borderColor = UIColor.montreal.cgColor
        
        categoryNameLabel.text = category.0.name
        categoryNameLabel.numberOfLines = 0
        categoryNameLabel.textColor = .sydney
        categoryNameLabel.font = .semibold17
        
        categoryImageView.image = UIImage(named: category.1) ?? UIImage() 
    }
}
