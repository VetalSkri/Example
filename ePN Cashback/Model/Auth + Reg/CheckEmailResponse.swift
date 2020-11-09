//
//  CheckEmailResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public class CheckEmailResponse: Codable, ResponseProtocol {
    var data: CheckEmailDataResponse
    var result: Bool
    
    init(result: Bool, data: CheckEmailDataResponse) {
        self.data = data
        self.result = result
    }
}

class CheckEmailDataResponse: Codable {
    var type: String
    var id: String
    
    init(type: String, id: String) {
        self.type = type
        self.id = id
    }
}


