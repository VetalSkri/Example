//
//  AppSettingsViewModel.swift
//  CashBackEPN
//
//  Created by Александр on 14/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

enum SettingItemType : String {
    case PushNotification = "push"
    case SystemNotification = "system"
    case NewsOnEmail = "news"
    case OrderNotification = "orders"
    case LinksInApp = "links"
}

class AppSettingsViewModel : NSObject
{
    private var settingsSource : [SettingsCategory]!
    
    override init() {
        super.init()
        buildSettingsSource()
    }
    
    private func buildSettingsSource(){
        settingsSource = [SettingsCategory]()
        let profile = Util.fetchProfile()
        let emailNotificationCategory = SettingsCategory(name: NSLocalizedString("Settings_NotificationOnEmail", comment: ""), items: [
            SettingsItem(title: NSLocalizedString("Settings_SystemNotifications", comment: ""), description: NSLocalizedString("Settings_SendSystemOnEmail", comment: ""),type: .SystemNotification ,checked: profile?.subscriptions.system ?? false),
            SettingsItem(title: NSLocalizedString("Settings_News", comment: ""), description: NSLocalizedString("Settings_InformAboutNews", comment: ""),type: .NewsOnEmail , checked: profile?.subscriptions.news ?? false),
            SettingsItem(title: NSLocalizedString("Settings_OrderNotifications", comment: ""), description: NSLocalizedString("Settings_SendNotificationAboutConfirmed", comment: ""),type: .OrderNotification , checked: profile?.subscriptions.orders ?? false)
        ])
        settingsSource.append(emailNotificationCategory)
    }
    
    var warningText: String {
        return isConfirmed() ?? false ? "" : NSLocalizedString("Settings_warning", comment: "")
    }
    
    var title: String {
        return NSLocalizedString("Settings_AppSettings", comment: "")
    }
    
    func isConfirmed() -> Bool? {
        return Util.fetchProfile()?.isConfirmed
    }
    
    func getNumberOfSections() -> Int{
        return settingsSource.count
    }
    
    func getSectionName(forSection: Int) -> String{
        return settingsSource[forSection].name
    }
    
    func getNumberOfItems(inSection: Int) -> Int{
        return settingsSource[inSection].items.count
    }
    
    func getTitleOfItem(forIndexPath: IndexPath) -> String{
        return settingsSource[forIndexPath.section].items[forIndexPath.row].title
    }
    
    func getDescriptionOfItem(forIndexPath: IndexPath) ->String{
        return settingsSource[forIndexPath.section].items[forIndexPath.row].description
    }
    
    func getCheckedOfItem(forIndexPath: IndexPath) ->Bool{
        return settingsSource[forIndexPath.section].items[forIndexPath.row].checked
    }
    
    func getTypeOfItem(forIndexPath: IndexPath) ->SettingItemType{
        return settingsSource[forIndexPath.section].items[forIndexPath.row].type
    }
    
    func getIndexPathForItem(withType: SettingItemType) -> IndexPath?{
        for (section, category) in settingsSource.enumerated() {
            for (row, item) in category.items.enumerated() {
                if (item.type == withType){
                    return IndexPath(row: row, section: section)
                }
            }
        }
        return nil
    }
    
    func selectedItem(atIndexPath: IndexPath){
        settingsSource[atIndexPath.section].items[atIndexPath.row].checked = !settingsSource[atIndexPath.section].items[atIndexPath.row].checked
    }
    
    func setSetting(ofType: SettingItemType, toState: Bool, completion:(()->())?, behaviourHandle:(()->())?, failure:(()->())?){
        ProfileApiClient.subscription(type: ofType.rawValue, status: (toState) ? 1 : 0) { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation { [weak self] in
                    if var profile = Util.fetchProfile() {
                        switch response.request.type {
                        case "system":
                            profile.subscriptions.system = (response.request.status == 0) ? false : true
                            break
                        case "news":
                            profile.subscriptions.news = (response.request.status == 0) ? false : true
                            break
                        case "orders":
                            profile.subscriptions.orders = (response.request.status == 0) ? false : true
                            break
                        default:
                            break
                        }
                        Util.saveProfileData(profile: profile)
                    }
                    self?.buildSettingsSource()
                }
                completion?()
                break
            case .failure(_):
                failure?()
                break
            }
        }
    }
    
}

public struct SettingsCategory{
    let name : String
    var items : [SettingsItem]
}

public struct SettingsItem{
    let title : String
    let description : String
    let type : SettingItemType
    var checked : Bool
}
