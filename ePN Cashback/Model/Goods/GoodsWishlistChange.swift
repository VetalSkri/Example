//
//  GoodsAddToWishlist.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct GoodsWishlistChange: Decodable {
    var data: GoodsWishlistChangeData
}

struct GoodsWishlistChangeData: Decodable {
    var type: String
    var attributes: GoodsWishlistChangeAttributes
}

struct GoodsWishlistChangeAttributes: Decodable {
    var inWishlist: Bool
    var offerId: Int
    var productId: Int
    
    enum CodingKeys: String, CodingKey {
        case inWishlist
        case offerId
        case productId
    }
    
    public init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inWishlist = try container.decode(Int.self, forKey: .inWishlist) == 1 ? true : false
        self.offerId = try container.decode(Int.self, forKey: .offerId)
        self.productId = try container.decode(Int.self, forKey: .productId)
        
    }
}
