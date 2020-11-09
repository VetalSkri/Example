//
//  PaymentViewCellViewModelType.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol PaymentViewCellViewModelType {
    var image: Box<UIImage?> { get }
    var typeOfPaymentStatus: EPNPaymentCard.Style { get }
    
    func getPurseTypeLogo() -> UIImage
    func titleOfStatus() -> String
    func paymentText() -> String
    func costText() -> String
    func purseNumber() -> String
}
