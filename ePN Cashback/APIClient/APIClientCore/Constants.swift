//
//  Constants.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct Constants {
    struct ProductionServer {
        static var baseURL: String {
            get {
                let devInstance = Session.shared.dev_instance
                if devInstance?.count ?? 0 > 0 {
                    return "https://app-\(devInstance ?? "").epndev.bz"
                }
                return (Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! [String: String])["BASE_URL_APP"]!
            }
        }
        
        static var oauthURL: String {
            get {
                let devInstance = Session.shared.dev_instance
                if devInstance?.count ?? 0 > 0 {
                    return "https://oauth2-\(devInstance ?? "").epndev.bz"
                }
                return (Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! [String: String])["BASE_URL_OAUTH"]!
            }
        }
        
        static var apiVersion: String {
            get {
                return Bundle.main.object(forInfoDictionaryKey: "BASE_API_VERSION") as! String
            }
        }
    }
    
    struct ResponseCode {
        static let invalidSSID = 400017
        static let invalidRefreshToken = 401002
        static let emailAlredyExist = 400016
        static let somethingWentWrong = 4864
        static let captcha = 429001
    }
    
    struct APIParameterKey {
        static let search = "search"
        static let page = "page"
        static let pageCount = "page_count"
        static let perPage = "perPage"
        static let per_Page = "per_page"
        static let ticketStatus = "ticket_status"
        static let currency = "currency"
        static let purseId = "purseId"
        static let amount = "amount"
        static let charityId = "charityId"
        static let purseType = "purseType"
        static let purseValue = "purseValue"
        static let code = "code"
        static let image = "image"
        static let filter = "filter"
        static let limit = "limit"
        static let offset = "offset"
        static let sort = "sort"
        static let categories = "categories"
        static let fields = "fields"
        static let offerId = "offerId"
        static let offer_id = "offer_id"
        static let productId = "productId"
        static let account = "account"
        static let cardholderName = "cardholder_name"
        static let expMonth = "exp_month"
        static let expYear = "exp_year"
        static let status = "status"
        static let clientId = "client_id"
        static let type = "type"
        static let subject = "subject"
        static let message = "message"
        static let replyToId = "reply_to_id"
        static let files = "files"
        static let ticketParams = "ticket_params"
        static let tsFrom = "tsFrom"
        static let tsTo = "tsTo"
        static let offerIds = "offerIds"
        static let confirmTsFrom = "confirmTsFrom"
        static let confirmTsTo = "confirmTsTo"
        static let orderNumber = "orderNumber"
        static let order = "order"
        static let sortType = "sortType"
        static let filterFrom = "filterFrom"
        static let filterTo = "filterTo"
        static let filterGoods = "filterGoods"
        static let filterOffers = "filterOffers"
        static let link = "link"
        static let ids = "ids"
        static let material = "material"
        static let urlTo = "urlTo"
        static let lang = "lang"
        static let categoryIds = "categoryIds"
        static let viewRules = "viewRules"
        static let labelIds = "labelIds"
        static let typeId = "typeId"
        static let typeIds = "typeIds"
        static let token = "token"
        static let deviceId = "deviceId"
        static let period = "period"
        static let gratType = "grant_type"
        static let username = "username"
        static let password = "password"
        static let checkIp = "check_ip"
        static let email = "email"
        static let promocode = "promocode"
        static let appleId = "apple_id"
        static let userLastName = "user_last_name"
        static let userFirstName = "user_first_name"
        static let newsSubscription = "news_subscription"
        static let refreshToken = "refresh_token"
        static let socialNetworkAccessToken = "social_network_access_token"
        static let role = "role"
        static let hash = "hash"
        static let v = "v"
        static let urlContainer = "urlContainer"
        static let captchaPhraseKey = "captcha_phrase_key"
        static let captcha = "captcha"
        static let socialToken = "social_network_access_token"
        static let visibility = "visibility"
        static let topic_id = "topic_id"
        static let avatarURL = "url"
        static let currentPassword = "current_password"
        static let newPassword = "new_password"
        static let confirmNewPassword = "confirm_new_password"
        static let confirmValue = "confirm_value"
        static let countryCode = "country_code"
        static let regionCode = "region_code"
        static let cityId = "city_id"
        static let fullName = "fullname"
        static let birthday = "birthday"
        static let gender = "gender"
        static let language = "language"
        static let profileImage = "profile_image"
        static let onBoardWatched = "onBoardWatched"
        static let phone = "phone"
        static let currentPhone = "current_phone"
        static let accessToOldPhone = "has_access_to_old_phone"
        static let containingOffers = "containingOffers"
        static let rating = "rating"
        static let description = "description"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case accessToken = "X-ACCESS-TOKEN"
}

enum ContentType: String {
    case json = "application/json"
}

public enum Query {
    case json, path
}

public typealias HTTPHeaders = [String: String]
