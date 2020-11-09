//
//  FaqApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum FaqApiRouter: BaseApiRouter {
    
    case answers

    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .answers:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .answers:
            return "/faq/answers/cashback"
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
        switch self {
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
}
