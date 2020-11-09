//
//  SettingsTableViewCell.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate: class {
    func switched(cellType:SettingItemType, toState: Bool)
}

class SettingsTableViewCell: UITableViewCell {

    weak var delegate: SettingsTableViewCellDelegate?
    private var type : SettingItemType!
    
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingDescriptionLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(title: String, description: String, checked: Bool, type: SettingItemType, isEmailConfirmed: Bool){
        settingTitleLabel.text = title
        settingTitleLabel.textColor = .sydney
        settingTitleLabel.font = .semibold17
        settingDescriptionLabel.text = description
        settingDescriptionLabel.textColor = .minsk
        settingDescriptionLabel.font = .medium15
        switcher.onTintColor = .sydney
        switcher.isEnabled = isEmailConfirmed
        switcher.isOn = isEmailConfirmed ? checked : false
        self.type = type
        layoutIfNeeded()
    }
    
    func setSwitcher(isOn : Bool){
        switcher.setOn(isOn, animated: true)
    }
    
    @IBAction func switcherChanged(_ sender: Any) {
        delegate?.switched(cellType: type, toState: switcher.isOn)
    }
    

}
