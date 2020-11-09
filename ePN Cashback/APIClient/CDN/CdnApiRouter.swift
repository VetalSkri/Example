//
//  CdnApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 12/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum CdnApiRouter: BaseApiRouter {
    
    case getTokenAndUrl(type: String, visibility: String)
    case getDownloadUrl(fileId: String)
    
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
        case .getTokenAndUrl:
            return "cdn/upload/url"
        case .getDownloadUrl(let fileId):
            return "cdn/file/\(fileId)/url"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .getTokenAndUrl(let type, let visibility):
            return [Constants.APIParameterKey.type : type, Constants.APIParameterKey.visibility : visibility]
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
