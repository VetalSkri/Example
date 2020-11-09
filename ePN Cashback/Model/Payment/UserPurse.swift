//
//  UserPurse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct UserPurse: Decodable {
    var data: [UserPurseData]?
    var result: Bool
}

public struct UserPurseData: Decodable {
    var type: String
    var id: Int
    var attributes: UserPurseObject
}
