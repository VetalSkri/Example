//
//  MutyOfferResponse.swift
//  Backit
//
//  Created by Ivan Nikitin on 08/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct MultyOfferResponse: Codable {
    var id: String
    var type: String
    var offers: [MultyOfferData]
    
}

public struct MultyOfferData: Codable, Hashable {
    var id: String
    var type: String
    
    public static func ==(lhs: MultyOfferData, rhs: MultyOfferData) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
}

public class OfferOffline {
    var id: Int
    var priority: Int
    var image: String?
    var tag: String?
    var url: String?
    var title: String
    var typeId: Int
    var description: String?
    var type: Int
    
    init(id: Int, title: String, description: String?, priority: Int, image: String?, tag: String?, url: String?, typeId: Int, type: Int) {
        self.id = id
        self.priority = priority
        self.image = image
        self.tag = tag
        self.url = url
        self.title = title
        self.typeId = typeId
        self.description = description
        self.type = type
    }
}
