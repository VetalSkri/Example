//
//  ShopInfo.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 19/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct ShopInfoContainer: Decodable {
    var data: ShopInfoData
}

public struct ShopInfoData: Decodable {
    var attributes: ShopInfo
}

public struct ShopInfo: Decodable {
    var action: ShopInfoAction?
    var banner: ShopInfoBanner?
//    var status: String
    var name: String
//    var typeId: Int
    var currency: [String]?
    var linkDefault: String
    var logoSmall: String
    var image: String
    var title: String
    var rates: [ShopInfoRates]?
    var confirmTime: String
//    var confirmTimeInDays: Int
    var description: String
    var ratesDesc: String?
    
    
    enum CodingKeys: String, CodingKey {
        case action
        case banner
//        case status
        case name
//        case typeId
        case currency
        case linkDefault
        case logoSmall
        case image
        case title
        case rates
        case ratesDesc
        case confirmTime
//        case confirmTimeInDays
        case description
    }
    
    public init (from decoder: Decoder) throws {
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.action = try container.decode(ShopInfoAction?.self, forKey: .action)
        do {
            self.confirmTime = try container.decode(String.self, forKey: .confirmTime)
        } catch {
            self.confirmTime = String(try container.decode(Int.self, forKey: .confirmTime))
        }
//        self.confirmTimeInDays = try container.decode(Int.self, forKey: .confirmTimeInDays)
        self.currency = try container.decode([String]?.self, forKey: .currency)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.linkDefault = try container.decode(String.self, forKey: .linkDefault)
        self.logoSmall = try container.decode(String.self, forKey: .logoSmall)
        self.name = try container.decode(String.self, forKey: .name)
        self.rates = try container.decode([ShopInfoRates]?.self, forKey: .rates)
        self.ratesDesc = try container.decode(String?.self, forKey: .ratesDesc)
//        self.status = try container.decode(String.self, forKey: .status)
        self.title = try container.decode(String.self, forKey: .title)
//        self.typeId = try container.decode(Int.self, forKey: .typeId)
        self.banner = try container.decode(ShopInfoBanner?.self, forKey: .banner)
    }
    
}

public struct ShopInfoAction: Decodable {
    var description: String
}

public struct ShopInfoRates: Decodable {
    var description: String
    var newRate: String
    var oldRate: String?
    var newRateColor: String
}

public struct ShopInfoBanner: Decodable {
    var image: String
    var background: String
    var shopLogo: String
    var title: String
    var subtitle: String
    
    enum CodingKeys: String, CodingKey {
        case image
        case background
        case title
        case subtitle
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.background = try container.decode(String.self, forKey: .background)
        self.shopLogo = ""
        self.title = "Тестовый захардкоженный заголовок"
        self.subtitle = "Тестовое захардкоженное описание"
    }
}

