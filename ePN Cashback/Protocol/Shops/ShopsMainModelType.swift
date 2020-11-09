//
//  MainModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 05/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

protocol ShopFavouriteAction {
    func didChangeStatusShopFavourite(shop currentShop: Store)
}

protocol ShopsMainModelType: ShopsFavoriteBehaviour, BaseShopsListModelType {
    
    var buttonTryAgainText: String { get }
    var getTitleForEmptyShopsPage: String { get }
    var needUpdate: Bool { get }
    
    func hasDoodles() -> Bool
    func headerViewModel() -> ShopMainHeaderViewModel
    func presentDoodles(completion: (() -> ())?)
    func updateList(by changedStore: Store) -> IndexPath?
    func goOnCategories()
    func goOnFavorites()
    func getRouter() -> UnownedRouter<ShopsRoute>
    func getRepository() -> StoreRepositoryProtocol
    func goOnFAQHowToBuy()
    func loadUserProfile()
    func loadUserBalance()
    
}

extension ShopsMainModelType {
    
    var buttonTryAgainText: String {
        return NSLocalizedString("Try again", comment: "")
    }
    
    var getTitleForEmptyShopsPage: String {
        return NSLocalizedString("Try again", comment: "")
    }
    
}
