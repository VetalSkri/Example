//
//  OfflineCashbackApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum OfflineCashbackApiRouter: BaseApiRouter {
    
    case multiOffers(url: URL)
    case checkResult(url: URL)
    case affiliateLink(id: Int)
    case redirectUrl(url: URL)
    case activePromotions
    case personalPromotions

    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .checkResult, .redirectUrl:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .multiOffers:
            return "/offer/info/\(LocalSymbolsAndAbbreviations.MULTY_OFFER_ID)"
        case .checkResult:
            return ""
        case .affiliateLink:
            return "/offers/links"
        case .redirectUrl:
            return ""
        case .activePromotions:
            return "/promotions/active"
        case .personalPromotions:
            return "/promotions/user-used"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .affiliateLink(let id):
            var params = [Constants.APIParameterKey.ids : id, Constants.APIParameterKey.material : Session.shared.material, Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            let c1 = URLComponents(string: "\(Util.offlineCBLink)/scan/\(id)/?")
            if let link = c1?.url?.absoluteString {
                params[Constants.APIParameterKey.urlTo] = link
            }
            return params
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
        case .checkResult, .redirectUrl:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .redirectUrl, .checkResult:
            return [:]
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        switch self {
        case .checkResult(let url):
            return url
        case .redirectUrl(let url):
            return url
        case .multiOffers(let url):
            return url
        default:
            return nil
        }
    }
    
}
