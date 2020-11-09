//
//  PushApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class PushApiClient: BaseApiClient {
    
    static func sendToken(token:String, completion:@escaping (Result<PushResponse, Error>)->Void) {
        performRequest(router: PushApiRouter.sendToken(token: token), completion: completion)
    }
    
    static func deleteToken(completion:@escaping (Result<PushResponse, Error>)->Void) {
        performRequest(router: PushApiRouter.deleteToken, completion: completion)
    }
    
}
