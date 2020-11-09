//
//  AuthApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 30/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class AuthApiClient: BaseApiClient {
    
    static func auth(url: URL, username: String, password: String, checkIp: Bool? = nil, completion:@escaping (Result<AuthResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.auth(url: url, username: username, password: password, checkIp: checkIp), completion: completion)
    }
    
    static func register(email: String, password: String, promocode: String? = nil, checkIp: Bool? = nil, newsSubscription: Int? = nil, completion:@escaping (Result<RegistrationResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.register(email: email, password: password, promocode: promocode, checkIp: checkIp, newsSubscription: newsSubscription), completion: completion)
    }
    
    static func refreshToken(url: URL, completion:@escaping (Result<AuthResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.refreshToken(url: url), completion: completion)
    }
    
    static func socialAuth(token: String, email: String? = nil, appleId: String? = nil, firstName: String? = nil, lastName: String? = nil, promocode: String? = nil, checkIp: Bool? = nil, socialType: String, completion:@escaping (Result<AuthResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.socialAuth(token: token, email: email, appleId: appleId, firstName: firstName, lastName: lastName, promocode: promocode, checkIp: checkIp, socialType: socialType), completion: completion)
    }
    
    static func attachSocialAccount(token: String, socialType: String, completion:@escaping (Result<SuccessResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.attachSocialAccount(token: token, socialType: socialType), completion: completion)
    }
    
    static func recoveryEmail(email: String, completion:@escaping (Result<SuccessResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.recoveryEmail(email: email), completion: completion)
    }
    
    static func checkEmail(email: String, completion:@escaping (Result<CheckEmailResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.checkEmail(email: email), completion: completion)
    }
    
    static func checkPromo(prmocode: String, completion:@escaping (Result<CheckPromoResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.checkPromo(prmocode: prmocode), completion: completion)
    }
    
    static func newPassword(hash: String, password: String, completion:@escaping (Result<ChangePasswordResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.newPassword(hash: hash, password: password), completion: completion)
    }
    
    static func bindSocial(socialType: SocialType ,socialToken: String, accessToken: String, completion:@escaping (Result<BindSocialResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.bindSocial(socialType: socialType, socialToken: socialToken, accessToken: accessToken), completion: completion)
    }
    
    static func ssid(url: URL? = nil, completion:@escaping (Result<SSIDResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.ssid(url: url), completion: completion)
    }
    
    static func logout(completion:@escaping (Result<SuccessResponse, Error>)->Void) {
        performRequest(router: AuthApiRouter.logout, completion: completion)
    }
    
}
