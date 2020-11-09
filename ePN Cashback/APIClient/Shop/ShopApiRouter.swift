//
//  ShopApiRouter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 19/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum ShopApiRouter: BaseApiRouter {
    
    case shopInfo(forShopId: Int)
    case offlineShopInfo(forShopId: Int)
    case addToFavorite(shopId: Int)
    case deleteFromFavorite(shopId: Int)
//    case labels
    case favorites
    case offersByCategory(categoryId: Int, order: String)
    case offers(labelIds: String?, search: String?, limit: Int?, offset: Int?, categoryIds: String?, order: String?, typeId: Int?)
    case categoryOffers(limit: Int?)
    case categoryOfflineOffers(limit: Int?)
    case category(offerId: Int?, shopTypeID: ShopTypeId)
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .addToFavorite:
            return .post
        case .deleteFromFavorite:
            return .delete
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .shopInfo(let shopId):
            return "/offers/\(shopId)"
        case .offlineShopInfo(let shopId):
            return "/offers/\(shopId)"
        case .addToFavorite(let shopId):
            return "/offers/\(shopId)/labels/favorite"
        case .deleteFromFavorite(let shopId):
            return "/offers/\(shopId)/labels/favorite"
        case .favorites:
            return "/offers/favorite"
//        case .labels:
//            return "/labels/list"
        case .categoryOffers:
            return "/offers/list"
        case .categoryOfflineOffers:
            return "/offers/list"
        case .offersByCategory:
            return "/offers/getByCategories"
        case .offers:
            return "/offers/list"
        case .category:
            return "/offers/categories"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .offersByCategory(let categoryId, let order):
            return [Constants.APIParameterKey.categoryIds : categoryId, Constants.APIParameterKey.order : order, Constants.APIParameterKey.lang : Util.languageOfContent()]
        case .offers(let labelIds, let search, let limit, let offset, let categoryIds, let order, let typeId):
            var params = [Constants.APIParameterKey.viewRules : Session.shared.cashback_role, Constants.APIParameterKey.lang : Util.languageOfContent(), Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let typeId = typeId, typeId == ShopTypeId.offlineMulty.rawValue {
                params[Constants.APIParameterKey.lang] = "ru"
            }
            if let limit = limit {
                params[Constants.APIParameterKey.limit] = limit
            }
            if let offset = offset {
                params[Constants.APIParameterKey.offset] = offset
            }
            if let labelIds = labelIds {
                params[Constants.APIParameterKey.labelIds] = labelIds
            }
            if let search = search {
                params[Constants.APIParameterKey.search] = search
            }
            if let categoryIds = categoryIds {
                params[Constants.APIParameterKey.categoryIds] = categoryIds
            }
            if let order = order {
                params[Constants.APIParameterKey.order] = order
            }
            if let typeId = typeId {
                params[Constants.APIParameterKey.typeId] = String(typeId)
            }
            return params
        case .categoryOffers(let limit):
            var params = [Constants.APIParameterKey.viewRules : Session.shared.cashback_role, Constants.APIParameterKey.lang : Util.languageOfContent(), Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let limit = limit {
                params[Constants.APIParameterKey.limit] = limit
            }
            params[Constants.APIParameterKey.fields] = Constants.APIParameterKey.categoryIds
            return params
        case .categoryOfflineOffers(let limit):
            var params = [Constants.APIParameterKey.viewRules : Session.shared.cashback_role, Constants.APIParameterKey.lang : "ru", Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let limit = limit {
                params[Constants.APIParameterKey.limit] = limit
            }
            params[Constants.APIParameterKey.fields] = Constants.APIParameterKey.categoryIds
            params[Constants.APIParameterKey.typeId] = ShopTypeId.offlineMulty.rawValue
            return params
        case .category(let offerId, let shopTypeID):
            var params =  [Constants.APIParameterKey.lang : Util.languageOfContent()] as [String : Any]
            if let offerId = offerId {
                params[Constants.APIParameterKey.offerId] = offerId
            }
            params[Constants.APIParameterKey.typeIds] = shopTypeID.rawValue
            params[Constants.APIParameterKey.containingOffers] = true
            return params
        default:
            return nil
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
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .shopInfo:
            var head = defaultHeader()
            head["X-API-VERSION"] = "2.1"
            head["X-ACCESS-TOKEN"] = ""
            head["ACCEPT-LANGUAGE"] = Util.languageOfContent()
            return head
        case .offlineShopInfo:
            var head = defaultHeader()
            head["X-API-VERSION"] = "2.1"
            head["ACCEPT-LANGUAGE"] = "ru"
            head["X-ACCESS-TOKEN"] = ""
            return head
        case .offersByCategory:
            var head = defaultHeader()
            head["X-API-VERSION"] = "2.1"
            return head
        case .offers(_, _, _, _, _, _, let typeId):
            var head = defaultHeader()
            head["X-ACCESS-TOKEN"] = ""
            head["X-API-VERSION"] = "2.1"
            if let typeId = typeId, typeId == ShopTypeId.offlineMulty.rawValue {
                head["ACCEPT-LANGUAGE"] = "ru"
            }
            return head
        case .categoryOffers:
            var head = defaultHeader()
            head["X-ACCESS-TOKEN"] = ""
            head["X-API-VERSION"] = "2.1"
            return head
        case .categoryOfflineOffers:
            var head = defaultHeader()
            head["X-ACCESS-TOKEN"] = ""
            head["X-API-VERSION"] = "2.1"
            return head
        case .category:
            var head = defaultHeader()
            head["X-ACCESS-TOKEN"] = ""
            head["X-API-VERSION"] = "2.1"
            return head
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
}
