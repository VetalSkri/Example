//
//  CheckPromocodeResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 03/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct CheckPromocodeResponse: Decodable {
    var data: CheckPromocodeData
}

struct CheckPromocodeData: Decodable {
    var type: String
    var id: String
    var attributes: PromocodeInfo
}

public struct PromocodeInfo: Decodable {
    var code: String
    var active_seconds: Int
    var status: String
    var start_at: String
    var expire_at: String
    
    enum CodingKeys: String, CodingKey {
        case code, active_seconds, status, start_at, expire_at
    }
    
    init (code: String, active_seconds: Int, status: String, start_at: String, expire_at: String) {
        self.code = code
        self.active_seconds = active_seconds
        self.status = status
        self.start_at = start_at
        self.expire_at = expire_at
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        active_seconds = try container.decode(Int.self, forKey: .active_seconds)
        status = try container.decode(String.self, forKey: .status)
        start_at = try container.decode(String.self, forKey: .start_at)
        expire_at = try container.decode(String.self, forKey: .expire_at)
        if let value = try? container.decode(Int.self, forKey: .code) {
            code = String(value)
        } else {
            code = try container.decode(String.self, forKey: .code)
        }
    }
}


