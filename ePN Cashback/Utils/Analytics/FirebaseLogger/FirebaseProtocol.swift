//
//  FirebaseProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 13.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import Firebase

protocol FirebaseProtocol { }

extension FirebaseProtocol {
    
    static func reportToFirebase(params: [String: Any], eventName: String) {
        FirebaseAnalytics.Analytics.logEvent(eventName, parameters: params)
    }
}
