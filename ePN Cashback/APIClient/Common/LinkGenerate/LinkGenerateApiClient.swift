//
//  LinkGenerateApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 31/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class LinkGenerateApiClient: BaseApiClient {

    static func generate(offerId: Int, link: String? = nil, completion:@escaping (Result<LinkGenerateResponse, Error>)->Void) {
        performRequest(router: LinkGenerateApiRouter.generate(offerId: offerId, link: link), completion: completion)
    }
    
}
