//
//  SsoApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 31/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class SsoApiClient: BaseApiClient {

    static func sso(completion:@escaping (Result<GetSSOTokenResponse, Error>)->Void) {
        performRequest(router: SsoApiRouter.sso, completion: completion)
    }
    
}
