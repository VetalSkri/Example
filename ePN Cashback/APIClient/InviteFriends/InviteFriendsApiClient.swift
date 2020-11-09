//
//  InviteFriendsApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 25/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class InviteFriendsApiClient: BaseApiClient {
    
    static func refferalStatusInfo(completion:@escaping (Result<ReferralsStatsResponse, Error>)->Void) {
        performRequest(router: InviteFriendsApiRouter.refferalStatusInfo, completion: completion)
    }
    
}
