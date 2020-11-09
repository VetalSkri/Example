//
//  ProfileNetworkManager.swift
//  Backit
//
//  Created by Ivan Nikitin on 02/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

class ProfileNetworkManager {
    
    func loadProfile(completion: @escaping (Result<Profile,Error>)->()) {
        ProfileApiClient.profile { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.data.attributes))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func changeSubscriptionSetting(ofType: SettingItemType, toState: Bool, completion: @escaping (Result<SubscriptionState, Error>)->()){
        ProfileApiClient.subscription(type: ofType.rawValue, status: (toState) ? 1 : 0) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.request))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func saveAvatar(imageUrlString: String, completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.saveAvatar(imageUrlString: imageUrlString, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func deleteAvatar(completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.deleteAvatar(completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func bindEmail(email: String, completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.bindEmail(email: email, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.changePassword(currentPassword: currentPassword, newPassword: newPassword, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func deleteProfile(secretValue: String, completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.deleteProfile(secretValue: secretValue, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func confirmEmail(completion:@escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.confirmEmail(completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func updateGeo(countryCode: String, regionCode: String?, cityId: Int?, completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.updateGeo(countryCode: countryCode, regionCode: regionCode, cityId: cityId, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func editProfile(fullName: String?, birthday: String?, gender: String?, language: String?, profileImage: String?, onBoardWatched: String?, completion: @escaping (Result<Bool, Error>)->()) {
        ProfileApiClient.editProfile(fullName: fullName, birthday: birthday, gender: gender, language: language, profileImage: profileImage, onBoardWatched: onBoardWatched, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.data.attributes.updated))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func getSmsCode(phone: String, completion:@escaping (Result<Int, Error>)->()) {
        ProfileApiClient.getSmsCode(phone: phone, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.request.phone))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
    func confirmPhone(phone: String, code: String, completion:@escaping (Result<AttributePhoneResponse, Error>)->()) {
        ProfileApiClient.confirmPhone(phone: phone, code: code, completion: { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.data.attributes))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        })
    }
    
}
