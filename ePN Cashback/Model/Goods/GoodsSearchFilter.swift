//
//  GoodsSearchFilter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 15/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct GoodsSearchFilter: Encodable {
    var name: String?
    var offers: [Int]?
    var price: GoodsSearchFilterRange?
    var cashback: GoodsSearchFilterRange?
    var rate: GoodsSearchFilterRange?
    var categories: [Int]?
    
    func hasFilter() -> Bool {
        return name != nil || offers != nil || price != nil || cashback != nil || rate != nil || categories != nil
    }
}

public struct GoodsSearchFilterRange: Encodable {
    var gte: Float
    var lte: Float
}
