//
//  OffersWithMyOrdersResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 24/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct OffersWithMyOrdersResponse: Decodable {
    
    var data: [OffersWithMyOrdersDataResponse]?
    var result: Bool
    
    init(data: [OffersWithMyOrdersDataResponse]?, result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct OffersWithMyOrdersDataResponse: Decodable {
    
    var type: String
    var id: Int
    var attributes: OffersWithMyOrders
    
}

public class OffersByOrders {
    let id: Int
    let offer: OffersWithMyOrders
    
    init(id: Int, offer: OffersWithMyOrders) {
        self.id = id
        self.offer = offer
    }
}

struct OffersWithMyOrders: Decodable {
    var logo_small: String?           //"https://epn.bz/uploads/2017-09-12/ow64i2d5be00k3qitpt0sl5rhhs9vduu.png"
    var name: String
}
