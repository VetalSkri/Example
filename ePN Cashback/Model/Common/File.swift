//
//  File.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 03/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct File : Codable {
    
    var name: String
    var size: Float
    var link: String
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case size
        case link
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(size, forKey: .size)
        try container.encode(link, forKey: .link)
    }
    
    func toDictionary() -> [String: Any] {
        var resultDict: [String: Any] = [:]
        resultDict[CodingKeys.name.rawValue] = name
        resultDict[CodingKeys.size.rawValue] = size
        resultDict[CodingKeys.link.rawValue] = link
        return resultDict
    }
}
