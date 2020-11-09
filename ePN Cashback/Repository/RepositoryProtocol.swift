//
//  RepositoryProtocol.swift
//  Backit
//
//  Created by Ivan Nikitin on 30/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    
}

extension RepositoryProtocol {
    
    func isExpiredStores() -> Bool {
        guard let date = Session.shared.timeOfTableShops else { return true }
        let now = Date()
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING {
            return true
        } else {
            return false
        }
    }
    
    func isExpiredFavorites() -> Bool {
        guard let date = Session.shared.timeOfTableFavorites else { return true }
        let now = Date()
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_FAVORITE {
            return true
        } else {
            return false
        }
    }
    
    func isExpiredCategories() -> Bool {
        guard let date = Session.shared.timeOfTableCategoryes else { return true }
        let now = Date()
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_CATEGORY {
            return true
        } else {
            return false
        }
    }
    
    func isExpiredStoresCategories() -> Bool {
        guard let date = Session.shared.timeOfTableStoreCategoryes else { return true }
        let now = Date()
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_STORE_CATEGORY {
            return true
        } else {
            return false
        }
    }
    
    func isExpiredOfflineOffers() -> Bool {
        let now = Date()
        guard let date = Session.shared.timeOfTableReceipt else {
            return true
        }
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_RECEIPT {
            return true
        } else {
            return false
        }
    }
    
}
