//
//  ProfileResponse.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

public struct ProfileResponse: Decodable {
    
    var data: ProfileDataResponse
    var result: Bool
    
    init(data: ProfileDataResponse, result: Bool) {
        self.data = data
        self.result = result
    }
    
}

struct ProfileDataResponse: Decodable {
    var type: String
    var id: Int
    var attributes: Profile
}

class Profile:NSObject, Decodable, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(self.email, forKey: CodingKeys.email.rawValue)
        coder.encode(self.isConfirmed, forKey: CodingKeys.isConfirmed.rawValue)
        coder.encode(self.userName, forKey: CodingKeys.userName.rawValue)
        coder.encode(self.fullName, forKey: CodingKeys.fullName.rawValue)
        coder.encode(self.profileImage, forKey: CodingKeys.profileImage.rawValue)
        coder.encode(self.lastLoginAt, forKey: CodingKeys.lastLoginAt.rawValue)
        coder.encode(self.firstLogin, forKey: CodingKeys.firstLogin.rawValue)
        coder.encode(self.subscriptions.news, forKey: "subscriptionNews")
        coder.encode(self.subscriptions.orders, forKey: "subscriptionOrders")
        coder.encode(self.subscriptions.system, forKey: "subscriptionSystem")
        coder.encode(self.phone, forKey: CodingKeys.phone.rawValue)
        coder.encode(self.phoneConfirmed, forKey: CodingKeys.phoneConfirmed.rawValue)
        coder.encode(self.birthday, forKey: CodingKeys.birthday.rawValue)
        coder.encode(self.gender, forKey: CodingKeys.gender.rawValue)
        coder.encode(self.language, forKey: CodingKeys.language.rawValue)
        coder.encode(self.isPasswordSet, forKey: CodingKeys.isPasswordSet.rawValue)
        coder.encode(self.geo.city_id, forKey: "geo_cityId")
        coder.encode(self.geo.city_name, forKey: "geo_cityName")
        coder.encode(self.geo.country_code, forKey: "geo_countryCode")
        coder.encode(self.geo.country_name, forKey: "geo_countryName")
