//
//  Logger.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 04/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Crashlytics

class Logger {
    
    static func execParsing(e: Error, domain: String? = nil) {
        let parsingError = e as NSError
        let crashlyticsError = NSError(domain: domain ?? parsingError.domain, code: parsingError.code, userInfo: parsingError.userInfo)
        print("Logger error: domain: \(String(describing: domain)) code: \(parsingError.code) userInfo: \(parsingError.userInfo) description: \(parsingError.description)")
        Crashlytics.sharedInstance().recordError(crashlyticsError)
    }
}
