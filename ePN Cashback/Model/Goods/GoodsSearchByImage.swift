//
//  GoodsSearchByImage.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct GoodsSearchByImage: Decodable {
    var data: [GoodsSearchByImageData]?
    var result: Bool
    var meta: GoodsMeta
}

struct GoodsSearchByImageData: Decodable {
    var type: String
    var id: Int
    var attributes: GoodsAttributes
}

public struct GoodsAttributes: Decodable {
    var cashback: GoodsCashback
    var cashbackUrl: String
    var categories: [Int]
    var currency: String
    var deletedAt: Date?
    var label: String?
    var image: String
    //var name: String
    var offer: GoodsOffer
    var offerId: Int
    var orders: Int
    var priceChange: Int
    var priceOriginal: Float
    var priceSale: Float
    var productId: Int
    var rate: Int
    var sefName: String
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case cashback
        case cashbackUrl
        case categories
        case currency
        case deletedAt
        case label
        case image
        //case name
        case offer
        case offerId
        case orders
        case priceChange
        case priceOriginal
        case priceSale
        case productId
        case rate
        case sefName
        case updatedAt
    }
    
    public init (from decoder: Decoder) throws{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cashback = try container.decode(GoodsCashback.self, forKey: .cashback)
        self.cashbackUrl = try container.decode(String.self, forKey: .cashbackUrl)
        self.categories = try container.decode([Int].self, forKey: .categories)
        self.currency = try container.decode(String.self, forKey: .currency)
        let deletedAtString = try container.decode(String?.self, forKey: .deletedAt)
        self.deletedAt = deletedAtString != nil ? dateFormatter.date(from: deletedAtString!) : nil
        self.label = try container.decode(String?.self, forKey: .label)
        self.image = try container.decode(String.self, forKey: .image)
        self.offer = try container.decode(GoodsOffer.self, forKey: .offer)
        self.offerId = try container.decode(Int.self, forKey: .offerId)
        self.orders = try container.decode(Int.self, forKey: .orders)
        self.priceChange = try container.decode(Int.self, forKey: .priceChange)
        self.priceOriginal = try container.decode(Float.self, forKey: .priceOriginal)
        self.priceSale = try container.decode(Float.self, forKey: .priceSale)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.rate = try container.decode(Int.self, forKey: .rate)
        self.sefName = try container.decode(String.self, forKey:.sefName)
        let updatedAtString = try container.decode(String?.self, forKey: .updatedAt)
        self.updatedAt = updatedAtString != nil ? dateFormatter.date(from: updatedAtString!) : nil
    }
    
}

struct GoodsCashback: Decodable {
    var fixed: Float
    var percent: Float
}

struct GoodsOffer: Decodable {
    var deletedAt: Date?
    var id: Int
    var images: GoodsOfferImage
    var name: String
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case deletedAt
        case id
        case images
        case name
        case updatedAt
    }
    
    init (from decoder: Decoder) throws{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let deletedAtString = try container.decode(String?.self, forKey: .deletedAt)
        self.deletedAt = deletedAtString != nil ? dateFormatter.date(from: deletedAtString!) : nil
        self.id = try container.decode(Int.self, forKey: .id)
        let updatedAtString = try container.decode(String?.self, forKey: .updatedAt)
        self.updatedAt = updatedAtString != nil ? dateFormatter.date(from: updatedAtString!) : nil
        self.name = try container.decode(String.self, forKey: .name)
        self.images = try container.decode(GoodsOfferImage.self, forKey: .images)
    }
}

struct GoodsOfferImage: Decodable {
    var image: String
    var logo: String
    var logoSmall: String
}
