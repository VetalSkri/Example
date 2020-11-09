//
//  AuthApiRouter.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum AuthApiRouter: BaseApiRouter {
    
    case auth(url: URL, username: String, password: String, checkIp: Bool?)
    case register(email: String, password: String, promocode: String?, checkIp: Bool?, newsSubscription: Int?)
    case refreshToken(url: URL)
    case socialAuth(token: String, email: String?, appleId: String?, firstName: String?, lastName: String?, promocode: String?, checkIp: Bool?, socialType: String)
    case attachSocialAccount(token: String, socialType: String)
    case recoveryEmail(email: String)
    case checkEmail(email: String)
    case checkPromo(prmocode: String)
    case newPassword(hash: String, password: String)
    case ssid(url: URL?)
    case bindSocial(socialType: SocialType ,socialToken: String, accessToken: String)
    case logout
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .auth, .register, .refreshToken, .socialAuth, .attachSocialAccount, .recoveryEmail, .checkEmail, .checkPromo, .newPassword, .logout, .bindSocial:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .auth:
            return "/token"
        case .register:
            return "/registration/cashback"
        case .refreshToken:
            return "/token/refresh"
        case .socialAuth(_, _, _, _, _, _, _, let socialType):
            return "/auth/social/token/\(socialType)"
        case .attachSocialAccount(_, let socialType):
            return "/user/profile/social/\(socialType)"
        case .recoveryEmail:
            return "/user/profile/password/recovery/email"
        case .checkEmail:
            return "/registration/check/email"
        case .checkPromo:
            return "/registration/check/promocode"
        case .newPassword:
            return "/user/profile/password"
        case .ssid:
            return "/ssid"
        case .bindSocial(let socialType, _, _):
            var socialPartString = ""
            switch socialType {
            case .apple:
                socialPartString = "apple"
                break
            case .fb:
                socialPartString = "fb"
                break
            case .vk:
                socialPartString = "vk"
                break
            case .google:
                socialPartString = "google"
                break
            }
            return "/user/profile/social/\(socialPartString)"
        case .logout:
            return "/logout/refresh-token"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .auth(_, let username, let password, let checkIp):
            var params = [Constants.APIParameterKey.gratType : Session.shared.grant_type_password, Constants.APIParameterKey.username : username, Constants.APIParameterKey.password : password, Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let checkIp = checkIp {
                params[Constants.APIParameterKey.checkIp] = checkIp
            }
            return params
        case .register(let email, let password, let promocode, let checkIp, let newsSubscription):
            var params = [Constants.APIParameterKey.email : email, Constants.APIParameterKey.password : password, Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let promocode = promocode {
                params[Constants.APIParameterKey.promocode] = promocode
            }
            if let checkIp = checkIp {
                params[Constants.APIParameterKey.checkIp] = checkIp
            }
            if let newsSubscription = newsSubscription {
                params[Constants.APIParameterKey.newsSubscription] = newsSubscription
            }
            return params
        case .refreshToken:
            return [Constants.APIParameterKey.gratType : Session.shared.grant_type_refresh_token, Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.refreshToken : Session.shared.refresh_token ?? ""]
        case .socialAuth(let token, let email, let appleId, let firstName, let lastName, let promocode, let checkIp, _):
            var params = [Constants.APIParameterKey.socialNetworkAccessToken : token, Constants.APIParameterKey.role : Session.shared.role, Constants.APIParameterKey.clientId : Session.shared.client_id] as [String : Any]
            if let email = email {
                params[Constants.APIParameterKey.email] = email
            }
            if let checkIp = checkIp {
                params[Constants.APIParameterKey.checkIp] = checkIp
            }
            if let promocode = promocode {
                params[Constants.APIParameterKey.promocode] = promocode
            }
            if let appleId = appleId {
                 params[Constants.APIParameterKey.appleId] = appleId
             }
            if let firstName = firstName {
                 params[Constants.APIParameterKey.userFirstName] = firstName
             }
            if let lastName = lastName {
                 params[Constants.APIParameterKey.userLastName] = lastName
             }
            return params
        case .bindSocial(_, let socialToken, _):
            return [Constants.APIParameterKey.socialToken : socialToken]
        case .attachSocialAccount(let token, _):
            return [Constants.APIParameterKey.socialNetworkAccessToken : token]
        case .recoveryEmail(let email):
            return [Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.email : email]
        case .checkEmail(let email):
            return [Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.email : email]
        case .checkPromo(let promocode):
            return [Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.promocode : promocode]
        case .newPassword(let hash, let password):
            return [Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.hash : hash, Constants.APIParameterKey.password : password]
        case .ssid:
            return [Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.v : Constants.ProductionServer.apiVersion]
        case .logout:
            return [Constants.APIParameterKey.clientId : Session.shared.client_id, Constants.APIParameterKey.refreshToken : Session.shared.refresh_token ?? ""]
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
        case .auth, .register, .refreshToken, .socialAuth, .attachSocialAccount, .recoveryEmail, .checkEmail, .checkPromo, .newPassword, .logout, .bindSocial:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .auth, .register, .socialAuth, .recoveryEmail, .checkEmail, .checkPromo, .newPassword:
            var headers = defaultHeader()
            if let ssidToken = Session.shared.ssid {
                headers["X-SSID"] = ssidToken
            }
            return headers
        case .bindSocial(_, _, let accessToken):
            var headers = defaultHeader()
            headers["X-ACCESS-TOKEN"] = accessToken
            return headers
        default:
            return defaultHeader()
        }
    }
    
    var baseUrl: URL? {
        switch self {
        case .auth(let url, _, _, _):
            return url
        case .refreshToken(let url):
            return url
        case .ssid(let url):
            return url
        default:
            return nil
        }
    }
}
