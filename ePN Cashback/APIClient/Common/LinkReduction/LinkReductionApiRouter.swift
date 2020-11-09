//
//  LinkReductionApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 31/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum LinkReductionApiRouter: BaseApiRouter {
    
    case reduction(urlString: String)

    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .reduction:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .reduction:
            return "/link-reduction"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .reduction(let urlString):
            return [Constants.APIParameterKey.urlContainer : urlString]
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
        case .reduction:
            return .json
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
