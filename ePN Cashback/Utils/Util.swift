//
//  Util.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 22/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

public enum ShopTypeId: Int {
    case common = 1
    case ref = 2
    case offlineMulty = 3
    case offlineSingle = 4
}

final class Util {
    
//    public static let shopsURL = "cashback://Main/shops"
    public static let signInURL = "cashback://SignIn/main"
    public static let message = "cashback://MessageHistory/main"
    public static let landingURL = "https://start.backit.me/"
    public static let refLink = "https://backit.me/cashback"
    public static let offlineCBLink = "https://offline-cashback.bz"
    public static let offlineAppLink = "https://offline-app.epn.bz"
//    public static let signUpURL = "cashback://SignUp/main"
//    public static let faqWMURL = "cashback://FAQ/wmInfo"
    
    public static let TIME_OF_UPDATING: TimeInterval = 3600 //one hour
    public static let TIME_OF_UPDATING_FAVORITE: TimeInterval = 120 //two minutes
    public static let TIME_OF_UPDATING_RECEIPT: TimeInterval = 600 //10 minutes
    public static let TIME_OF_UPDATING_FAQ: TimeInterval = 604800 //one week
    public static let TIME_OF_UPDATING_CATEGORY: TimeInterval = 604800 //one weak
    public static let TIME_OF_UPDATING_STORE_CATEGORY: TimeInterval = 86400 //one day
    public static let TIME_OF_UPDATING_PROMOCODE: TimeInterval = 86400 //one day
    public static let TIME_OF_UPDATING_PAYMENT: TimeInterval = 86400 //one day
    public static let MAX_SIZE_OF_SHOPS_FROM_SERVER = 1000
    public static let MAX_SIZE_OF_SHOPS_TO_PRESENT = 5
    public static let SIZE_OF_PAGING = 20
    public static let ID_LABEL_ALL_SHOPS = -1
    public static let HASH = "hash"
    public static let lock = NSLock()
   
    class func goToSiteTransactions() {
        let epn_urls = Bundle.main.object(forInfoDictionaryKey: "EPN_URLS") as! [String: String]
        guard let urlString = epn_urls["TRANSACTIONS_SEARCH_URL"] else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    class func parseUrlParameters(from url: URL) -> [String: String]? {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParams = [String: String]()
        guard let queryItems = urlComponents?.queryItems else { return nil }
        for queryItem: URLQueryItem in queryItems {
            if queryItem.value == nil {
                continue
            }
            queryParams[queryItem.name] = queryItem.value
        }
        return queryParams
    }
    
    class func convertDateForSort(_ dateTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" //31.10.2018
        let date = dateFormatter.date(from: dateTime)
        dateFormatter.dateFormat = "yyyy-MM-dd" //2018-10-18
        return dateFormatter.string(from: date!)
    }
    
