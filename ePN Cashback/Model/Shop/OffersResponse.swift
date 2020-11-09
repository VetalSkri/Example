//
//  OffersResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 08/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

struct OffersResponse: Decodable {
    
    var data:  FailableCodableArray<OffersDataResponse>?
    var result: Bool
    
    init(data: FailableCodableArray<OffersDataResponse>?, result: Bool) {
        self.data = data
        self.result = result
    }
    
}

public struct OffersDataResponse: Codable {
    
    var type: String
    var id: Int
    var attributes: Offer

}

struct Offer: Codable {
    var name: String
    var title: String
    var tag: String
    var image: String        //"https://epn.bz/uploads/2017-09-12/ow64i2d5be00k3qitpt0sl5rhhs9vduu.png",
    var logo: String
    var logo_small: String?
    var labelIds: [Int]?
    var maxRate: String?     //"90%",
    var maxRatePretext: String?
    var priority: Int
    var url: String?
    var type_id: Int
    var offlineCbImage: String?
    var offlineCbImageDescription: String?
    var link_default: String?
    
    
    enum CodingKeys: String, CodingKey {
        case name, title, tag, image,logo, logo_small = "logoSmall", labelIds, maxRate, maxRatePretext, priority, type_id = "typeId", offlineCbImage, offlineCbImageDescription, link_default = "linkDefault", url
    }
    
    init (name: String, title: String, tag: String, image: String, logo: String, logo_small: String?, maxRate: String?, maxRatePretext: String?, priority: Int, typeId: Int, offlineCbImage: String?, offlineCbDescription: String?, linkDefault: String?, url: String?) {
        self.name = name
        self.title = title
        self.tag = tag
        self.image = image
        self.logo = logo
        self.logo_small = logo_small
        self.maxRate = maxRate
        self.maxRatePretext = maxRatePretext
        self.priority = priority
        self.type_id = typeId
        self.link_default = linkDefault
        self.offlineCbImage = offlineCbImage
        self.offlineCbImageDescription = offlineCbDescription
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        title = try container.decode(String.self, forKey: .title)
        tag = try container.decode(String.self, forKey: .tag)
        image = try container.decode(String.self, forKey: .image)
        logo = try container.decode(String.self, forKey: .logo)
        logo_small = container.contains(.logo_small) ?  try container.decode(String.self, forKey: .logo_small) : nil
        labelIds = try container.decode([Int]?.self, forKey: .labelIds)
        if let value = try? container.decode(Int.self, forKey: .maxRate) {
            maxRate = String(value)
        } else {
            maxRate = try container.decode(String.self, forKey: .maxRate)
        }
        maxRatePretext = try container.decode(String.self, forKey: .maxRatePretext)
        priority = try container.decode(Int.self, forKey: .priority)
        type_id = try container.decode(Int.self, forKey: .type_id)
        offlineCbImage = try container.decode(String?.self, forKey: .offlineCbImage)
        offlineCbImageDescription = try container.decode(String?.self, forKey: .offlineCbImageDescription)
        link_default = try container.decode(String?.self, forKey: .link_default)
        url = try container.decode(String?.self, forKey: .url)
    }
}

class Store: Equatable {
    
    var id: Int
    var store: Offer
    var isFavorite: Bool
    
    init(id: Int, offer: Offer, isFavorite: Bool = false) {
        self.id = id
        self.store = offer
        self.isFavorite = isFavorite
    }
    
    init(id: Int, name: String, title: String, tag: String, image: String, logo: String, logo_s: String?, priority: Int, maxRate: String?, maxRatePretext: String?,typeId: Int, offlineCbImage: String?, offlineCbDescription: String?, linkDefault: String?, url: String?, isFavorite: Bool = false) {
        self.id = id
        self.isFavorite = isFavorite
        self.store = Offer(name: name, title: title, tag: tag, image: image, logo: logo, logo_small: logo_s, maxRate: maxRate, maxRatePretext: maxRatePretext,priority: priority, typeId: typeId, offlineCbImage: offlineCbImage, offlineCbDescription: offlineCbDescription, linkDefault: linkDefault, url: url)
    }
    
    static func == (lhs: Store, rhs: Store) -> Bool {
        return (lhs.id == rhs.id) && (lhs.isFavorite == rhs.isFavorite)
    }
    
}

