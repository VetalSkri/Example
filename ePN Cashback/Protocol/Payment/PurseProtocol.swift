//
//  PurseProtocol.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 06/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol PurseProtocol {
    var purseType: PurseType! { get }
    
    func getMaskAndPrefix() -> MaskAndPrefix
}

extension PurseProtocol {
    
    func getMaskAndPrefix() -> MaskAndPrefix {
        switch purseType! {
        case PurseType.beeline:
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
        case .cardpay, .cardpayUsd, .cardUrkV2:
            return MaskAndPrefix(mask: "", placeholder: "", prefix: "")
        case .cardUrk:
            return MaskAndPrefix(mask: "[0000] [0000] [0000] [0000] [9999]", placeholder: "XXXX XXXX XXXX XXXX", prefix: "")
        case .wmz:
            return MaskAndPrefix(mask: "[000] [000] [000] [000]", placeholder: "XXX XXX XXX XXX", prefix: "Z")
        case .khabensky:
            return MaskAndPrefix(mask: "", placeholder: "", prefix: "")
        }
    }
    
//    func getFieldsWithPlaceholders() -> [FieldsForRecipentData] {
//        switch purseType {
//        case .cardpay:
//            return [FieldsForRecipentData(type: )]
//        default:
//            return FieldsForRecipentData(placeholder: [""])
//        }
//    }
}
