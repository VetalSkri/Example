//
//  ErrorResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    
    var errors: [ErrorInfo]
    
    init(errors: [ErrorInfo]) {
        self.errors = errors
    }
    
}

struct ErrorInfo: Decodable, ResponseProtocol {
    var error: Int
    var error_description: String
    var captcha: ErrorCaptcha?
    
    init(error: Int, error_description: String, captcha: ErrorCaptcha?) {
        self.error = error
        self.error_description = error_description
        self.captcha = captcha
    }
}

public struct ErrorCaptcha: Decodable {
    var type: String
    var captcha_phrase_key: String
    var captcha: ErrorImageCaptcha
    
}

struct ErrorImageCaptcha: Decodable {
    var image: String
}
