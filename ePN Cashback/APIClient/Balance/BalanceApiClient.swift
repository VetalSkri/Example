//
//  BalanceApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class BalanceApiClient: BaseApiClient {

    static func balance(completion:@escaping (Result<BalanceResponse, Error>)->Void) {
        performRequest(router: BalanceApiRouter.balance(clientId: Session.shared.client_id), completion: completion)
    }
    
}
