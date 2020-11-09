//
//  PhoneResponse.swift
//  Backit
//
//  Created by Ivan Nikitin on 03/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct TimePhoneResponse: Codable {
    var data: DataTimePhoneResponse
}

struct DataTimePhoneResponse: Codable {
    var attributes: AttributeTimePhoneResponse
}

struct AttributeTimePhoneResponse: Codable {
    var moment_end: String
}

public struct PhoneResponse: Codable {
    var data: DataPhoneResponse
}

struct DataPhoneResponse: Codable {
    var attributes: AttributePhoneResponse
}

public struct AttributePhoneResponse: Codable {
    var phone: String
    var status: String
}

public struct PhoneCodeResponse: Codable {
    var request: PhoneCodeResponseRequest
}

public struct PhoneCodeResponseRequest: Codable {
    var phone: Int
    var currentPhone: Int?
    var hasAccess: Int?
    
    enum CodingKeys: String, CodingKey {
        case phone
        case currentPhone = "current_phone"
        case hasAccess = "has_access_to_old_phone"
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.phone = try container.decode(Int.self, forKey: .phone)
        self.currentPhone = try? container.decode(Int?.self, forKey: .currentPhone)
        self.hasAccess = try? container.decode(Int?.self, forKey: .hasAccess)
    }
}
