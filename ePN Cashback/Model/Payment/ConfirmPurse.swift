//
//  ConfirmPurse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct ConfirmPurse: Decodable {
    var data: ConfirmPurseData
}

struct ConfirmPurseData: Decodable {
    var type: String
    var id: Int
    var attributes: ConfirmPurseAttributes
}

struct ConfirmPurseAttributes: Decodable {
    var dbResponse: Bool
}
