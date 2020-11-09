//
//  ShopDetailConditionTableViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 24/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ShopDetailConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionTitle: UILabel!
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(faqCondition: ShopDetailConditionFaqItem) {
        conditionTitle.font = .bold17
        conditionTitle.textColor = .sydney
        conditionDescriptionLabel.font = .medium15
        conditionDescriptionLabel.textColor = .sydney
        conditionImageView.image = UIImage(named: faqCondition.imageName)
        conditionTitle.text = faqCondition.title
        conditionDescriptionLabel.text = faqCondition.description
    }

}
