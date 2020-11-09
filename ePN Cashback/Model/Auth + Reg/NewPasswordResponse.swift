//
//  NewPasswordResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 17/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public class NewPasswordResponse: Codable, ResponseProtocol {
    var result: Bool
    
    init(result: Bool) {
        self.result = result
    }
}
