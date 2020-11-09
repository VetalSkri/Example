//
//  PromocodeViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class PromocodeViewCellViewModel {
    
    private var promo: Promocodes!
    private var promoType: TypeOfPromocode?
    private var timeLeft: String!
    
    init(currentPromocode promo: Promocodes) {
        self.promo = promo
        self.timeLeft = self.calculatePromoType()
    }
    
    func promocodeName() -> String {
        return self.promo.code
    }
    
    func timeLeftPromocode() -> String {
        return self.timeLeft
    }
    
    func calculatePromoType() -> String {
        let currentDate = Date()
        let promocodeDateExpireString = self.promo.expire_at
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let dateExpired = dateFormatter.date(from: promocodeDateExpireString) else { return "" }
        let promocodeDateExpire = Int(dateExpired.timeIntervalSince1970)
        let currentDateTimeStamp = Int(currentDate.timeIntervalSince1970)
        let diff = promocodeDateExpire - currentDateTimeStamp
        let currentDateTime = Util.serverToLocal(dateString: promocodeDateExpireString)
        if diff < 0 {
            self.promoType = .expired
            return NSLocalizedString("expiredPromo", comment: "")
        } else {
            let hour = diff / 3600
            switch hour {
            case 0..<4:
                self.promoType = .red
                return "\(NSLocalizedString("expiredAt", comment: "")) \(convertToTime(dateString: currentDateTime!))"
            case 4..<24:
                self.promoType = .orange
                return "\(NSLocalizedString("expiredAt", comment: "")) \(convertToTimeDate(dateString: currentDateTime!))"
            case _ where diff > 24:
                self.promoType = .green
                return "\(NSLocalizedString("untilPromo", comment: "")) \(convertToDate(dateString: currentDateTime!))"
            default:
                print("Not found case")
                return ""
            }
        }
    }
    
    func convertToDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let shortDateString = dateFormatter.string(from: date!)
        return shortDateString
    }
    
    func convertToTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm"
        let shortTimeString = dateFormatter.string(from: date!)
        return shortTimeString
    }
    
    func convertToTimeDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        let shortTimeString = dateFormatter.string(from: date!)
        return shortTimeString
    }
    
    func getTypeOfPromo() -> TypeOfPromocode? {
        return self.promoType
    }
}

public enum TypeOfPromocode {
    case red, orange, green, expired
}
