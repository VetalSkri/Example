//
//  OrderRepositoryProtocol.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol OrderRepositoryProtocol {
    
    func getOrders(page: Int, perPage: Int, offerIds: [Int]?, tsFrom: String?, tsTo: String?, type: String?, searchText: String?) -> Observable<Result<[OrdersDataResponse], Error>>
    func getOfferByTransactions() -> Observable<Result<[OffersWithMyOrdersDataResponse], Error>>
    
}
