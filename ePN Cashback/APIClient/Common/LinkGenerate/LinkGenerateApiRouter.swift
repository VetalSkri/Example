//
//  LinkGenerateApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 31/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum LinkGenerateApiRouter: BaseApiRouter {
    
    case generate(offerId: Int, link: String?)

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
        case .generate:
            return "/offers/links"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .generate(let offerId, let link):
            var params = [Constants.APIParameterKey.ids : offerId, Constants.APIParameterKey.material : Session.shared.material, Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let link = link {
                params[Constants.APIParameterKey.urlTo] = link
            }
            return params
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
        case .generate:
            var header = defaultHeader()
            header["lang"] = Util.languageOfContent()
            return header
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
    
}
