//
//  PromocodesResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PromocodesResponse: Decodable {
    var data: [PromocodesData]?
    var meta: MetaPromocodesResponse
}

struct PromocodesData: Decodable {
    var type: String
    var id: Int
    var attributes: Promocodes
}

struct MetaPromocodesResponse: Codable {
    var totalFound: Int
    var hasNext: Bool
}

struct Promocodes: Codable {
    //FIXME: - help me PLEASE!!! code: Int (BACked bug)
    var code: String
    var activated_at: String
    var expire_at: String
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case code, activated_at, expire_at, status
    }
    
    init (code: String, activated_at: String, expire_at: String, status: String) {
        self.code = code
        self.activated_at = activated_at
        self.expire_at = expire_at
        self.status = status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activated_at = try container.decode(String.self, forKey: .activated_at)
        expire_at = try container.decode(String.self, forKey: .expire_at)
        status = try container.decode(String.self, forKey: .status)
        if let value = try? container.decode(Int.self, forKey: .code) {
            code = String(value)
        } else {
            code = try container.decode(String.self, forKey: .code)
        }
    }
}


