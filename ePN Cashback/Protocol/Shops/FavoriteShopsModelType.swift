//
//  ShopListModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 12/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol FavoriteShopsModelType: ShopsFavoriteBehaviour, ShopsListModelType {
    
    var getTextForEmptyFavouritePage: String { get }
    
//    func presentData(completion: ((Bool)->())?, failure: (()->())?)
    func hasBeenChanged() -> Bool
    func selectItem(atIndexPath indexPath: IndexPath)
    func updateSelectedItem() -> IndexPath?
    func index(of shop: Store) -> IndexPath?
    func updateList(by changedStore: Store) -> IndexPath?
}

extension FavoriteShopsModelType {
    
    var getTextForEmptyFavouritePage: String {
        return NSLocalizedString("Add favourite offers", comment: "")
    }
    
}
