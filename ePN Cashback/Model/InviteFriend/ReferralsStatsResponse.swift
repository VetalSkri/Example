//
//  ReferralsStatsResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct ReferralsStatsResponse: Decodable {
    
    var data: StatsReferralsAttributes
    
    init(data: StatsReferralsAttributes) {
        self.data = data
    }
    
}

struct StatsReferralsAttributes: Decodable {
    var type: String
    var id: String
    var attributes: StatsReferrals
}

public class StatsReferrals: Decodable {
    var amountTotal: Double
    var amountHoldTotal: Double
    var referralsCount: Int
    
    init(amountTotal: Double, amountHoldTotal: Double, referralsCount: Int) {
        self.amountTotal = amountTotal
        self.amountHoldTotal = amountHoldTotal
        self.referralsCount = referralsCount
    }
}


