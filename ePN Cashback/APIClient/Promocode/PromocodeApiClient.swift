//
//  PromocodeApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 25/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class PromocodeApiClient: BaseApiClient {

    static func check(code: String, completion:@escaping (Result<CheckPromocodeResponse, Error>)->Void) {
        performRequest(router: PromocodeApiRouter.check(code: code), completion: completion)
    }
    
    static func promocodes(page: Int, perPage: Int, offerIds: String?, status: String?, completion:@escaping (Result<PromocodesResponse, Error>)->Void) {
        performRequest(router: PromocodeApiRouter.promocodes(page: page, perPage: perPage, offerIds: offerIds, status: status), completion: completion)
    }
    
    static func activate(code: String, completion:@escaping (Result<PromocodeActivateResponse, Error>)->Void) {
        performRequest(router: PromocodeApiRouter.activate(code: code), completion: completion)
    }
    
}
