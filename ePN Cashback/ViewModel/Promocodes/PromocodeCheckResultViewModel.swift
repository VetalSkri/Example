//
//  PromocodeCheckResultViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class PromocodeCheckResultViewModel: PromocodeCheckResultModelType {
    
    private var promocode: PromocodeInfo
    private let router: UnownedRouter<PromocodesRoute>
    
    init(router: UnownedRouter<PromocodesRoute>, promocode: PromocodeInfo) {
        self.router = router
        self.promocode = promocode
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func promocodeNameText() -> String {
        return promocode.code
    }
    
    func activatePeriodText() -> String {
        let start = Util.serverToLocal(dateString: promocode.start_at)!
        let finish = Util.serverToLocal(dateString: promocode.expire_at)!
        return "\(NSLocalizedString("dateFrom", comment: "")) \(convertToDateTime(dateString: start))\n\(NSLocalizedString("dateTo", comment: "")) \(convertToDateTime(dateString: finish))"
    }
    
    func validityText() -> String {
        return convertValidityTime(seconds: promocode.active_seconds)
    }
    
    private func convertValidityTime(seconds: Int) -> String {
        let daysCount = seconds / 86400;
        let hoursCount = (seconds % 86400) / 3600;
        let minutesCount = (seconds % 3600) / 60;
        var validityTime: String = ""
        if (daysCount > 0) {
            if (hoursCount > 0) {
                let formatDaysString = NSLocalizedString("NumberOfDays", comment: "")
                let formatHoursString = NSLocalizedString("NumberOfHours", comment: "")
                validityTime = "\(String.localizedStringWithFormat(formatDaysString, daysCount)) \(String.localizedStringWithFormat(formatHoursString, hoursCount))"
            } else {
                let formatDaysString = NSLocalizedString("NumberOfDays", comment: "")
                validityTime = "\(String.localizedStringWithFormat(formatDaysString, daysCount))"
            }
        } else if (hoursCount > 0) {
            if (minutesCount > 0) {
                let formatHoursString = NSLocalizedString("NumberOfHours", comment: "")
                let formatMinutesString = NSLocalizedString("NumberOfMinutes", comment: "")
                validityTime = "\(String.localizedStringWithFormat(formatHoursString, hoursCount)) \(String.localizedStringWithFormat(formatMinutesString, minutesCount))"
            } else {
                let formatHoursString = NSLocalizedString("NumberOfHours", comment: "")
                validityTime = "\(String.localizedStringWithFormat(formatHoursString, hoursCount))"
            }
        } else {
            let formatMinutesString = NSLocalizedString("NumberOfMinutes", comment: "")
            validityTime = "\(String.localizedStringWithFormat(formatMinutesString, minutesCount))"
        }
        return validityTime
    }
    
    func currentPromocode() -> PromocodeInfo {
        return self.promocode
    }
    
    func convertToDateTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let shortTimeString = dateFormatter.string(from: date!)
        return shortTimeString
    }
    
    func activatePromocode(completion: ((PromocodeActivateInfo)->())?, failure: (()->())?) {
        PromocodeApiClient.activate(code: promocode.code) { [weak self] (result) in
            switch result {
            case .success(let response):
                completion?(response.data.attributes)
                break
            case .failure(let error):
                failure?()
                break
            }
        }
    }
    
}
