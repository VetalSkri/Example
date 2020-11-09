//
//  CategoryOffersResponse.swift
//  Backit
//
//  Created by Ivan Nikitin on 18/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct CategoryOffersResponse: Decodable {
    
    var data:  FailableCodableArray<CategoryOffersDataResponse>?
    var result: Bool
    
    init(data: FailableCodableArray<CategoryOffersDataResponse>?, result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct CategoryOffersDataResponse: Codable {
    
    var type: String
    var id: Int
    var attributes: OffersCategoryIds
    
}

struct OffersCategoryIds: Codable {
    var categoryIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case categoryIds
    }
    
    init (categoryIds: [Int]?) {
        self.categoryIds = categoryIds
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryIds = try container.decode([Int]?.self, forKey: .categoryIds)
    }
}

public class StoreCategoryIds {
    
    var id: Int
    var categoryIds: [Int]?
    
    init(id: Int, categoryIds: [Int]?) {
        self.id = id
        self.categoryIds = categoryIds
    }
}
