//
//  ProfileApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 27/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class ProfileApiClient: BaseApiClient {

    static func profile(completion:@escaping (Result<ProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.profile(clientId: Session.shared.client_id), completion: completion)
    }
    
    static func subscription(type: String, status: Int, completion:@escaping (Result<SubscriptionResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.subscription(type: type, status: status), completion: completion)
    }
    
    static func saveAvatar(imageUrlString: String, completion:@escaping (Result<SaveAvatarResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.saveAvatar(imageUrlString: imageUrlString), completion: completion)
    }
    
    static func deleteAvatar(completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.deleteAvatar, completion: completion)
    }
    
    static func bindEmail(email: String, completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.bindEmail(email: email), completion: completion)
    }
    
    static func changePassword(currentPassword: String, newPassword: String, completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.changePassword(currentPassword: currentPassword, newPassword: newPassword), completion: completion)
    }
    
    static func deleteProfile(secretValue: String, completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.deleteProfile(secretValue: secretValue), completion: completion)
    }
    
    static func confirmEmail(completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.confirmEmail, completion: completion)
    }
    
    static func updateGeo(countryCode: String, regionCode: String?, cityId: Int?, completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.updateGeo(countryCode: countryCode, regionCode: regionCode, cityId: cityId), completion: completion)
    }
    
    static func getCountries(completion: @escaping (Result<SearchGeoResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.countries, completion: completion)
    }
    
    static func getCities(countryCode: String, regionCode: String?, completion: @escaping (Result<CitiesResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.cities(countryCode: countryCode, regionCode: regionCode), completion: completion)
    }
    
    static func getRegions(countryCode: String, completion: @escaping (Result<RegionResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.regions(countryCode: countryCode), completion: completion)
    }
    
    static func editProfile(fullName: String?, birthday: String?, gender: String?, language: String?, profileImage: String?, onBoardWatched: String?, completion:@escaping (Result<ChangeProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.editProfile(fullName: fullName, birthday: birthday, gender: gender, language: language, profileImage: profileImage, onBoardWatched: onBoardWatched), completion: completion)
    }
    
    static func getSmsCode(phone: String, completion:@escaping (Result<PhoneCodeResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.getSmsCode(phone: phone), completion: completion)
    }
    
    static func editPhoneGetSmsCode(currentPhone: String, newPhone: String, access: AccessToCurrentNumber, completion: @escaping (Result<PhoneCodeResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.change(currentNumber: currentPhone, newNumber: newPhone, access: access), completion: completion)
    }
    
    static func confirmPhone(phone: String, code: String, completion:@escaping (Result<PhoneResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.confirmPhone(phone: phone, code: code), completion: completion)
    }
    
    static func confirmOldPhone(phone: String, code: String, access: AccessToCurrentNumber, completion: @escaping (Result<PhoneResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.confirmOldPhone(phone: phone, code: code, access: access), completion: completion)
    }
    
    static func sendEmail(completion: @escaping (Result<CommonProfileResponse, Error>) -> Void) {
        performRequest(router: ProfileApiRouter.sendEmail, completion: completion)
    }
    
    static func unlinkSocial(social: ProfileSocial, completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.unlinkSocial(social), completion: completion)
    }
    
    static func linkSocial(social: ProfileSocial, socialToken: String, completion:@escaping (Result<CommonProfileResponse, Error>)->Void) {
        performRequest(router: ProfileApiRouter.linkSocial(social, socialToken: socialToken), completion: completion)
    }
}
