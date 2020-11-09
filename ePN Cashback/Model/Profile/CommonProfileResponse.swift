//
//  AvatarResponse.swift
//  Backit
//
//  Created by Ivan Nikitin on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct CommonProfileResponse : Decodable {
    
    var result: Bool
    
}

public struct ChangeProfileResponse: Decodable {
    var data: DataChangeProfile
}

struct DataChangeProfile: Decodable {
    var attributes: AttributeChangeProfile
}

public struct AttributeChangeProfile: Decodable {
    var updated: Bool
}
