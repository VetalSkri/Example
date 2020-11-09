//
//  ProfileApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum ProfileApiRouter: BaseApiRouter {
    
    case profile(clientId: String)
    case subscription(type: String, status: Int)
    case saveAvatar(imageUrlString: String)
    case deleteAvatar
    case bindEmail(email: String)
    case changePassword(currentPassword: String, newPassword: String)
    case deleteProfile(secretValue: String)
    case confirmEmail
    case updateGeo(countryCode: String, regionCode: String?, cityId: Int?)
    case editProfile(fullName: String?, birthday: String?, gender: String?, language: String?, profileImage: String?, onBoardWatched: String?)
    case confirmPhone(phone: String, code: String)
    case confirmOldPhone(phone: String, code: String, access: AccessToCurrentNumber)
    case getSmsCode(phone: String)
    case unlinkSocial(_ social: ProfileSocial)
    case linkSocial(_ social: ProfileSocial, socialToken: String)
    case countries
    case regions(countryCode: String)
    case cities(countryCode: String, regionCode: String?)
    case change(currentNumber: String, newNumber: String, access: AccessToCurrentNumber)
    case sendEmail
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .profile, .getSmsCode, .countries, .regions, .cities, .change:
            return .get
        case .subscription, .saveAvatar:
            return .put
        case .deleteAvatar, .deleteProfile:
            return .delete
        case .bindEmail, .changePassword, .confirmEmail, .updateGeo, .confirmPhone, .confirmOldPhone, .sendEmail:
            return .post
        case .editProfile:
            return .patch
        case .unlinkSocial:
            return .delete
        case .linkSocial:
            return .post
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .profile, .deleteProfile:
            return "/user/profile"
        case .subscription:
            return "/user/profile/subscriptions"
        case .saveAvatar, .deleteAvatar:
            return "/user/profile/avatar"
        case .bindEmail:
            return "/user/profile/email/bind"
        case .changePassword:
            return "/user/profile/change-password"
        case .confirmEmail:
            return "/user/profile/confirmEmail"
        case .updateGeo:
            return "/user/profile/geo"
        case .editProfile:
            return "/user/profile/edit"
        case .confirmPhone:
            return "/user/profile/phone/bind/confirm"
        case .getSmsCode:
            return "/user/profile/phone/bind/code"
        case .unlinkSocial(let social):
            switch social {
            case .facebook:
                return "/user/profile/social/fb"
            case .vk:
                return "/user/profile/social/vk"
            case .google:
                return "/user/profile/social/google"
            }
        case .linkSocial(let social, _):
            switch social {
            case .facebook:
                return "/user/profile/social/fb"
            case .vk:
                return "/user/profile/social/vk"
            case .google:
                return "/user/profile/social/google"
            }
        case .countries:
            return "/geo/countries"
        case .regions(let countryCode):
            return "/geo/countries/\(countryCode)/regions"
        case .cities(let countryCode, let regionCode):
            if let regionCode = regionCode {
                return "/geo/countries/\(countryCode)/regions/\(regionCode)/cities"
            } else {
                return "/geo/countries/\(countryCode)/cities"
            }
        case .change:
            return "/user/profile/phone/change/code"
        case .confirmOldPhone:
            return "/user/profile/phone/change/confirm"
        case .sendEmail:
            return "/user/profile/phone/change/send-email"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .profile(let clientId):
            return [Constants.APIParameterKey.clientId : clientId]
        case .subscription(let type,let status):
            return [Constants.APIParameterKey.type : type, Constants.APIParameterKey.status : status]
        case .saveAvatar(let imageUrlString):
            return [Constants.APIParameterKey.avatarURL: imageUrlString]
        case .bindEmail(let email):
            return [Constants.APIParameterKey.email: email]
        case .changePassword(let currentPassword, let newPassword):
            return [Constants.APIParameterKey.currentPassword: currentPassword, Constants.APIParameterKey.newPassword: newPassword, Constants.APIParameterKey.confirmNewPassword: newPassword]
        case .deleteProfile(let secretValue):
            return [Constants.APIParameterKey.confirmValue: secretValue]
        case .updateGeo(let countryCode, let regionCode, let cityId):
            var parameters: [String: Any] = [Constants.APIParameterKey.countryCode: countryCode]
            if let regionCode = regionCode {
                parameters[Constants.APIParameterKey.regionCode] = regionCode
            }
            if let cityID = cityId {
                parameters[Constants.APIParameterKey.cityId] = cityID
            }
            return parameters
        case .editProfile(let fullName, let birthday, let gender, let language, let profileImage, let onBoardWatched):
            var params: Parameters = [:]
            if let fullName = fullName {
                params[Constants.APIParameterKey.fullName] = fullName
            }
            if let birthday = birthday {
                params[Constants.APIParameterKey.birthday] = birthday
            }
            if let gender = gender {
                params[Constants.APIParameterKey.gender] = gender
            }
            if let language = language {
                params[Constants.APIParameterKey.language] = language
            }
            if let profileImage = profileImage {
                params[Constants.APIParameterKey.profileImage] = profileImage
            }
            if let onBoardWatched = onBoardWatched {
                params[Constants.APIParameterKey.onBoardWatched] = onBoardWatched
            }
            return params
        case .confirmPhone(let phone, let code):
            return [Constants.APIParameterKey.code: code, Constants.APIParameterKey.phone: phone]
        case .getSmsCode(let phone):
            return [Constants.APIParameterKey.phone: phone]
        case .linkSocial(_, let socialToken):
            return [Constants.APIParameterKey.socialNetworkAccessToken: socialToken]
        case .change(let currentNumber, let newNumber, let access):
            let accessToOldPhone = (access == .yesAccess) ? 1 : 0
            return [Constants.APIParameterKey.phone: newNumber,
                    Constants.APIParameterKey.currentPhone: currentNumber,
                    Constants.APIParameterKey.accessToOldPhone: accessToOldPhone]
        case .confirmOldPhone(let phone, let code, let access):
            let accessToOldPhone = (access == .yesAccess) ? 1 : 0
            return [Constants.APIParameterKey.code: code,
                    Constants.APIParameterKey.phone: phone,
                    Constants.APIParameterKey.accessToOldPhone: accessToOldPhone]
        default:
            return nil
        }
    }
    
    internal var timeout: TimeInterval {
        switch self {
        default:
            return 10
        }
    }
    
    internal var queryType: Query {
        switch self {
        case .subscription, .saveAvatar, .bindEmail, .changePassword, .deleteProfile, .updateGeo, .editProfile, .confirmPhone, .linkSocial, .confirmOldPhone:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        return nil
    }
}
