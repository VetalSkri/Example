//
//  SaveAvatarResponse.swift
//  Backit
//
//  Created by Александр Кузьмин on 03/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct SaveAvatarResponse : Decodable {
    var data: SaveAvatarResponseData
    var result: Bool
}

public struct SaveAvatarResponseData: Decodable {
    var attributes: SaveAvatarResponseAttributes
}

struct SaveAvatarResponseAttributes: Decodable {
    var link: String
}
