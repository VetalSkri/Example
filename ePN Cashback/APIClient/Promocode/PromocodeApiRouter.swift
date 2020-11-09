//
//  PromocodeApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 25/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum PromocodeApiRouter: BaseApiRouter {
    
    case check(code: String)
    case promocodes(page: Int, perPage: Int, offerIds: String?, status: String?)
    case activate(code: String)

    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .activate:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .check:
            return "/promocodes/check"
        case .promocodes:
            return "/promocodes/activated"
        case .activate:
            return "/promocodes/activate"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .check(let code):
            return [Constants.APIParameterKey.code : code]
        case .promocodes(let page, let perPage, let offerIds, let status):
            var params: Parameters = [Constants.APIParameterKey.page : page, Constants.APIParameterKey.per_Page : perPage]
            if let offerIds = offerIds {
                params[Constants.APIParameterKey.offer_id] = offerIds
            }
            if let status = status {
                params[Constants.APIParameterKey.status] = status
            }
            return params
        case .activate(let code):
            return [Constants.APIParameterKey.code : code]
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
        case .activate:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .check:
            var head = defaultHeader()
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
