//
//  SuccessOrderViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 24/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class SuccessOrderViewModel {
    
    private let router: UnownedRouter<PaymentsRoute>
    private let orderInfo: PaymentOrderAttributes
    private let isCharity: Bool
    
    init(router: UnownedRouter<PaymentsRoute>, orderInfo: PaymentOrderAttributes, isCharity: Bool) {
        self.router = router
        self.orderInfo = orderInfo
        self.isCharity = isCharity
    }
    
    var goToPaymentHistoryText: String {
        return NSLocalizedString("You can see the order status in the Payout history section.", comment: "")
    }
    
    var amount: String {
        return "\(orderInfo.amount)\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: orderInfo.currency))"
    }
    
    var cardNumber: String {
        return isCharity ? NSLocalizedString("CharityTitle", comment: "") : orderInfo.purse
    }
    
    func close(completion: @escaping (()->())) {
        router.trigger(.closeModule) {
            completion()
        }
    }
    
    func goToPaymentHistory(completion: @escaping (()->())) {
        router.trigger(.goToPaymentHistory) {
            completion()
        }
    }
    
}
