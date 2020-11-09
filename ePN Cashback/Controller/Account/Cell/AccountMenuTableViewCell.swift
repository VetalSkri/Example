//
//  AccountMenuTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 04/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AccountMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuSubtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .zurich
        menuTitleLabel.textColor = .sydney
        menuTitleLabel.font = .medium15
        menuTitleLabel.numberOfLines = 0
        
        menuSubtitleLabel.font = .semibold15
        menuSubtitleLabel.textColor = .sydney
    }
    
    func setupCell(menuItem: AccountMenuItem) {
        logoImageView.image = UIImage(named: menuItem.logoName)
        menuTitleLabel.text = menuItem.title
        menuSubtitleLabel.text = menuItem.subtitle
    }
    
}
