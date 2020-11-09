//
//  TicketParam.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 03/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct TicketParam : Codable {
    
    var offerId: Int?
    var offerTitle: String?
    var refLink: String?
    var refLogin: String?
    var orderDate: String?
    var orderNumber: String?
    var orderLink: String?
    var appPlatform: String? = "ios"
    var appVersion: String?
    
    enum CodingKeys: String, CodingKey {
        case offerId
        case offerTitle
        case refLink
        case refLogin
        case orderDate
        case orderNumber
        case orderLink
        case appPlatform
        case appVersion
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let offerId = offerId {
            try container.encode(offerId, forKey: .offerId)
        }
        if let offerTitle = offerTitle {
            try container.encode(offerTitle, forKey: .offerTitle)
        }
        if let refLink = refLink {
            try container.encode(refLink, forKey: .refLink)
        }
        if let refLogin = refLogin {
            try container.encode(refLogin, forKey: .refLogin)
        }
        if let orderDate = orderDate {
            try container.encode(orderDate, forKey: .orderDate)
        }
        if let orderNumber = orderNumber {
            try container.encode(orderNumber, forKey: .orderNumber)
        }
        if let orderLink = orderLink {
            try container.encode(orderLink, forKey: .orderLink)
        }
        if let appPlatform = appPlatform {
            try container.encode(appPlatform, forKey: .appPlatform)
        }
        if let appVersion = appVersion {
            try container.encode(appVersion, forKey: .appVersion)
        }
    }
    
    func toDictionary() -> [String: Any] {
        var resultDict: [String: Any] = [:]
        if let offerId = offerId {
            resultDict[CodingKeys.offerId.rawValue] = offerId
        }
        if let offerTitle = offerTitle {
            resultDict[CodingKeys.offerTitle.rawValue] = offerTitle
        }
        if let refLink = refLink {
            resultDict[CodingKeys.refLink.rawValue] = refLink
        }
        if let refLogin = refLogin {
            resultDict[CodingKeys.refLogin.rawValue] = refLogin
        }
        if let orderDate = orderDate {
            resultDict[CodingKeys.orderDate.rawValue] = orderDate
        }
        if let orderNumber = orderNumber {
            resultDict[CodingKeys.orderNumber.rawValue] = orderNumber
        }
        if let orderLink = orderLink {
            resultDict[CodingKeys.orderLink.rawValue] = orderLink
        }
        if let appPlatform = appPlatform {
            resultDict[CodingKeys.appPlatform.rawValue] = appPlatform
        }
        if let appVersion = appVersion {
            resultDict[CodingKeys.appVersion.rawValue] = appVersion
        }
        return resultDict
    }
    
}
