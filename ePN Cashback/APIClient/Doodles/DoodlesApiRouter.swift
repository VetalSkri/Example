//
//  DoodlesApiRouter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 15/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum DoodlesApiRouter: BaseApiRouter {
    
    case getDoodles

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
        case .getDoodles:
            return "/doodles/list"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
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
        var header = defaultHeader()
        header["X-API-VERSION"] = "2.1"
        return header
    }
    
    var baseUrl: URL? {
        return nil
    }
    
}
