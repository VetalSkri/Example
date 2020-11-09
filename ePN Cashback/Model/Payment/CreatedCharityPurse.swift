//
//  CharityPurse.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct CreatedCharityPurse: Decodable {
    var data: CreatedCharityPurseData
    var result: Bool
}

struct CreatedCharityPurseData: Decodable {
    var type: String
    var id: String
    var attributes: CharityPurseAttributes
}

struct CharityPurseAttributes: Decodable {
    var status: Int
    var purse: CharityPurseAttributesObject
}

struct CharityPurseAttributesObject: Decodable {
    var type: String
    var purse: String
    var addedDate: Date?
    var isConfirm: Bool
    var isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case type
        case purse
        case addedDate = "added_datetime"
        case isConfirm = "is_confirmed"
        case isDefault = "is_default"
    }
    
    init (from decoder: Decoder) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.purse = try container.decode(String.self, forKey: .purse)
        let dateString = try container.decode(String?.self, forKey: .addedDate)
        self.addedDate = dateString != nil ? dateFormatter.date(from: dateString!) : nil
        self.isConfirm = try container.decode(Bool.self, forKey: .isConfirm)
        self.isDefault = try container.decode(Bool.self, forKey: .isDefault)
    }
}
