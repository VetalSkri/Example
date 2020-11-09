//
//  VerifyLinkApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum VerifyLinkApiRouter: BaseApiRouter {
    
    case verifyLink(link: String)
    case priceDynamics(link: String, period: String)
    
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
        case .verifyLink:
            return "affiliate/checkLink"
        case .priceDynamics:
            return "price/dynamics/get"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .verifyLink(let link):
            return [Constants.APIParameterKey.link : link]
        case .priceDynamics(let link, let period):
            return [Constants.APIParameterKey.link : link, Constants.APIParameterKey.period : period]
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
        case .verifyLink:
            var headers = defaultHeader()
            headers["X-API-VERSION"] = "2.1"
            return headers
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
}
