//
//  OrderApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class OrderApiClient: BaseApiClient {

    static func orders(page: Int, perPage: Int, offerIds: String? = nil, tsFrom: String, tsTo: String, confirmTsFrom: String? = nil, confirmTsTo: String? = nil, orderNumber: String? = nil, fields: String? = nil, typeIds: String? = nil, completion:@escaping (Result<OrdersResponse, Error>)->Void) {
        performRequest(router: OrderApiRouter.orders(page: page, perPage: perPage, offerIds: offerIds, tsFrom: tsFrom, tsTo: tsTo, confirmTsFrom: confirmTsFrom, confirmTsTo: confirmTsTo, orderNumber: orderNumber, fields: fields, typeIds: typeIds), completion: completion)
    }
    
    static func offersWithMyOrders(completion:@escaping (Result<OffersWithMyOrdersResponse, Error>)->Void) {
        performRequest(router: OrderApiRouter.offersWithMyOrders, completion: completion)
    }
    
}
