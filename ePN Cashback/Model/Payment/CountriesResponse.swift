//
//  CountriesResponse.swift
//  Backit
//
//  Created by Виталий Скриганюк on 25.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct SearchGeoResponse: Decodable,ResponseProtcol {
    var data: [SearchGeoDataResponse]
    var result: Bool?
    var request: [String] = []
}

struct SearchGeoDataResponse: Decodable, ResponseProtcol {
    var type: String?
//    var id: String?
    var attributes: SearchGeoAttributesResponse?
}

struct SearchGeoAttributesResponse: Decodable, ResponseProtcol {
    var countryCode: String?
    var name: String?
    
    enum CodingKeys: String ,CodingKey {
        case countryCode = "code"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.countryCode = try? container?.decode(String.self, forKey: .countryCode)
        self.name = try? container?.decode(String.self, forKey: .name)
    }
}
