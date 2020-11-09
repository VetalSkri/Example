//
//  CheckLinkResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 08/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct VerifyLinkResponse: Decodable {
    
    var data: VerifyLinkDataResponse
    var result: Bool
    
    init(data: VerifyLinkDataResponse, result: Bool) {
        self.data = data
        self.result = result
    }
}

public struct VerifyLinkDataResponse: Decodable {
    var type: String
    var id: String
    var attributes: OfferLinkInfo
}

public struct OfferLinkInfo: Decodable {
    var redirectUrl: String
    var offerName: String
    var cashback: String?
    var isHotsale: Bool?
    var affiliateType: Int
    var productName: String?
    var logoSmall: String
    var image: String
    var maxRate: String
    var ratesDesc: String
    var cashbackPackage: CashbackPackage?
}
