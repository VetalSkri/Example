//
//  NSError+Failure.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import Crashlytics

extension NSError {
    class func errorResponse(error response: Data) -> (ErrorInfo?, NSError) {
        do {
            let error = try JSONDecoder().decode(ErrorResponse.self, from: response)
            print("The response of Error is: \(String(describing: error))")
            let info = [NSLocalizedDescriptionKey: "\(String(describing: error.errors.first?.error_description))"]
            if let errorResponse = error.errors.first {
                let crashlyticsError = NSError(domain: error.errors.first!.error_description, code: errorResponse.error, userInfo: info)
                Crashlytics.sharedInstance().recordError(crashlyticsError)
                return (errorResponse, NSError(domain: String(describing: error.errors.first!.error_description), code: errorResponse.error, userInfo: info))
            } else {
              return (nil, NSError(domain: String(describing: self), code: 0, userInfo: info))
            }
        } catch {
            let info = [NSLocalizedDescriptionKey: "Can't parse response error. Report a bug"]
            let crashlyticsError = NSError(domain: String(describing: "Can't parse response error. Report a bug"), code: 0, userInfo: info)
            Crashlytics.sharedInstance().recordError(crashlyticsError)
            return (nil, NSError(domain: String(describing: "Can't parse response error. Report a bug"), code: 0, userInfo: info))
        }
    }
}
