//
//  CitiesResponse.swift
//  Backit
//
//  Created by Elina Batyrova on 15.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

struct CitiesResponse: Decodable {
    var result: Bool
    var data: [CitiesResponseData]?
}

struct CitiesResponseData: Decodable {
    var type: String
    var id: Int
    var attributes: CitiesResponseDataAttributes
}

struct CitiesResponseDataAttributes: Decodable {
    var name: String
}
