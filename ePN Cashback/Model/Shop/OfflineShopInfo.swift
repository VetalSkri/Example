//
//  OfflineShopInfo.swift
//  Backit
//
//  Created by Ivan Nikitin on 16/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct OfflineShopInfoContainer: Decodable {
    var data: OfflineShopInfoData
}

public struct OfflineShopInfoData: Decodable {
    var attributes: OfflineShopInfo
    
}

public struct OfflineShopInfo: Decodable {
    var title: String
    var currency: [String]?
    var image: String
    var tag: String
    var description: String
    var ratesDesc: String?
    var rates: [OfflineShopInfoRates]?
    var confirmTime: String
    var offlineCbImage: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case currency
        case image
        case tag
        case description
        case ratesDesc
        case rates
        case confirmTime
        case offlineCbImage
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode([String]?.self, forKey: .currency)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.rates = try container.decode([OfflineShopInfoRates]?.self, forKey: .rates)
        self.ratesDesc = try container.decode(String?.self, forKey: .ratesDesc)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.title = try container.decode(String.self, forKey: .title)
        if container.contains(.offlineCbImage) {
            self.offlineCbImage = try container.decode(String?.self, forKey: .offlineCbImage)
        }
        if container.contains(.confirmTime) {
            do {
                self.confirmTime = try container.decode(String?.self, forKey: .confirmTime) ?? ""
            } catch {
                self.confirmTime = String(try container.decode(Int.self, forKey: .confirmTime))
            }
        } else {
            self.confirmTime = ""
        }
    }
    
}

public struct OfflineShopInfoRates: Decodable {
    var description: String
    var newRate: String
}
