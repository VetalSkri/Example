//
//  CheckResultOfflineCBResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 24/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct CheckResultOfflineCBResponse: Codable {
    var status: String
    var type: String
    var msg: String
}

public enum TypeOfStatusOfflineCheck: String {
    case none, on_duplicate, on_duplicate_2, on_limited, on_invalid, on_incompat_1, on_incompat_2, off //on_ok, 
}
