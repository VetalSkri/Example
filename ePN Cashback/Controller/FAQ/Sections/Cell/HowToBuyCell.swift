//
//  HowToBuyCell.swift
//  CashBackEPN
//
//  Created by Александр on 07/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class HowToBuyCell: UICollectionViewCell {
    
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public func setupCell(withFragment: FaqCollectionViewFragment){
        self.illustrationImageView.image = UIImage(named: withFragment.illustrationName)
        
        self.titleLabel.text = withFragment.title
        self.titleLabel.font = .bold17
        self.titleLabel.textColor = .sydney
        
        self.descriptionLabel.text = withFragment.description
        self.descriptionLabel.font = .medium15
        self.descriptionLabel.textColor = .sydney
    }
    
}
