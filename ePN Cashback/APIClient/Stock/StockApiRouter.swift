//
//  StockApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum StockApiRouter: BaseApiRouter {
    
    case stocks(page: Int, perPage: Int, order: String?, sortType: String?, search: String?, filterFrom: Int?, filterTo: Int?, filterGoods: Int?, filterOffers: String?)

    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .stocks:
            return "/goods/hot-sells"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .stocks(let page, let perPage, let order, let sortType, let search, let filterFrom, let filterTo, let filterGoods, let filterOffers):
            var parameters = Alamofire.Parameters()
            parameters[Constants.APIParameterKey.page] = page
            parameters[Constants.APIParameterKey.perPage] = perPage
            if let order = order { parameters[Constants.APIParameterKey.order] = order }
            if let sortType = sortType { parameters[Constants.APIParameterKey.sortType] = sortType }
            if let search = search { parameters[Constants.APIParameterKey.search] = search }
            if let filterTo = filterTo { parameters[Constants.APIParameterKey.filterTo] = filterTo }
            if let filterFrom = filterFrom { parameters[Constants.APIParameterKey.filterFrom] = filterFrom }
            if let filterGoods = filterGoods { parameters[Constants.APIParameterKey.filterGoods] = filterGoods }
            if let filterOffers = filterOffers { parameters[Constants.APIParameterKey.filterOffers] = filterOffers }
            return parameters
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
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
}
