//
//  OffersPromotionAttributes.swift
//  Backit
//
//  Created by Ivan Nikitin on 22/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct OffersPromotionResponse: Codable {
    var data: [OfferPromotionsDataResponse]
}

public struct OfferPromotionsDataResponse: Codable {
    var type: String
    var id: Int
    var attributes: OfferPromotions
}

public struct OfferPromotions: Codable {
    var offerId: Int
    var status: String
    var momentStart: String
    var momentEnd: String
    var schemas: [OfferPromotionSchemas]?
}

public struct OfferPromotionSchemas: Codable {
    var id: Int
    var promotionId: Int
    var levelStart: Int
    var levelEnd: Int
    var counterType: String
    var counterLevelLimit: Int
    var schemaDescription: OfferPromotionSchemaDescription?
}

public struct OfferPromotionSchemaDescription: Codable {
    var description: String?
    var cashbackSize: String?
    var condition: String?
}
