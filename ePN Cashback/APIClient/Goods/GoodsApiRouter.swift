//
//  GoodsApiRouter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum GoodsApiRouter: BaseApiRouter {
    
    case goodsByImage(image: String)
    case goodsByFilter(filter: GoodsSearchFilter?, limit: Int?, offset: Int?, sort: String?)
    case goodsWishlist(categories: Int?, limit: Int?, offset: Int?, sort: String?)
    case addGoodsToWishlist(offerId: Int, productId: Int)
    case removeGoodsFromWishlist(offerId: Int, productId: Int)
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .goodsByImage:
            return .post
        case .addGoodsToWishlist:
            return .post
        case .removeGoodsFromWishlist:
            return .delete
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .goodsByImage:
            return "/goods/search/by-image"
        case .goodsByFilter:
            return "/goods/search"
        case .goodsWishlist:
            return "/goods/wishlist"
        case .addGoodsToWishlist:
            return "/goods/wishlist"
        case .removeGoodsFromWishlist:
            return "/goods/wishlist"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .goodsByImage(let image):
            return [Constants.APIParameterKey.image : image]
        case .goodsByFilter(let filter, let limit, let offset, let sort):
            var parameters: Parameters = [ : ]
            if (filter != nil && filter?.hasFilter() ?? false) {
                let jsonData = try! JSONEncoder().encode(filter)
                parameters.add([Constants.APIParameterKey.filter : String(data: jsonData, encoding: .utf8) ?? ""])
            }
            if let limit = limit {
                parameters.add([Constants.APIParameterKey.limit : limit])
            }
            if let offset = offset {
                parameters.add([Constants.APIParameterKey.offset : offset])
            }
            if let sort = sort {
                parameters.add([Constants.APIParameterKey.sort : sort])
            }
            return parameters.count <= 0 ? nil : parameters
        case .goodsWishlist(let categories, let limit, let offset, let sort):
            var parameters: Parameters = [ : ]
            if let categories = categories {
                let filterObject = GoodsWishlistFilter(categories: categories)
                let jsonData = try! JSONEncoder().encode(filterObject)
                parameters.add([Constants.APIParameterKey.filter : String(data: jsonData, encoding: .utf8) ?? ""])
            }
            if let limit = limit {
                parameters.add([Constants.APIParameterKey.limit : limit])
            }
            if let offset = offset {
                parameters.add([Constants.APIParameterKey.offset : offset])
            }
            if let sort = sort {
                parameters.add([Constants.APIParameterKey.sort : sort])
            }
            return parameters.count <= 0 ? nil : parameters
        case .addGoodsToWishlist(let offerId, let productId):
            return [Constants.APIParameterKey.offerId : offerId, Constants.APIParameterKey.productId : productId]
        case .removeGoodsFromWishlist(let offerId, let productId):
            return [Constants.APIParameterKey.offerId : offerId, Constants.APIParameterKey.productId : productId]
        }
    }
    
    internal var timeout: TimeInterval {
        switch self {
        default:
            return 10
        }
    }
    
    internal var queryType: Query {
        switch self {
        case .goodsByImage:
            return .json
        case .addGoodsToWishlist:
            return .json
        case .removeGoodsFromWishlist:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        var head = defaultHeader()
        head["X-API-VERSION"] = "2.1"
        return head
    }
    
    var baseUrl: URL? {
        return nil
    }
}
