//
//  BalanceResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct BalanceResponse: Codable {
    
    var data: [BalanceDataResponse]
    var result: Bool
    var meta: MetaBalanceResponse
    
    init(data: [BalanceDataResponse], result: Bool, meta: MetaBalanceResponse) {
        self.data = data
        self.result = result
        self.meta = meta
    }
    
}

struct MetaBalanceResponse: Codable {
    var userBlocked: Bool
}


public struct BalanceDataResponse: Codable {
    var type: String
    var id: String
    var attributes: BalanceInfo
}

struct BalanceInfo: Codable {
    var availableAmount: Double
    var holdAmount: Double
    var allMoney: Double
    var existBalance: Int
}

public class Balance {
    var id: String
    var balance: BalanceInfo
    
    init(id: String, balance: BalanceInfo) {
        self.id = id
        self.balance = balance
    }
}
