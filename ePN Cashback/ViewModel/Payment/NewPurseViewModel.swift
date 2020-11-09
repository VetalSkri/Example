//
//  NewPurseViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 30/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class NewPurseViewModel: NewPurseProtocol
{
    var purseType: PurseType!
    
    //Card fields
    private var cardNumber: String? = nil
    private var expiredDate: String? = nil
    private var cardHolderName: String? = nil
    
    private let router: UnownedRouter<PaymentsRoute>
    
    init(router: UnownedRouter<PaymentsRoute>, purseType: PurseType) {
        self.router = router
        self.purseType = purseType
    }
    
    var title: String {
        return NSLocalizedString("Addition of the wallet", comment: "")
    }
    
    var enterTheDataText: String {
        return NSLocalizedString("Enter the data", comment: "")
    }
    
    var cardNumberText: String {
        return NSLocalizedString("Card number", comment: "")
    }
    
    var validPeriodText: String {
        return NSLocalizedString("Valid period", comment: "")
    }
    
    var cardOwnerText: String {
        return NSLocalizedString("Card owner", comment: "")
    }
    
    var onlyLatinLettersWarningText: String {
        return NSLocalizedString("Name and surname should contain only Latin letters", comment: "")
    }
    
    var addText: String {
        return NSLocalizedString("Add", comment: "")
    }
    
   
    
    func setCardNumber(number: String?) {
        self.cardNumber = number
    }
    
    func setCardExpiredDate(expiredDate: String?) {
        self.expiredDate = expiredDate
    }
    
    func setCardHolderName(holderName: String?) {
        self.cardHolderName = holderName
    }
    
    func addButtonEnabled() -> Bool {
        return (self.cardNumber != nil && isCorrectExpiredDate() && self.cardHolderName != nil)
    }
    
    func addButtonClicked(failure: (()->())?) {
        let expMonth = expiredDate?.substring(to: 2) ?? ""
        let expYear = expiredDate?.substring(from: 3) ?? ""
        var dictParams = Dictionary<String, Any>()
        dictParams.add([Constants.APIParameterKey.account : cardNumber!])
        dictParams.add([Constants.APIParameterKey.cardholderName : cardHolderName!])
        dictParams.add([Constants.APIParameterKey.expMonth : expMonth])
        dictParams.add([Constants.APIParameterKey.expYear : expYear])
        PaymentApiClient.createPurse(purseType: purseType.rawValue, purseValue: nil, purseDicdt: dictParams) { [weak self] (result) in
            switch result {
            case .success(let responseObject):
                PaymentUtils.shared.saveNewPurse(purse: responseObject)
                NotificationCenter.default.post(name: Notification.Name("NewPurseDidAdded"), object: nil)
                self?.router.trigger(.popToRoot)
                if let self = self, let purseType = self.purseType {
                    Analytics.sendEventAddPurse(purseType: purseType)
                }
                break
            case .failure(let error):
                failure?()
                Alert.showErrorAlert(by: error)
                break
            }
        }
    }
    
    func pop() {
        router.trigger(.back)
    }
    
    private func isCorrectExpiredDate() -> Bool {
        guard let expiredDate = self.expiredDate else {
            return false
        }
        guard let regex = try? NSRegularExpression(pattern: "^\\d{2}/\\d{2}$", options: []) else { return false }
        let results  = regex.matches(in: expiredDate, options: [], range: NSMakeRange(0, expiredDate.count))
        return results.count > 0
        
    }
    
}

public struct MaskAndPrefix {
    var mask: String
    var placeholder: String
    var prefix: String
}

public struct FieldsForRecipentData {
    var type: FieldsType
}

enum FieldsType: String {
    case name = "name"
    case secondName = "secondName"
    case birth_date = "Birth date"
    case adress = "adress"
    case cardData = "XXXX-XXXX-XXXX-XXXX"
    case cardDate = "MM-YY"
    case country = "Страна проживания"
}

