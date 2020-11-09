//
//  SettingTableViewCell.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 23/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var roundedContentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedContentView.layer.cornerRadius = CommonStyle.cornerRadius
        roundedContentView.layer.masksToBounds = false
//        roundedContentView.layer.borderColor = UIColor.bg.cgColor
//        roundedContentView.layer.borderWidth = CommonStyle.borderWidth
    }

    func setupCell(settingItem : SettingItem) {
        iconImageView.image = UIImage(named: settingItem.imageName)
        settingNameLabel.text = settingItem.title
        settingNameLabel.textColor = .sydney
        settingNameLabel.font = .semibold17
    }
}
