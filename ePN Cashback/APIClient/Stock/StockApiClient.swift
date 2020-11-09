//
//  StockApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 28/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class StockApiClient: BaseApiClient {

    static func stocks(page: Int, perPage: Int, order: String? = nil, sortType: String? = nil, search: String? = nil, filterFrom: Int? = nil, filterTo: Int? = nil, filterGoods: Int? = nil, filterOffers: String? = nil, completion:@escaping (Result<StocksResponse, Error>)->Void) {
        performRequest(router: StockApiRouter.stocks(page: page, perPage: perPage, order: order, sortType: sortType, search: search, filterFrom: filterFrom, filterTo: filterTo, filterGoods: filterGoods, filterOffers: filterOffers), completion: completion)
    }
    
}
