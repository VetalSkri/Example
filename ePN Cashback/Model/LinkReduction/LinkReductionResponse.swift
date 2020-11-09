//
//  AffiliateLinkResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 02/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct LinkReductionResponse: Decodable {
    var data: LinkReductionData
}

struct LinkReductionData: Decodable {
    var type: String
    var id: String
    var attributes: [AffiliateLink]
}

public struct AffiliateLink: Decodable {
    var id: Int
    var result: String
    
}


