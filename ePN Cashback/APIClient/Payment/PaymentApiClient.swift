//
//  PaymentApiClient.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 09/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class PaymentApiClient: BaseApiClient {
    
    static func getPaymentInfo(completion:@escaping (Result<PaymentInfo, Error>)->Void) {
        performRequest(router: PaymentApiRouter.userPaymentInfo, completion: completion)
    }
    
    static func paymentOrder(currency: String, purseId: Int, amount: Double, completion:@escaping (Result<PaymentOrder, Error>)->Void) {
        performRequest(router: PaymentApiRouter.paymentOrder(currency: currency, purseId: purseId, amount: amount), completion: completion)
    }
    
    static func createCharityPurse(charityId: Int, completion:@escaping (Result<CreatedCharityPurse, Error>)->Void) {
        performRequest(router: PaymentApiRouter.createCharityPurse(charityId: charityId), completion: completion)
    }
    
    static func createPurse(purseType: String, purseValue: String?, purseDicdt: Dictionary<String, Any>?, completion:@escaping (Result<CreatedUserPurse, Error>)->Void) {
        performRequest(router: PaymentApiRouter.createPurse(purseType: purseType, purseValue: purseValue, purseDict: purseDicdt), completion: completion)
    }
    
    static func confirmPurse(purseId: Int, code: String, completion:@escaping (Result<ConfirmPurse, Error>)->Void) {
        performRequest(router: PaymentApiRouter.confirmPurse(purseId: purseId, code: code), completion: completion)
    }
    
    static func getUserPurses(completion:@escaping (Result<UserPurse, Error>)->Void) {
        performRequest(router: PaymentApiRouter.getUserPurses, completion: completion)
    }
    
    static func removeUserPurse(purseId: String, completion:@escaping (Result<UserPurseRemove, Error>)->Void) {
        performRequest(router: PaymentApiRouter.removeUserPurse(purseId: purseId), completion: completion)
    }
    
    static func ballance(completion:@escaping (Result<BalanceResponse, Error>)->Void) {
        performRequest(router: PaymentApiRouter.ballance, completion: completion)
    }
    
    static func sendCode(purseId: String, completion:@escaping (Result<PaymentSendCode, Error>)->Void) {
        performRequest(router: PaymentApiRouter.sendCode(purseId: purseId), completion: completion)
    }
    
    static func history(page: Int, perPage: Int, completion:@escaping (Result<PaymentsResponse, Error>)->Void) {
        performRequest(router: PaymentApiRouter.histoty(page: page, perPage: perPage), completion: completion)
    }
    
    static func getCountries(completion: @escaping ((Result<SearchGeoResponse, Error>) -> Void)) {
        performRequest(router: PaymentApiRouter.getCountries, completion: completion)
    }
    
    static func getCities(search: String, countryCode: String, completion: @escaping ((Result<SearchGeoResponse, Error>) -> Void)) {
        performRequest(router: PaymentApiRouter.getCities(search: search, countryCode: countryCode), completion: completion)
    }
}
