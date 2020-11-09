//
//  StocksResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 05/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct StocksResponse: Codable {
    
    var data: [Stocks]?
    var meta: MetaStocksResponse?
    
    
    init(data: [Stocks]?, meta: MetaStocksResponse?) {
        self.data = data
        self.meta = meta
    }
    
}

struct MetaStocksResponse: Codable {
    var totalFound: Int
    var hasNext: Bool
}

public class Stocks: Codable {
    var id: Int
    var title: String
    var title_ru: String
    var cashback_percent: Double
    var direct_url: String
    var image: String
    var offer_id: Int
    var price: Double
    var sale_price: Double
    var valid_time: Int
    var orders_count: Int
    var exception_type: Int
    var added_at: Int
    var product_score: Double
    var cashback: Double
}