//        coder.encode(self.geo.region_code, forKey: "geo_regionCode")
        coder.encode(self.geo.region_name, forKey: "geo_regionName")
        coder.encode(self.socialNetworks, forKey: CodingKeys.socialNetworks.rawValue)
    }
    
    required init?(coder: NSCoder) {
        self.email = coder.decodeObject(forKey: CodingKeys.email.rawValue) as? String ?? ""
        self.isConfirmed = coder.decodeObject(forKey: CodingKeys.isConfirmed.rawValue) as! Bool?
        self.userName = coder.decodeObject(forKey: CodingKeys.userName.rawValue) as? String ?? ""
        self.fullName = coder.decodeObject(forKey: CodingKeys.fullName.rawValue) as? String ?? ""
        self.profileImage = coder.decodeObject(forKey: CodingKeys.profileImage.rawValue) as? String ?? ""
        self.lastLoginAt = coder.decodeObject(forKey: CodingKeys.lastLoginAt.rawValue) as? String ?? ""
        self.firstLogin = coder.decodeBool(forKey: CodingKeys.firstLogin.rawValue)
        let subNews = coder.decodeBool(forKey: "subscriptionNews")
        let subOrders = coder.decodeBool(forKey: "subscriptionOrders")
        let subSystem = coder.decodeBool(forKey: "subscriptionSystem")
        self.subscriptions = Subscription(system: subSystem, news: subNews, orders: subOrders)
        self.phone = coder.decodeObject(forKey: CodingKeys.phone.rawValue) as? String ?? ""
        self.phoneConfirmed = coder.decodeObject(forKey: CodingKeys.phoneConfirmed.rawValue) as? String ?? ""
        self.birthday = coder.decodeObject(forKey: CodingKeys.birthday.rawValue) as? String ?? ""
        self.gender = coder.decodeObject(forKey: CodingKeys.gender.rawValue) as? String ?? ""
        self.language = coder.decodeObject(forKey: CodingKeys.language.rawValue) as? String ?? ""
        self.isPasswordSet = coder.decodeBool(forKey: CodingKeys.isPasswordSet.rawValue)
        let cityId = coder.decodeInteger(forKey: "geo_cityId")
        let cityName = coder.decodeObject(forKey: "geo_cityName") as? String ?? ""
        let countryCode = coder.decodeObject(forKey: "geo_countryCode") as? String ?? ""
        let countyName = coder.decodeObject(forKey: "geo_countryName") as? String ?? ""
//        let regionCode = coder.decodeObject(forKey: "geo_regionCode") as? String ?? ""
        let regionName = coder.decodeObject(forKey: "geo_regionName") as? String ?? ""
        self.geo = Geo(country_name: countyName, country_code: countryCode, region_name: regionName,
//                       region_code: regionCode,
                       city_name: cityName, city_id: cityId)
        self.socialNetworks = coder.decodeObject(forKey: CodingKeys.socialNetworks.rawValue) as? [String]? ?? []
    }
    
    var email: String
    var isConfirmed: Bool?
    var userName: String
    var fullName: String
    var profileImage: String
    var lastLoginAt: String
    var firstLogin: Bool
    var subscriptions : Subscription
    var phone: String
    var phoneConfirmed: String
    var birthday: String
    var gender: String
    var language: String
    var isPasswordSet: Bool
    var geo: Geo
    var socialNetworks: [String]?
    
    var phoneConfirmationState: PhoneConfirmationState {
        switch phoneConfirmed {
        case "waiting":
            return .waiting
            
        case "confirmed":
            return .confirmedByEmail
            
        case "confirmed_by_sms":
            return .confirmedBySMS
            
        case "refused":
            return .refused
            
        default:
            return .unknown
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case email, isConfirmed, userName, fullName, profileImage, lastLoginAt, firstLogin, subscriptions, phone, phoneConfirmed, birthday, gender, language, isPasswordSet, geo, socialNetworks
    }
    
    required public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.profileImage = try container.decode(String.self, forKey: .profileImage)
        self.lastLoginAt = try container.decode(String.self, forKey: .lastLoginAt)
        self.firstLogin = try container.decode(Bool.self, forKey: .firstLogin)
        self.subscriptions = try container.decode(Subscription.self, forKey: .subscriptions)
        if container.contains(.isConfirmed) {
            isConfirmed = try container.decode(Int.self, forKey: .isConfirmed) == 1 ? true : false
        } else {
            isConfirmed = false
        }
        self.phone = try container.decode(String.self, forKey: .phone)
        self.phoneConfirmed = try container.decode(String.self, forKey: .phoneConfirmed)
        self.birthday = try container.decode(String.self, forKey: .birthday)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.language = try container.decode(String.self, forKey: .language)
        self.isPasswordSet = try container.decode(Bool.self, forKey: .isPasswordSet)
        self.geo = try container.decode(Geo.self, forKey: .geo)
        self.socialNetworks = try container.decode([String]?.self, forKey: .socialNetworks)
    }
    
    public init(email: String, isConfirmed: Bool?, userName: String, fullName: String, profileImage: String, lastLoginAt: String, firstLogin: Bool, subscriptions : Subscription, phone: String, phoneConfirmed: String, birthday: String, gender: String, language: String, isPasswordSet: Bool, geo: Geo, socialNetworks: [String]?) {
        self.email = email
        self.userName = userName
        self.fullName = fullName
        self.profileImage = profileImage
        self.lastLoginAt = lastLoginAt
        self.firstLogin = firstLogin
        self.subscriptions = subscriptions
        self.isConfirmed = isConfirmed
        self.phone = phone
        self.phoneConfirmed = phoneConfirmed
        self.birthday = birthday
        self.gender = gender
        self.language = language
        self.isPasswordSet = isPasswordSet
        self.geo = geo
        self.socialNetworks = socialNetworks
    }
}

public struct Subscription : Decodable {
    var system : Bool
    var news : Bool
    var orders : Bool
}

public struct Geo: Decodable {
    var country_name: String
    var country_code: String
    var region_name: String
//    var region_code: String
    var city_name: String
    var city_id: Int
}

enum ProfileSocial: String {
    case vk = "vk"
    case facebook = "fb"
    case google = "google"
}

enum PhoneConfirmationState {
    case waiting
    case refused
    case confirmedByEmail
    case confirmedBySMS
    case unknown
}
