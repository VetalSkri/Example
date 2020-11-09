//
//  RegionResponse.swift
//  Backit
//
//  Created by Elina Batyrova on 15.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

struct RegionResponse: Decodable {
    var result: Bool
    var data: [RegionsResponseData]?
}

struct RegionsResponseData: Decodable {
    var type: String
    var attributes: RegionsResponseDataAttributes
}

struct RegionsResponseDataAttributes: Decodable {
    var code: String
    var name: String
}
