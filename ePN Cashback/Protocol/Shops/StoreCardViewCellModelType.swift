//
//  StoreCardViewCellModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 12/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol StoreCardViewCellModelType: class, DownloaderImagesProtocol {
    
    var store: Store { get }
    
    func shopTitle() -> (storeName: String, maxRate: String?, isMaxRatePretext: Bool)
    
    
    func getStatusOfLike() -> Bool
    
    func getStore() -> Store
    
}

extension StoreCardViewCellModelType {
    
    func getStore() -> Store {
        return store
    }
    
    func shopTitle() -> (storeName: String, maxRate: String?, isMaxRatePretext: Bool) {
        return (store.store.title, store.store.maxRate,!store.store.maxRatePretext!.isEmpty)
    }
    
    func urlStringOfLogo() -> String? {
        return store.store.image
    }
    
    func getStatusOfLike() -> Bool {
        return store.isFavorite
    }
    
}
