//
//  LocalSymbolsAndAbbreviations.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 24/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

final class LocalSymbolsAndAbbreviations {
    
    static let ACCOUNT_MENU_COUNT = 7
    static let KEY_ALREDY_LAYNCH_APP = "key_alredy_launch_app"
    static let KEY_USER_PROFILE = "key_user_profile"
    static let KEY_USERNAME = "key_user_name"
    static let KEY_EMAIL = "key_user_email"
    static let KEY_EMAIL_IS_CONFIRMED = "key_user_email_is_confirmed"
    static let KEY_FULLNAME = "key_user_full_name"
    static let KEY_PHONE = "key_user_phone"
    static let KEY_PHONE_IS_CONFIRMED = "key_user_phone_is_confirmed"
    static let KEY_BIRTHDAY = "key_user_birthday"
    static let KEY_GENDER = "key_user_gender"
    static let KEY_LANGUAGE = "key_user_language"
    static let KEY_IS_PASSWORD_SET = "key_user_is_password_set"
    static let KEY_GEO_COUNTRY_CODE = "key_user_geo_country_code"
    static let KEY_GEO_REGION_CODE = "key_user_geo_region_code"
    static let KEY_GEO_CITY_ID = "key_user_geo_city_id"
    static let KEY_GEO_COUNTRY_NAME = "key_user_geo_country_name"
    static let KEY_GEO_REGION_NAME = "key_user_geo_region_name"
    static let KEY_GEO_CITY_NAME = "key_user_geo_city_name"
    static let KEY_PROFILEIMAGE = "key_user_profile_image"
    static let KEY_SETTING_SYSTEM = "key_setting_system"
    static let KEY_SETTING_NEWS = "key_setting_news"
    static let KEY_SETTING_ORDERS = "key_setting_orders"
    //Need refactor - uiimage not shuld contains in to dictionary
    static let purseLogos = ["wmr": UIImage(named: "webMoneySmall")!,
                             "qiwi": UIImage(named: "qiwiSmall")!,
                             "yandex_money": UIImage(named: "yandexMoneySmall")!,
                             "Maestro": UIImage(named: "maestroSmall")!,
                             "mts": UIImage(named: "mtsSmall")!,
                             "beeline": UIImage(named: "beelineSmall")!,
                             "megafon": UIImage(named: "megafonSmall")!,
                             "tele2": UIImage(named: "tele2Small")!,
                             "epayments": UIImage(named: "epaymentsSmall")!,
                             "paypal_usd": UIImage(named: "payPalSmall")!,
                             "card_ukr": UIImage(named: "master_card_visa_ukraine_small")!,
                             "wmz_cardpay": UIImage(named: "webMoneySmall")!,
                             "wmz": UIImage(named: "webMoneySmall")!,
                             "Mir": UIImage(named: "mirSmall")!,
                             "MasterCard": UIImage(named: "masterCardSmall")!,
                             "mc_usd": UIImage(named: "masterCardSmall")!,
                             "mc_rub": UIImage(named: "masterCardSmall")!,
                             "Visa": UIImage(named: "visaSmall")!,
                             "visa_usd": UIImage(named: "visaSmall")!,
                             "visa_rub": UIImage(named: "visaSmall")!,
                             "paypal": UIImage(named: "payPalSmall")!,
                             "paypal_rub": UIImage(named: "payPalSmall")!]
    static let KEY_APP_HAS_BEEN_UPDATED = "key_app_has_been_updated"
    
    static let MULTY_OFFER_ID = 1627
    static let LOTTERY_OFFER_ID = 1713
    
    class func getPurseChooseLogo(forType: PurseType) -> String {
        switch forType {
        case .wmr:
            return "webMoneyChoosePurse"
        case .qiwi:
            return "qiwiChoosePurse"
        case .yandexMoney:
            return "yandexmoneyChoosePurse"
        case .mts:
            return "mtsChoosePurse"
        case .beeline:
            return "beelineChoosePurse"
        case .megafon:
            return "megafonChoosePurse"
        case .tele2:
            return "tele2ChoosePurse"
        case .epayments:
            return "epaymentsChoosePurse"
        case .paypalUsd:
            return "paypalChoosePurse"
        case .cardUrk:
            return "mastercardVisaPurse"
        case .wmz:
            return "webMoneyChoosePurse"
        case .cardpay:
            return "mastercardVisaPurse"
        case .cardpayUsd:
            return "mastercardVisaPurse"
        case .cardUrkV2:
            return "mastercardVisaPurse"
        case .khabensky:
            return ""
        }
    }
    
    class func getPurseChooseSmalllogo(forType: PurseType) -> String {
        switch forType {
        case .wmr:
            return "webMoneySmall"
        case .qiwi:
            return "qiwiSmallNew"
        case .yandexMoney:
            return "yandexMoneySmallNew"
        case .mts:
            return "mtsSmallNew"
        case .beeline:
            return "beelineSmallNew"
        case .megafon:
            return "megafonSmallNew"
        case .tele2:
            return "tele2ChoosePurse"
        case .epayments:
            return "epaymentsChoosePurse"
        case .paypalUsd:
            return "paypalChoosePurse"
        case .cardUrk:
            return "mastercardVisaPurse"
        case .wmz:
            return "webMoneySmallNew"
        case .cardpay:
            return "mastercardVisaPurse"
        case .cardpayUsd:
            return "mastercardVisaSmall"
        case .cardUrkV2:
            return "mastercardVisaSmall"
        case .khabensky:
            return "khabenskyChooseSmall"
        }
    }
    
    class func getSymbolOfCurrency(value: String) -> String {
        let currency = ["USD": "$", "RUB": "₽", "GBP": "£", "EUR": "€"]
        return currency[value] ?? ""
    }
    
    class func getNameOfCurrency(value: String) -> String {
        let currency = ["USD": NSLocalizedString("Dollars", comment: ""), "RUB": NSLocalizedString("Rubles", comment: ""), "GBP": NSLocalizedString("Pounds", comment: ""), "EUR": NSLocalizedString("Euro", comment: "")]
        return currency[value] ?? ""
    }
    
    class func getElectedIdCategoryOfShops() -> Int {
        return 1
    }
    
    class func getOrderStatus(fromStatus status: String) -> String {
        switch status {
        case "completed":
            return "completed"
        case "rejected":
            return "rejected"
        default:
            return "hold"
        }
    }
    
    class func getPaymentStatus(fromStatus status: String) -> String {
        switch status {
        case "success":
            return "success"
        case "rejected":
            return "rejected"
        default:
            return "hold"
        }
    }
    
    class func getPurseLogoBy(title: String) -> UIImage {
        if let image = purseLogos[title] {
            return image
        } else {
            return UIImage(named: "defaultSmallPurse")!
        }
    }
}
