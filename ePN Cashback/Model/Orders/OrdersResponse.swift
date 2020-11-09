//
//  OrdersResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 24/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public enum OrderStatus {
    case processing
    case confirmed
    case rejected
}

public struct OrdersResponse: Codable {
    
    var data: [OrdersDataResponse]?
    var result: Bool
    var meta: MetaResponse?
    
    
    init(data: [OrdersDataResponse]?, result: Bool, meta: MetaResponse?) {
        self.data = data
        self.result = result
        self.meta = meta
    }
    
}

struct OrdersDataResponse: Codable {
    
    var type: String
    var id: String
    var attributes: Transaction
    
}

struct MetaResponse: Codable {
    var totalFound: Int
    var hasNext: Int
}

struct Transaction: Codable {
    var stats_ts: String
    var product: String
    var product_link: String
    var order_number: String
    var order_time: String
    var order_status: String
    var transaction_time: String
    var revenue: String
    var commission_user: String
    var offer_id: String
    var currency: String
    var date: String
    var type_id: String?
    
}

class Order {
    var id: String
    var order: Transaction
    
    init(id: String, transaction: Transaction) {
        self.id = id
        self.order = transaction
    }
}

