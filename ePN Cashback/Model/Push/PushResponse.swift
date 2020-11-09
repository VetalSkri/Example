//
//  PushResponse.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct PushResponse: Decodable {
    var data: PushResponseData
    var result: Bool
}

public struct PushResponseData: Decodable {
    var type: String
}

