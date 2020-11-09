//
//  VerifyLinkApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class VerifyLinkApiClient: BaseApiClient {
    
    static func verifyLink(link: String, completion:@escaping (Result<VerifyLinkResponse, Error>)->Void) {
        performRequest(router: VerifyLinkApiRouter.verifyLink(link: link), completion: completion)
    }
    
    static func priceDynamics(link: String, period: String, completion:@escaping (Result<PriceDynamicsResponse, Error>)->Void) {
        performRequest(router: VerifyLinkApiRouter.priceDynamics(link: link, period: period), completion: completion)
    }
    
}
