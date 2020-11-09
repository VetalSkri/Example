//
//  GoodsSearchByFilters.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct GoodsSearchByFilters: Decodable {
    var data: [GoodsSearchByFiltersData]?
    var result: Bool
    var meta: GoodsMeta
}

struct GoodsSearchByFiltersData: Decodable {
    var type: String
    var id: Int
    var attributes: GoodsAttributes
}
