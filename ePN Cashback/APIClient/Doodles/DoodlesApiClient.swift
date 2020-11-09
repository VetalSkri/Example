//
//  DoodlesApiClient.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 15/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class DoodlesApiClient: BaseApiClient {

    static func getDoodles(completion:@escaping (Result<Doodles, Error>)->Void) {
        performRequest(router: DoodlesApiRouter.getDoodles, completion: completion)
    }
    
}
