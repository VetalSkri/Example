//
//  PaymentViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class PaymentViewCellViewModel: PaymentViewCellViewModelType {
    
    private var currentPayment: Payments
    var image: Box<UIImage?> = Box(nil)
    
    init(payment: Payments) {
        self.currentPayment = payment
    }
    
    func titleOfStatus() -> String {
//        let status = LocalSymbolsAndAbbreviations.getPaymentStatus(fromStatus: currentPayment.payment.status)
        switch currentPayment.payment.status {
        case "success":
            return NSLocalizedString("Payment_completed", comment: "")
        case "error":
            return NSLocalizedString("Payment_rejected", comment: "")
        case "banned":
            return NSLocalizedString("Payment_banned", comment: "")
        default:
            return NSLocalizedString("Payment_hold", comment: "")
        }
    }

    var typeOfPaymentStatus: EPNPaymentCard.Style {
//        let status = LocalSymbolsAndAbbreviations.getPaymentStatus(fromStatus: currentPayment.payment.status)
        switch currentPayment.payment.status {
        case "success":
            return EPNPaymentCard.Style(rawValue: 2)!
        case "error":
            return EPNPaymentCard.Style(rawValue: 3)!
        case "banned":
            return EPNPaymentCard.Style(rawValue: 3)!
        default:
            return EPNPaymentCard.Style(rawValue: 1)!
        }
    }

    func paymentText() -> String {
        return NSLocalizedString("Amount of payment", comment: "")
    }

    func costText() -> String {
        return "\(currentPayment.payment.amount)\(currencyOfOrder)"
    }
    
    func purseNumber() -> String {
        if currentPayment.payment.isCharity {
            return NSLocalizedString("CharityTitle", comment: "")
        } else {
            if let number = currentPayment.payment.purse.account {
                return number
            } else {
                return currentPayment.payment.purse.number ?? ""
            }
        }
    }

    private var currencyOfOrder: String {
        return LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: currentPayment.payment.currency)
    }

    func getPurseTypeLogo() -> UIImage {
        if currentPayment.payment.isCharity {
            return UIImage(named: "fundXSmall")!
        } else {
            if let brand = currentPayment.payment.purse.brand {
                return LocalSymbolsAndAbbreviations.getPurseLogoBy(title: brand)
            } else {
                return LocalSymbolsAndAbbreviations.getPurseLogoBy(title: currentPayment.payment.purse_type)
            }
        }
    }

}
