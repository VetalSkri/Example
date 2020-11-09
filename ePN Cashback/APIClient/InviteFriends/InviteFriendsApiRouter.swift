//
//  InviteFriendsApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 25/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum InviteFriendsApiRouter: BaseApiRouter {
    
    case refferalStatusInfo
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .refferalStatusInfo:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .refferalStatusInfo:
            return "/stats/common-referrals-stats"
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
