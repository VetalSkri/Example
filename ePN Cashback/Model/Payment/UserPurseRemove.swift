//
//  UserPurseRemove.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct UserPurseRemove: Decodable {
    var data: UserPurseRemoveData
    var result: Bool
}

struct UserPurseRemoveData: Decodable {
    var type: String
    var id: Int
}
