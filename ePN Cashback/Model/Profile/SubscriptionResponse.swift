//
//  SubscriptionResponse.swift
//  CashBackEPN
//
//  Created by Александр on 15/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct SubscriptionResponse : Decodable {
    
    var request : SubscriptionState
    
}

public struct SubscriptionState : Decodable {
    var type : String
    var status : Int
}
