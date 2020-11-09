//
//  GetSSOTokenResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct GetSSOTokenResponse: Decodable {
    
    var data: GetSSOTokenDataResponse
    var result: Bool
    
    init(data: GetSSOTokenDataResponse, result: Bool) {
        self.data = data
        self.result = result
    }
    
}

struct GetSSOTokenDataResponse: Decodable {
    var type: String
    var id: String
    var attributes: SSOToken
}

public struct SSOToken: Decodable {
    var ssoToken: String
}
