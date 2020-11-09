//
//  PaymentApiRouter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 09/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum PaymentApiRouter: BaseApiRouter {

    case userPaymentInfo
    case paymentOrder(currency: String, purseId: Int, amount: Double)
    case createCharityPurse(charityId: Int)
    case createPurse(purseType: String, purseValue: String?, purseDict: Dictionary<String, Any>?)
    case confirmPurse(purseId: Int, code: String)
    case getUserPurses
    case removeUserPurse(purseId: String)
    case ballance
    case sendCode(purseId: String)
    case histoty(page: Int, perPage: Int)
    case getCountries
    case getCities(search: String?,countryCode: String)
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .paymentOrder:
            return .post
        case .createCharityPurse:
            return .post
        case .createPurse:
            return .post
        case .confirmPurse:
            return .post
        case .removeUserPurse:
            return .delete
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .userPaymentInfo:
            return "/user/payment/init"
        case .paymentOrder:
            return "/user/payment/order"
        case .createCharityPurse:
            return "/user/purses/add-charity"
        case .createPurse:
            return "/user/purses"
        case .confirmPurse:
            return "/user/purses/confirm"
        case .getUserPurses:
            return "/user/purses/list"
        case .removeUserPurse(let purseId):
            return "/user/purses/\(purseId)"
        case .ballance:
            return "/purses/balance"
        case .sendCode:
            return "/purses/sendCode"
        case .histoty:
            return "/user/payments"
        case .getCountries:
            return "/geo/countries"
        case .getCities(let search,let countryCode):
            return "/geo/countries/\(countryCode)/cities"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .paymentOrder(let currency, let purseId, let amount):
            return [Constants.APIParameterKey.currency : currency, Constants.APIParameterKey.purseId : purseId, Constants.APIParameterKey.amount : amount]
        case .createCharityPurse(let charityId):
            return [Constants.APIParameterKey.charityId : charityId]
        case .createPurse(let purseType, let purseValue, let purseDict):
            if let purseValue = purseValue {
                return [Constants.APIParameterKey.purseType : purseType, Constants.APIParameterKey.purseValue : purseValue]
            } else {
                return [Constants.APIParameterKey.purseType : purseType, Constants.APIParameterKey.purseValue : purseDict]
            }
        case .confirmPurse(let purseId, let code):
            return [Constants.APIParameterKey.purseId : purseId, Constants.APIParameterKey.code : code]
        case .sendCode(let purseId):
            return [Constants.APIParameterKey.purseId : purseId]
        case .histoty(let page, let perPage):
            return [Constants.APIParameterKey.page : page, Constants.APIParameterKey.perPage : perPage]
        default:
            return nil
        }
    }
    
    internal var timeout: TimeInterval {
        switch self {
        case .sendCode:
            return 5
        default:
            return 10
        }
    }
    
    internal var queryType: Query {
        switch self {
        case .paymentOrder:
            return .json
        case .createCharityPurse:
            return .json
        case .createPurse:
            return .json
        case .confirmPurse:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        return defaultHeader()
    }
    
    var baseUrl: URL? {
        return nil
    }
    
}
