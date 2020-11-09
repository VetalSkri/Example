//
//  FavoritesResponse.swift
//  Backit
//
//  Created by Ivan Nikitin on 14/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct FavoritesResponse: Decodable {
    
    var data: [FavoritesDataResponse]
    var result: Bool
    
    init(data: [FavoritesDataResponse], result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct FavoritesDataResponse: Decodable {
    
    var type: String
    var id: Int
}

