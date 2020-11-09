//
//  Session.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 22/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    
    let client_id = "ios-client"
    let role = "cashback"
    let cashback_role = "role_cashback"
    let grant_type_password = "password"
    let grant_type_refresh_token = "refresh_token"
    let material = "cb-appios"
    var ssid: String?
    let serialQueue = DispatchQueue(label: "epn.bz.refreshToken")
    
    var access_token: String? {
        get {
            let token = UserDefaults.standard.string(forKey: "access_token")
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "access_token")
        }
    }
    
    var dev_instance: String? {
        get {
            return UserDefaults.standard.string(forKey: "dev_instance")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dev_instance")
        }
    }
    
    var refresh_token: String? {
        get {
            let refreshToken = UserDefaults.standard.string(forKey: "refresh_token")
            return refreshToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refresh_token")
            print("MYLOG: refresh_token setter, newValue is: \(newValue?.suffix(4))")
        }
    }
    
    var user_login: String {
        get {
            let userLogin = UserDefaults.standard.string(forKey: "emailOfCashBack")
            return userLogin ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "emailOfCashBack")
        }
    }
    
    var user_password: String {
        get {
            let userPassword = UserDefaults.standard.string(forKey: "passwordOfCashBack")
            return userPassword ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "passwordOfCashBack")
        }
    }
    
    var isAuth: Bool {
        get {
            let isAuthUser = UserDefaults.standard.bool(forKey: "isAuth")
            return isAuthUser
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: "isAuth")
        }
    }
    
    var timeOfTableShops: Date? {
        get {
            let tableShops = UserDefaults.standard.object(forKey: "tableShops") as? Date
            return tableShops
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "tableShops")
        }
    }
    
    var timeOfTableFavorites: Date? {
        get {
            let favoriteShops = UserDefaults.standard.object(forKey: "favoriteShops") as? Date
            return favoriteShops
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favoriteShops")
        }
    }
    
    var timeOfTableFaq: Date? {
        get {
            let tableShops = UserDefaults.standard.object(forKey: "tableFaq") as? Date
            return tableShops
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "tableFaq")
        }
    }
    
    var timeOfTableReceipt: Date? {
        get {
            let tableOffers = UserDefaults.standard.object(forKey: "tableReceipt") as? Date
            return tableOffers
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "tableReceipt")
        }
    }
    
    var timeOfTableCategoryes: Date? {
        get {
            let lifetime = UserDefaults.standard.object(forKey: "categoryCacheLifetime") as? Date
            return lifetime
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "categoryCacheLifetime")
        }
    }
    
    var timeOfTableStoreCategoryes: Date? {
        get {
            let lifetime = UserDefaults.standard.object(forKey: "storeCategoryIdsCacheLifeTime") as? Date
            return lifetime
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "storeCategoryIdsCacheLifeTime")
        }
    }
    
    var timeOfTablePayments: Date? {
        get {
            let lifetime = UserDefaults.standard.object(forKey: "paymentCacheLifetime") as? Date
            return lifetime
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "paymentCacheLifetime")
        }
    }
    
    var timeOfTablePromocode: Date? {
        get {
            let lifetime = UserDefaults.standard.object(forKey: "promocodeCacheLifetime") as? Date
            return lifetime
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "promocodeCacheLifetime")
        }
    }
    
    /**
     Storage device locale setting for reset last update date of tables
     */
    var locale : String? {
        get {
            let locale = UserDefaults.standard.object(forKey: "userLocale") as? String
            return locale
        }
        set {
            let currentLocale = UserDefaults.standard.object(forKey: "userLocale") as? String
            if currentLocale != newValue {
                self.localeHasBeenChanged()
                print("MYLOG: device locale has been changed")
            }
            UserDefaults.standard.set(newValue, forKey: "userLocale")
        }
    }
    
    var isFirstLaunchApp: Bool {
        get {
            guard let isFirstLaunch = UserDefaults.standard.value(forKey: LocalSymbolsAndAbbreviations.KEY_ALREDY_LAYNCH_APP) as? Bool else { return true }
            return isFirstLaunch
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LocalSymbolsAndAbbreviations.KEY_ALREDY_LAYNCH_APP)
        }
    }
    
    //TODO: this property had been used to notify users about new update on Backit
    var isNewUpdate: Bool {
        get {
            guard let isUpdate = UserDefaults.standard.value(forKey: LocalSymbolsAndAbbreviations.KEY_APP_HAS_BEEN_UPDATED) as? Bool else { return true }
            return isUpdate
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LocalSymbolsAndAbbreviations.KEY_APP_HAS_BEEN_UPDATED)
        }
    }
    
    /**
     Reset last time of update tables, such as faq, labels, shops, filtersOfShop, category
     
     - To use after the locale has been changed
     */
    func localeHasBeenChanged() {
        UserDefaults.standard.removeObject(forKey: "tableShops")
        UserDefaults.standard.removeObject(forKey: "tableFaq")
        UserDefaults.standard.removeObject(forKey: "favoriteShops")
        UserDefaults.standard.removeObject(forKey: "categoryCacheLifetime")
        UserDefaults.standard.removeObject(forKey: "promocodeCacheLifetime")
        UserDefaults.standard.removeObject(forKey: "paymentCacheLifetime")
    }

}
