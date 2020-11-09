//
//  CategoriesResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 08/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct CategoriesResponse: Decodable {
    
    var data: [CategoriesDataResponse]
    var result: Bool
    
    init(data: [CategoriesDataResponse], result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct CategoriesDataResponse: Decodable {
    
    var type: String
    var id: String
    var attributes: CategoriesTree
    
}

public struct CategoriesTree : Decodable {
    var tree : [Categories]
}

public class Categories: Codable {
    var id: Int
    var name: String
    var tree: [Categories]?
    
    init(id: Int, name: String, tree: [Categories]?) {
        self.id = id
        self.name = name
        self.tree = tree
    }
}

extension Categories: Equatable {
    public static func == (lhs: Categories, rhs: Categories) -> Bool {
        return (lhs.id == rhs.id) && (lhs.name == rhs.name)
    }
}
