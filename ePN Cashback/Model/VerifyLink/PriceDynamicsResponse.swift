//
//  PriceDynamicResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 08/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PriceDynamicsResponse: Decodable {
    var data: [PriceDynamicsDataResponse]
    var meta: MetaPriceDynamics
    
    init(data: [PriceDynamicsDataResponse], meta: MetaPriceDynamics) {
        self.data = data
        self.meta = meta
    }
}

struct MetaPriceDynamics: Decodable {
    var maxPrice: Double
    var minPrice: Double
    var currency: String
}


struct PriceDynamicsDataResponse: Decodable {
    var type: String
    var id: Int
    var attributes: CostOfGoods

}

struct CostOfGoods: Decodable {
    var date: String
    var price: Double
}