    class func convertDataForDynamic(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    class func convertLongFormatDateForSort(_ dateTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //31.10.2018
        let date = dateFormatter.date(from: dateTime)
        dateFormatter.dateFormat = "yyyy-MM-dd" //2018-10-18
        return dateFormatter.string(from: date!)
    }
    
    class func convertDateToShortString(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    class func convertToPresentDate(_ fromDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" //31.10.2018
        let date = dateFormatter.date(from: fromDate)
        dateFormatter.dateFormat = "d MMMM" //2018-10-18 19:34:20
        return Calendar.current.isDateInToday(date!) ? NSLocalizedString("Today", comment: "") : dateFormatter.string(from: date!)
    }
    
    class func serverToLocal(dateString:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString)
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    class func convertToPresentLongFormatDate(_ fromDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //31.10.2018
        let date = dateFormatter.date(from: fromDate)
        dateFormatter.dateFormat = "d MMMM" //2018-10-18 19:34:20
        return Calendar.current.isDateInToday(date!) ? NSLocalizedString("Today", comment: "") : dateFormatter.string(from: date!)
    }
    
    static func performOpenURL(stringURL: String) {
        let url = URL(string: stringURL)!
        if UIApplication.shared.canOpenURL(url) {
            print("can open url \(stringURL)")
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    static var fetchAllBalance: [BalanceDataResponse]? {
        guard let objects = UserDefaults.standard.value(forKey: "userBalance") as? Data else { return nil }
        let decoder = JSONDecoder()
        guard let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [BalanceDataResponse] else {return nil }
        return objectsDecoded
    }
    
    static func saveBalance(allBalance: [BalanceDataResponse]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allBalance){
            UserDefaults.standard.set(encoded, forKey: "userBalance")
        }
    }
    
    static private func deleteBalanceData() {
        UserDefaults.standard.removeObject(forKey: "userBalance")
    }
    
    static var isCardsPursesHint: Bool {
        get {
            guard let isCardsPursesHint = UserDefaults.standard.value(forKey: "isCardsPursesHint") as? Bool else {
                return false
            }
            return isCardsPursesHint
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isCardsPursesHint")
        }
    }
    
    static var isUkrainV2PurseHint: Bool {
        get {
            guard let isUkrainV2PurseHint = UserDefaults.standard.value(forKey: "isUkrainV2PurseHint") as? Bool else {
                return false
            }
            return isUkrainV2PurseHint
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isUkrainV2PurseHint")
        }
    }

    
    static func fetchProfile() -> Profile? {
        if let profileData = UserDefaults.standard.data(forKey: LocalSymbolsAndAbbreviations.KEY_USER_PROFILE) {
            return NSKeyedUnarchiver.unarchiveObject(with: profileData) as? Profile
        }
        return nil
    }
    
    static func saveProfileData(profile: Profile) {
        let archivedProfileData = NSKeyedArchiver.archivedData(withRootObject: profile)
        UserDefaults.standard.set(archivedProfileData, forKey: LocalSymbolsAndAbbreviations.KEY_USER_PROFILE)
//        UserDefaults.standard.set(profile.userName, forKey: LocalSymbolsAndAbbreviations.KEY_USERNAME)
//        UserDefaults.standard.set(profile.email, forKey: LocalSymbolsAndAbbreviations.KEY_EMAIL)
//        UserDefaults.standard.set(profile.isConfirmed ?? false, forKey: LocalSymbolsAndAbbreviations.KEY_EMAIL_IS_CONFIRMED)
//        UserDefaults.standard.set(profile.fullName, forKey: LocalSymbolsAndAbbreviations.KEY_FULLNAME)
//        UserDefaults.standard.set(profile.profileImage, forKey: LocalSymbolsAndAbbreviations.KEY_PROFILEIMAGE)
//        UserDefaults.standard.set(profile.subscriptions.news, forKey: LocalSymbolsAndAbbreviations.KEY_SETTING_NEWS)
//        UserDefaults.standard.set(profile.subscriptions.orders, forKey: LocalSymbolsAndAbbreviations.KEY_SETTING_ORDERS)
//        UserDefaults.standard.set(profile.subscriptions.system, forKey: LocalSymbolsAndAbbreviations.KEY_SETTING_SYSTEM)
//        UserDefaults.standard.set(profile.phone, forKey: LocalSymbolsAndAbbreviations.KEY_PHONE)
//        UserDefaults.standard.set(profile.phoneConfirmed, forKey: LocalSymbolsAndAbbreviations.KEY_PHONE_IS_CONFIRMED)
//        UserDefaults.standard.set(profile.birthday, forKey: LocalSymbolsAndAbbreviations.KEY_BIRTHDAY)
//        UserDefaults.standard.set(profile.gender, forKey: LocalSymbolsAndAbbreviations.KEY_GENDER)
//        UserDefaults.standard.set(profile.language, forKey: LocalSymbolsAndAbbreviations.KEY_LANGUAGE)
//        UserDefaults.standard.set(profile.isPasswordSet, forKey: LocalSymbolsAndAbbreviations.KEY_IS_PASSWORD_SET)
//        UserDefaults.standard.set(profile.geo.country_code, forKey: LocalSymbolsAndAbbreviations.KEY_GEO_COUNTRY_CODE)
//        UserDefaults.standard.set(profile.geo.region_code, forKey: LocalSymbolsAndAbbreviations.KEY_GEO_REGION_CODE)
//        UserDefaults.standard.set(profile.geo.city_id, forKey: LocalSymbolsAndAbbreviations.KEY_GEO_CITY_ID)
//        UserDefaults.standard.set(profile.geo.country_name, forKey: LocalSymbolsAndAbbreviations.KEY_GEO_COUNTRY_NAME)
//        UserDefaults.standard.set(profile.geo.region_name, forKey: LocalSymbolsAndAbbreviations.KEY_GEO_REGION_NAME)
//        UserDefaults.standard.set(profile.geo.city_name, forKey: LocalSymbolsAndAbbreviations.KEY_GEO_CITY_NAME)
    }
    
    static private func deleteProfileData() {
        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_USER_PROFILE)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_USERNAME)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_EMAIL)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_EMAIL_IS_CONFIRMED)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_FULLNAME)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_PROFILEIMAGE)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_SETTING_NEWS)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_SETTING_ORDERS)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_SETTING_SYSTEM)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_PHONE)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_PHONE_IS_CONFIRMED)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_BIRTHDAY)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GENDER)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_LANGUAGE)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_IS_PASSWORD_SET)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GEO_COUNTRY_CODE)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GEO_REGION_CODE)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GEO_CITY_ID)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GEO_COUNTRY_NAME)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GEO_REGION_NAME)
