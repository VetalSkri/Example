//
//  NewPurseProtocol.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol NewPurseProtocol: PurseProtocol {
    var title: String { get }
    var enterTheDataText: String { get }
    var cardNumberText: String { get }
    var validPeriodText: String { get }
    var cardOwnerText: String { get }
    var onlyLatinLettersWarningText: String { get }
    var addText: String { get }
    func setCardNumber(number: String?)
    func setCardExpiredDate(expiredDate: String?)
    func setCardHolderName(holderName: String?)
    func addButtonEnabled() -> Bool
    func addButtonClicked(failure: (()->())?)
    func pop()
}
