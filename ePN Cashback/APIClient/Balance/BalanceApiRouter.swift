//
//  BalanceApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum BalanceApiRouter: BaseApiRouter {
    
    case balance(clientId: String)

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
        case .balance:
            return "/purses/balance"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .balance(let clientId):
            return [Constants.APIParameterKey.clientId : clientId]
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
