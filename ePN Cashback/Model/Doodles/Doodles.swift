//
//  Doodles.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 15/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public enum DoodlesTypes: Int {
    case onlineOffer = 1
    case offlineOffer = 3
}

public struct Doodles: Decodable {
    var data: [DoodlesData]?
    var result: Bool
}

struct DoodlesData: Decodable {
    var type: String
    var id: Int
    var attributes: DoodlesItem
}

public struct DoodlesItem: Decodable {
    var id: Int?
    var name: String
    var dateTo: Date?
    var dateFrom: Date?
    var offerLogo: String?
    var backgroundImage: String?
    var backgroundColor: String?
    var image: String?
    var priority: Int
    var status: String?
    var title: String?
    var subTitle: String?
    var textButton: String?
    var link: String?
    var offerID: Int?
    var offerTypeID: Int?
    var goToStore: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case dateTo
        case dateFrom
        case offerLogo
        case backgroundImage
        case backgroundColor
        case image
        case priority
        case status
        case title
        case subTitle
        case textButton
        case link
        case translate
        case offerId
        case offerTypeId
        case goToStore
    }
    
    public init (from decoder: Decoder) throws{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let dateToString = try container.decode(String?.self, forKey: .dateTo)
        self.dateTo = dateToString != nil ? dateFormatter.date(from: dateToString!) : nil
        let dateFromString = try container.decode(String?.self, forKey: .dateFrom)
        self.dateFrom = dateFromString != nil ? dateFormatter.date(from: dateFromString!) : nil
        self.offerLogo = try container.decode(String?.self, forKey: .offerLogo)
        self.backgroundImage = try container.decode(String?.self, forKey: .backgroundImage)
        self.backgroundColor = try container.decode(String?.self, forKey: .backgroundColor)
        self.image = try container.decode(String?.self, forKey: .image)
        self.priority = try container.decode(Int.self, forKey: .priority)
        self.status = try container.decode(String?.self, forKey: .status)
        self.goToStore = try container.decode(Bool.self, forKey: .goToStore)
        
        if let offerID = try? container.decode(Int.self, forKey: .offerId) {
            self.offerID = offerID
        } else {
            self.offerID = nil
        }
        
        if let offerTypeID = try? container.decode(Int.self, forKey: .offerTypeId) {
            self.offerTypeID = offerTypeID
        } else {
            self.offerTypeID = nil
        }
        
        if container.contains(.translate) {
            let translate = try container.decode(DoodlesTranslate.self, forKey: .translate)
            if let translateObj = translate.obj {
                self.title = translateObj.title
                self.subTitle = translateObj.subTitle
                self.textButton = translateObj.textButton
                self.link = translateObj.link
            }
        }
    }
    
    public init(id: Int?, name: String, dateTo: Date?, dateFrom: Date?, offerLogo: String?, backgroundImage: String?, backgroundColor: String?, image: String?, priority: Int, status: String?, title: String?, subTitle: String?, textButton: String?, link: String?, offerID: Int, offerTypeID: Int, goToStore: Bool) {
        self.id = id
        self.name = name
        self.dateTo = dateTo
        self.dateFrom = dateFrom
        self.offerLogo = offerLogo
        self.backgroundImage = backgroundImage
        self.backgroundColor = backgroundColor
        self.image = image
        self.priority = priority
        self.status = status
        self.title = title
        self.subTitle = subTitle
        self.textButton = textButton
        self.link = link
        self.offerID = offerID
        self.offerTypeID = offerTypeID
        self.goToStore = goToStore
    }
}

struct DoodlesTranslate: Decodable {
    var obj: DoodlesTranslateObj?
    
    enum CodingKeys: String, CodingKey {
        case ru = "ru", en = "en"
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.ru) {
            obj = try container.decode(DoodlesTranslateObj.self, forKey: .ru)
        } else if container.contains(.en) {
            obj = try container.decode(DoodlesTranslateObj.self, forKey: .en)
        }
    }
    
}

struct DoodlesTranslateObj: Decodable {
    var title: String
    var subTitle: String?
    var textButton: String?
    var link: String?
}
