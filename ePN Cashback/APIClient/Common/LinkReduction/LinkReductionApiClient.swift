//
//  LinkReductionApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 31/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class LinkReductionApiClient: BaseApiClient {

    static func reduction(urlString: String, completion:@escaping (Result<LinkReductionResponse, Error>)->Void) {
        performRequest(router: LinkReductionApiRouter.reduction(urlString: urlString), completion: completion)
    }
    
}
