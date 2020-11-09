//
//  LabelsResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 26/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct LabelsResponse: Decodable {
    
    var data: [LabelsDataResponse]
    var result: Bool
    
    init(data: [LabelsDataResponse], result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct LabelsDataResponse: Decodable {
    
    var type: String
    var id: Int
    var attributes: LabelsAttributesResponse
    
}

struct LabelsAttributesResponse: Decodable {
    var name: String
    var priority: Int
}

public class Labels: Equatable {
    var id: Int
    var name: String
    var priority: Int
    
    init(id: Int, _ body: LabelsAttributesResponse) {
        self.id = id
        self.name = body.name
        self.priority = body.priority
    }
    
    init(id: Int, name: String, priority: Int) {
        self.id = id
        self.name = name
        self.priority = priority
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.priority = 999         //because the server doesn't sent the label - ALL SHOPS
    }
    
    public static func == (lhs: Labels, rhs: Labels) -> Bool {
        return (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.priority == rhs.priority)
    }
    
    
}

