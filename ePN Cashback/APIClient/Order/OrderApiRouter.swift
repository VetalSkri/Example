//
//  OrderApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum OrderApiRouter: BaseApiRouter {
    
    case orders(page: Int, perPage: Int, offerIds: String?, tsFrom: String, tsTo: String, confirmTsFrom: String?, confirmTsTo: String?, orderNumber: String?, fields: String?, typeIds: String?)
    case offersWithMyOrders

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
        case .orders:
            return "/transactions"
        case .offersWithMyOrders:
            return "/offers/transactions/list"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .orders(let page, let perPage, let offerIds, let tsFrom, let tsTo, let confirmTsFrom, let confirmTsTo, let orderNumber, let fields, let typeIds):
            var parameters = Alamofire.Parameters()
            parameters[Constants.APIParameterKey.page] = page
            parameters[Constants.APIParameterKey.perPage] = perPage
            parameters[Constants.APIParameterKey.tsFrom] = tsFrom
            parameters[Constants.APIParameterKey.tsTo] = tsTo
            if let offerIds = offerIds {
                parameters[Constants.APIParameterKey.offerIds] = offerIds
            }
            if let confirmTsFrom = confirmTsFrom {
                parameters[Constants.APIParameterKey.confirmTsFrom] = confirmTsFrom
            }
            if let confirmTsTo = confirmTsTo {
                parameters[Constants.APIParameterKey.confirmTsTo] = confirmTsTo
            }
            if let orderNumber = orderNumber {
                parameters[Constants.APIParameterKey.orderNumber] = orderNumber
            }
            if let fields = fields {
                parameters[Constants.APIParameterKey.fields] = fields
            }
            if let typeIds = typeIds {
                parameters[Constants.APIParameterKey.typeIds] = typeIds
            }
            return parameters
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
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
}