//        UserDefaults.standard.removeObject(forKey: LocalSymbolsAndAbbreviations.KEY_GEO_CITY_NAME)
    }
    
    static private func deleteFullSessionData() {
        PushApiClient.deleteToken { (_) in }
        UserDefaults.standard.removeObject(forKey: "emailOfCashBack")
        UserDefaults.standard.removeObject(forKey: "passwordOfCashBack")
        UserDefaults.standard.removeObject(forKey: "isAuth")
        UserDefaults.standard.removeObject(forKey: "fcmPushRegistrationToken")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
    }
    
    static func deleteCurrentSessionData() {
        UserDefaults.standard.removeObject(forKey: "passwordOfCashBack")
        UserDefaults.standard.removeObject(forKey: "isAuth")
        UserDefaults.standard.removeObject(forKey: "fcmPushRegistrationToken")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
    }
    
    static private func resetTimeOfLivePersonalTables() {
        UserDefaults.standard.removeObject(forKey: "tableShops")
        UserDefaults.standard.removeObject(forKey: "favoriteShops")
        UserDefaults.standard.removeObject(forKey: "paymentCacheLifetime")
        UserDefaults.standard.removeObject(forKey: "promocodeCacheLifetime")
    }
    
    static func getOfflineFaqShown() -> Bool {
        return UserDefaults.standard.bool(forKey: "offlineFaqAlredyShown")
    }
    
    static func setShownOfflineFaq() {
        UserDefaults.standard.set(true, forKey: "offlineFaqAlredyShown")
    }
    
    static func getSpecialOfflineFaqShown() -> Bool {
        return UserDefaults.standard.bool(forKey: "specialOfflineFaqAlredyShown")
    }
    
    static func setSpecialShownOfflineFaq() {
        UserDefaults.standard.set(true, forKey: "specialOfflineFaqAlredyShown")
    }
    
    static func saveFcmToken(token: String) {
        UserDefaults.standard.set(token, forKey: "fcmPushRegistrationToken")
    }
    
    static func getFcmToken() -> String? {
        return UserDefaults.standard.string(forKey: "fcmPushRegistrationToken")
    }
    
    static func getDeviceId() -> String {
        if let storagedDeviceId = UserDefaults.standard.string(forKey: "deviceId") {
            return storagedDeviceId
        } else {
            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
                UserDefaults.standard.set(deviceId, forKey: "deviceId")
                return deviceId
            } else {
                print("MYLOG: ERROR!!!!!!! Cannot get device ID in Utils getDeviceId method!!!!!!! Show this method!")
                return ""
            }
        }
    }
    
    static func deletePersonalData() {
        deleteProfileData()
        deleteBalanceData()
        resetTimeOfLivePersonalTables()
        CoreDataStorageContext.shared.deleteAllPersonalDataFromCoreData()
    }
    
    static func languageOfContent() -> String {
        let supportedLanguageCodes = ["en","ru"]
        let languageCode = Locale.current.languageCode ?? "en"
        let currentLanguageCode = supportedLanguageCodes.contains(languageCode) ? languageCode : "en"
        return currentLanguageCode
    }
    
    static func checkStringIsEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: string)
    }
    
    static func checkStringIsPhone(string: String) -> Bool {
        let phoneRegEx = "^\\+[0-9]{11}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: string)
    }
    
    static func checkStringIsEpaymentsId(string: String) -> Bool {
        let phoneRegEx = "^00[0-9]-[0-9]{6}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: string)
    }
    
    static func verifyPersonalData(email: String, password: String) {
        let previousUserLogin = Session.shared.user_login
        if previousUserLogin != "" && !previousUserLogin.elementsEqual(email) {
            deletePersonalData()
        }
        Session.shared.user_login = email
        Session.shared.user_password = password
        Session.shared.isAuth = true
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
