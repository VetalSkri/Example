//
//  GoodsApiClient.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class GoodsApiClient: BaseApiClient {
    
    static func findGoodsByImage(image: String, completion:@escaping (Result<GoodsSearchByImage, Error>)->Void) {
        performRequest(router: GoodsApiRouter.goodsByImage(image: image), completion: completion)
    }
    
    static func goodsByFilter(filter: GoodsSearchFilter?, limit: Int?, offset: Int?, sort: String?, completion:@escaping (Result<GoodsSearchByImage, Error>)->Void) {
        performRequest(router: GoodsApiRouter.goodsByFilter(filter: filter, limit: limit, offset: offset, sort: sort), completion: completion)
    }
    
    static func goodsWishlist(categories: Int?, limit: Int?, offset: Int?, sort: String?, completion:@escaping (Result<GoodsSearchByImage, Error>)->Void) {
        performRequest(router: GoodsApiRouter.goodsWishlist(categories: categories, limit: limit, offset: offset, sort: sort), completion: completion)
    }
    
    static func addGoodsToWishlist(offerId: Int, productId: Int, completion:@escaping (Result<GoodsWishlistChange, Error>)->Void) {
        performRequest(router: GoodsApiRouter.addGoodsToWishlist(offerId: offerId, productId: productId), completion: completion)
    }
    
    static func removeGoodsFromWishlist(offerId: Int, productId: Int, completion:@escaping (Result<GoodsWishlistChange, Error>)->Void) {
        performRequest(router: GoodsApiRouter.removeGoodsFromWishlist(offerId: offerId, productId: productId), completion: completion)
    }
}
