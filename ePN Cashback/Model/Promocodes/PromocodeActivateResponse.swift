//
//  PromocodeActivateResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 03/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PromocodeActivateResponse: Decodable {
    var data: PromocodeActivateData
}

struct PromocodeActivateData: Decodable {
    var type: String
    var id: String
    var attributes: PromocodeActivateInfo
}

public struct PromocodeActivateInfo: Decodable {
    var code: String
    var activation_date: String
    var expired_at: String
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case code, activation_date, expired_at, status
    }
    
    init (code: String, activation_date: String, expired_at: String, status: String) {
        self.code = code
        self.activation_date = activation_date
        self.expired_at = expired_at
        self.status = status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activation_date = try container.decode(String.self, forKey: .activation_date)
        expired_at = try container.decode(String.self, forKey: .expired_at)
        status = try container.decode(String.self, forKey: .status)
        if let value = try? container.decode(Int.self, forKey: .code) {
            code = String(value)
        } else {
            code = try container.decode(String.self, forKey: .code)
        }
    }
}



