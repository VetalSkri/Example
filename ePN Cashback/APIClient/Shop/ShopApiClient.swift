//
//  ShopApiClient.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 19/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class ShopApiClient: BaseApiClient {
    
    static func shopInfo(forShopId: Int, completion:@escaping (Result<ShopInfoContainer, Error>)->Void) {
        performRequest(router: ShopApiRouter.shopInfo(forShopId: forShopId), completion: completion)
    }
    
    static func offlineShopInfo(forShopId: Int, completion:@escaping (Result<OfflineShopInfoContainer, Error>)->Void) {
        performRequest(router: ShopApiRouter.offlineShopInfo(forShopId: forShopId), completion: completion)
    }
    
    static func addToFavorite(forShopId: Int, completion:@escaping (Result<ChangeFavoriteStateResult, Error>)->Void) {
        performRequest(router: ShopApiRouter.addToFavorite(shopId: forShopId), completion: completion)
    }
    
    static func deleteFromFavorite(forShopId: Int, completion:@escaping (Result<ChangeFavoriteStateResult, Error>)->Void) {
        performRequest(router: ShopApiRouter.deleteFromFavorite(shopId: forShopId), completion: completion)
    }
    
    static func favorites(completion:@escaping (Result<FavoritesResponse, Error>)->Void) {
        performRequest(router: ShopApiRouter.favorites, completion: completion)
    }
    
    static func offersByCategory(categoryId: Int, order: String, completion:@escaping (Result<OffersResponse, Error>)->Void) {
        performRequest(router: ShopApiRouter.offersByCategory(categoryId: categoryId, order: order), completion: completion)
    }
    
    static func categoryOffers(completion:@escaping (Result<CategoryOffersResponse, Error>)->Void) {
        performRequest(router: ShopApiRouter.categoryOffers(limit: 1000), completion: completion)
    }
    
    static func categoryOfflineOffers(completion:@escaping (Result<CategoryOffersResponse, Error>)->Void) {
        performRequest(router: ShopApiRouter.categoryOfflineOffers(limit: 1000), completion: completion)
    }
    
    static func offers(labelIds: String? = nil, search: String? = nil, limit: Int? = nil, offset: Int? = nil, categoryIds: String? = nil, order: String? = nil, typeId: Int? = nil, completion:@escaping (Result<OffersResponse, Error>)->Void) {
        performRequest(router: ShopApiRouter.offers(labelIds: labelIds, search: search, limit: limit, offset: offset, categoryIds: categoryIds, order: order, typeId: typeId), completion: completion)
    }
    
    static func category(shopTypeID: ShopTypeId, offerId: Int? = nil, completion:@escaping (Result<CategoriesResponse, Error>)->Void) {
        performRequest(router: ShopApiRouter.category(offerId: offerId, shopTypeID: shopTypeID), completion: completion)
    }
    
}
