//
//  PurseTypeCollectionViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class PurseTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var purseNameLabel: UILabel!
    @IBOutlet weak var purseLogoImageView: UIImageView!
    
    //Charity fields
    @IBOutlet weak var charityTitle: UILabel!
    @IBOutlet weak var charitySubtitle: UILabel!
    
    
    func setupCell(purseType: PaymentInfoData) {
        
        containerView.cornerRadius = CommonStyle.cornerRadius
        containerView.borderWidth = (purseType.purseType != PurseType.khabensky) ? CommonStyle.borderWidth : 0
        containerView.borderColor = .montreal
        containerView.backgroundColor = (purseType.purseType != PurseType.khabensky) ? UIColor.zurich : UIColor.toronto
        purseNameLabel.font = .medium13
        purseNameLabel.textColor = .sydney
        
        
        charityTitle.font = .medium13
        charityTitle.textColor = .zurich
        charityTitle.adjustsFontSizeToFitWidth = true
        charityTitle.minimumScaleFactor = 0.2
        charitySubtitle.font = .semibold15
        charitySubtitle.textColor = .zurich
        charitySubtitle.adjustsFontSizeToFitWidth = true
        charitySubtitle.minimumScaleFactor = 0.2
        
        if(purseType.purseType == PurseType.khabensky) {
            charityTitle.isHidden = false
            charitySubtitle.isHidden = false
            purseNameLabel.isHidden = true
            purseLogoImageView.isHidden = true
            
            charityTitle.text = NSLocalizedString("CharityTitle", comment: "")
            charitySubtitle.text = NSLocalizedString("CharitySubitle", comment: "")
        } else {
            charityTitle.isHidden = true
            charitySubtitle.isHidden = true
            purseNameLabel.isHidden = false
            purseLogoImageView.isHidden = false
            
            purseNameLabel.text = purseType.attributes.name
            purseLogoImageView.image = UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseLogo(forType: purseType.purseType!))
        }
    }
    
}
