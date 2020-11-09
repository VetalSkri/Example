//
//  FaqApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class FaqApiClient: BaseApiClient {

    static func answers(completion:@escaping (Result<FaqAnswersResponse, Error>)->Void) {
        performRequest(router: FaqApiRouter.answers, completion: completion)
    }
    
}
