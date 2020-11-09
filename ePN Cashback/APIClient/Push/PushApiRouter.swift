//
//  PushApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum PushApiRouter: BaseApiRouter {
    
    case sendToken(token:String)
    case deleteToken
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .sendToken:
            return .post
        case .deleteToken:
            return .delete
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .sendToken:
            return "/firebase/token"
        case .deleteToken:
            return "/firebase/token/devices/\(Util.getDeviceId())"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .sendToken(let token):
            return [Constants.APIParameterKey.token : token, Constants.APIParameterKey.deviceId : Util.getDeviceId()]
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
        case .sendToken:
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
