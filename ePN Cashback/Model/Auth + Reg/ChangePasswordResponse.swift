//
//  ChangePasswordResponse.swift
//  Backit
//
//  Created by Александр Кузьмин on 03/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

class ChangePasswordResponse: Codable {
    var data: ChangePasswordDataResponse
    
    init(data: ChangePasswordDataResponse) {
        self.data = data
    }
}

class ChangePasswordDataResponse: Codable {
    var type: String
    var id: String
    var attributes: ChangePasswordAttributesResponse
    
    init(type: String, id: String, attributes: ChangePasswordAttributesResponse) {
        self.type = type
        self.id = id
        self.attributes = attributes
    }
}

class ChangePasswordAttributesResponse: Codable {
    var password_changed: String
    
    init(password_changed: String) {
        self.password_changed = password_changed
    }
}
