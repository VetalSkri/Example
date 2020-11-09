//
//  SpotlightManager.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

class SpotlightManager {
    
    public enum SpotlightDomain: String {
        case OnlineStore = "onlineStore"
        case OfflineStore = "offlineStore"
    }
    
    class func setupSpotlight(shops: [Store], domainIdentifier: SpotlightDomain) {
        var searchableItems = [CSSearchableItem]()
        
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [domainIdentifier.rawValue], completionHandler: nil)
        
        
        shops.forEach { (shop) in
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchableItemAttributeSet.title = shop.store.title
            if let maxRate = shop.store.maxRate {
                searchableItemAttributeSet.contentDescription = "\(NSLocalizedString("Cashback up to", comment: "")) \(maxRate)"
            } else {
                searchableItemAttributeSet.contentDescription = NSLocalizedString("Buy with cashback", comment: "")
            }
            searchableItemAttributeSet.keywords = [shop.store.title, shop.store.name]
            
            let item = CSSearchableItem(uniqueIdentifier: "\(domainIdentifier.rawValue):\(shop.id)", domainIdentifier: domainIdentifier.rawValue, attributeSet: searchableItemAttributeSet)
            searchableItems.append(item)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) in
            print("MYLOG: Spotlight update index items, number of items: \(searchableItems.count), with error: \(error?.localizedDescription ?? "null")")
        }
        
    }
    
    class func setupSpotlight(shops: [OfferOffline], domainIdentifier: SpotlightDomain) {
        var searchableItems = [CSSearchableItem]()
        
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [domainIdentifier.rawValue], completionHandler: nil)
        
        
        shops.forEach { (offlineOffer) in
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchableItemAttributeSet.title = offlineOffer.title
            if let description = offlineOffer.description {
                searchableItemAttributeSet.contentDescription = "\(NSLocalizedString("Cashback up to", comment: "")) \(description)"
            } else {
                searchableItemAttributeSet.contentDescription = NSLocalizedString("Buy with cashback", comment: "")
            }
            searchableItemAttributeSet.keywords = [offlineOffer.title]
            
            let item = CSSearchableItem(uniqueIdentifier: "\(domainIdentifier.rawValue):\(offlineOffer.id)", domainIdentifier: domainIdentifier.rawValue, attributeSet: searchableItemAttributeSet)
            searchableItems.append(item)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) in
            print("MYLOG: Spotlight update index items, number of items: \(searchableItems.count), with error: \(error?.localizedDescription ?? "null")")
        }
        
    }
    
}
