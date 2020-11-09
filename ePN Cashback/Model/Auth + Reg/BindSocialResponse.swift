//
//  BindSocialResponse.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/01/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

class BindSocialResponse: Codable {
    var data: BindSocialDataResponse
    
    init(data: BindSocialDataResponse) {
        self.data = data
    }
}

class BindSocialDataResponse: Codable {
    var type: String
    var id: String
    
    init(type: String, id: String) {
        self.type = type
        self.id = id
    }
}
