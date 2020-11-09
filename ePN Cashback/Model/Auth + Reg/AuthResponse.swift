//
//  AuthResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public class AuthResponse: Codable {
    var data: AuthDataResponse
    var result: Bool
    
    init(result: Bool, data: AuthDataResponse) {
        self.data = data
        self.result = result
    }
}

public class AuthDataResponse: Codable {
    var type: String
    var id: String
    
    var attributes: AuthAttributesResponse
    
    init(type: String, id: String, attributes: AuthAttributesResponse) {
        self.type = type
        self.id = id
        self.attributes = attributes
    }
}

public class AuthAttributesResponse: Codable, ResponseProtocol {
    var access_token: String
    var token_type: String
    var refresh_token: String
    
    init(access_token: String, token_type: String, refresh_token: String) {
        self.access_token = access_token
        self.token_type = token_type
        self.refresh_token = refresh_token
    }
}
