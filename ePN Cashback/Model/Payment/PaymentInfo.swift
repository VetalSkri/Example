//
//  PaymentInfo.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 09/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public enum PurseType: String {
    case wmr = "wmr"
    case qiwi = "qiwi"
    case yandexMoney = "yandex_money"
    case mts = "mts"
    case beeline = "beeline"
    case megafon = "megafon"
    case tele2 = "tele2"
    case epayments = "epayments"
    case paypalUsd = "paypal_usd"
    case cardpay = "cardpay"
    case cardpayUsd = "capitalist_card_usd"
    case cardUrk = "card_ukr_capitalist"
    case cardUrkV2 = "capitalist_card_uah"
    case wmz = "wmz_cardpay"
    case khabensky = "charityKhabensky"
    
    func getMaskAndPrefix() -> MaskAndPrefix {
        switch self {
        case .beeline:
            return MaskAndPrefix(mask: "([000]) [000]-[00]-[00]", placeholder: "(XXX) XXX-XX-XX" , prefix: "+7 ")
        case .wmr:
            return MaskAndPrefix(mask: "[000] [000] [000] [000]", placeholder: "XXX XXX XXX XXX", prefix: "R")
        case .qiwi:
            return MaskAndPrefix(mask: "[00000000000999999999]", placeholder: "XXXXXXXXXXX", prefix: "+")
        case .yandexMoney:
            return MaskAndPrefix(mask: "[0000] [0000] [9999]", placeholder: "XXXX XXXX", prefix: "4100 ")
        case .mts:
            return MaskAndPrefix(mask: "([000]) [000]-[00]-[00]", placeholder: "(XXX) XXX-XX-XX" , prefix: "+7 ")
        case .megafon:
            return MaskAndPrefix(mask: "([000]) [000]-[00]-[00]", placeholder: "(XXX) XXX-XX-XX" , prefix: "+7 ")
        case .tele2:
            return MaskAndPrefix(mask: "([000]) [000]-[00]-[00]", placeholder: "(XXX) XXX-XX-XX" , prefix: "+7 ")
        case .epayments:
            return MaskAndPrefix(mask: "", placeholder: NSLocalizedString("ePID, phone number or email", comment: ""), prefix: "")
        case .paypalUsd:
            return MaskAndPrefix(mask: "[___-----------------]", placeholder: "", prefix: "https://paypal.me/")
        case .cardpay, .cardpayUsd, .cardUrk, .cardUrkV2:
            return MaskAndPrefix(mask: "[0000]{-}[0000]{-}[0000]{-}[0000]{-}[000]", placeholder: "XXXX-XXXX-XXXX-XXXX", prefix: "")
        case .wmz:
            return MaskAndPrefix(mask: "Z[000000000000]", placeholder: "Z000000000000", prefix: "Z")
        case .khabensky:
            return MaskAndPrefix(mask: "", placeholder: "", prefix: "")
        }
    }
}

public struct PaymentInfo : Decodable {
    var data: [PaymentInfoData]
}

public struct PaymentInfoData: Decodable {
    var type: String
    var id: String
    var attributes: PaymentInfoAttributes
    var purseType: PurseType?
    var hintView: Bool = false
    var hintInfo: PurseHint? = nil
    
    enum CodingKeys: String, CodingKey {
        case type, id, attributes
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.id = try container.decode(String.self, forKey: .id)
        self.attributes = try container.decode(PaymentInfoAttributes.self, forKey: .attributes)
        self.purseType = PurseType(rawValue: self.id)
    }
    
    public init (type: String, id: String, purseType: PurseType){
        self.type = type
        self.id = id
        self.purseType = purseType
        self.attributes = PaymentInfoAttributes(name: "", isAllowedForMobile: true, info: nil)
    }
}

public struct PaymentInfoAttributes: Decodable {
    var name: String
    var isAllowedForMobile: Bool
    var info: [PaymentInfoAttributesInfo]?
}

struct PaymentInfoAttributesInfo: Decodable {
    var commissionPercent: Float?
    var commissionFix: Float?
    var currency: String
    var min: Double
    
    enum CodingKeys: String, CodingKey {
        case commissionPercent
        case commissionFix
        case currency
        case min
    }
    
    init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.commissionPercent = try container.decode(Float?.self, forKey: .commissionPercent)
        } catch {   }
        do {
            self.commissionFix = try container.decode(Float?.self, forKey: .commissionFix)
        } catch {   }
        self.currency = try container.decode(String.self, forKey: .currency)
        self.min = try container.decode(Double.self, forKey: .min)
    }
}

public struct PurseHint {
    var title: String
    var text: String
}
