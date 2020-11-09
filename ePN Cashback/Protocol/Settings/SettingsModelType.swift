//
//  SettingsModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol SettingsModelType {
    var settingsTitle: String { get }
    func countOfItems() -> Int
    func itemForRow(row: Int) -> SettingItem
    
    func goOnProfile()
    func goOnBack()
}

extension SettingsModelType {
    
    var settingsTitle: String {
        return NSLocalizedString("Settings_Title", comment: "")
    }
}
