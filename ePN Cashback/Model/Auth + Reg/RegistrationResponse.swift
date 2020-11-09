//
//  RegistrationResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public class RegistrationResponse: Codable {
    var data: RegistrationDataResponse
    
    init(data: RegistrationDataResponse) {
        self.data = data
    }
}

class RegistrationDataResponse: Codable {
    var type: String
    var id: String
    var attributes: RegistrationAttributesResponse
    
    init(type: String, id: String, attributes: RegistrationAttributesResponse) {
        self.type = type
        self.id = id
        self.attributes = attributes
    }
}

public class RegistrationAttributesResponse: Codable, ResponseProtocol {
    var access_token: String
    var token_type: String
    var refresh_token: String
    
    init(access_token: String, token_type: String, refresh_token: String) {
        self.access_token = access_token
        self.token_type = token_type
        self.refresh_token = refresh_token
    }
}
