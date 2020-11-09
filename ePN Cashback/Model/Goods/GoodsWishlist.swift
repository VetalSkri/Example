//
//  GoodsWishlist.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct GoodsWishlist: Decodable {
    var data: [GoodsWishlistData]?
    var result: Bool
    var meta: GoodsMeta
}

struct GoodsWishlistData: Decodable {
    var type: String
    var id: Int
    var attributes: GoodsAttributes
}

struct GoodsMeta: Decodable {
    var totalFound: Int
}
