//
//  SSIDResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public class SSIDResponse: Codable {
    var data: SSIDDataResponse

    init(data: SSIDDataResponse) {
        self.data = data
    }
}

class SSIDDataResponse: Codable {
    var type: String
    var id: String
    var attributes: SSIDAttributesResponse
    
    init(type: String, id: String, attributes: SSIDAttributesResponse) {
        self.type = type
        self.id = id
        self.attributes = attributes
    }
}

class SSIDAttributesResponse: Codable, ResponseProtocol {
    var ssid_token: String
    
    init(ssid_token: String) {
        self.ssid_token = ssid_token
    }
}
