//
//  SettingsViewModel.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class SettingsViewModel: SettingsModelType {

    private let router: UnownedRouter<SettingsRoute>
    
    init(router: UnownedRouter<SettingsRoute>) {
        self.router = router
    }
    
    private let items = [
        SettingItem(title: NSLocalizedString("Settings_EditProfile", comment: ""), imageName: "icEditProfile"),
        SettingItem(title: NSLocalizedString("Settings_AppSettings", comment: ""), imageName: "icAppSettings"),
        SettingItem(title: NSLocalizedString("Settings_About", comment: ""), imageName: "icAboutApp")
    ]

    func countOfItems() -> Int {
        return items.count
    }
    
    func itemForRow(row: Int) -> SettingItem{
        return items[row]
    }
    
    func goOnProfile() {
        router.trigger(.profile)
    }
    
    func goOnBack() {
        router.trigger(.back)
    }

}

public struct SettingItem {
    let title : String
    let imageName : String
}
