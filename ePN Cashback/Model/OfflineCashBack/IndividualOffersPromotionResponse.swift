//
//  OfferPromotionResponse.swift
//  Backit
//
//  Created by Ivan Nikitin on 22/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct IndividualOffersPromotionResponse: Codable {
    var data: [IndividualOffersPromotionDataResponse]
}

public struct IndividualOffersPromotionDataResponse: Codable {
    var type: String
    var id: Int
    var attributes: IndividualOfferPromotions
}

public struct IndividualOfferPromotions: Codable {
    var offerId: Int
    var status: String
    var momentStart: String
    var momentEnd: String
    var level: Int
    var levelCommissionUser: Double
    var levelTransactionsCount: Int
    var levelOrderVolume: Int
    var levelRevenue: Double
}
