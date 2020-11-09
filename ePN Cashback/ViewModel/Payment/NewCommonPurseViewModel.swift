//
//  NewCommonPurseViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 06/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class NewCommonPurseViewModel: NewCommonPurseProtocol
{
    private var purseValue: String? = nil
    var purseType: PurseType!
    private let router: UnownedRouter<PaymentsRoute>
    
    init(router: UnownedRouter<PaymentsRoute>, purseType: PurseType) {
        self.router = router
        self.purseType = purseType
    }
    
    var title: String {
        return NSLocalizedString("Addition of the wallet", comment: "")
    }
    
    var addText: String {
        return NSLocalizedString("Add", comment: "")
    }
    
    var enterTheDataText: String {
        return NSLocalizedString("Enter the data", comment: "")
    }
    
    func addButtonEnabled() -> Bool {
        return self.purseValue != nil
    }
    
    func setPurseValue(value: String?) {
        self.purseValue = value
    }
    
    func addButtonClicked(failure: (()->())?) {
        let purseValue = "\(getMaskAndPrefix().prefix.filter { !$0.isWhitespace })\(self.purseValue ?? "")"
        PaymentApiClient.createPurse(purseType: purseType.rawValue, purseValue: purseValue, purseDicdt: nil) { [weak self] (result) in
            switch result {
            case .success(let response):
                PaymentUtils.shared.saveNewPurse(purse: response)
                PaymentUtils.shared.saveRotatedPurse(forPurseId: response.data.id, rotated: true)
                NotificationCenter.default.post(name: Notification.Name("NewPurseDidAdded"), object: nil)
                if let self = self, let purseType = self.purseType {
                    Analytics.sendEventAddPurse(purseType: purseType)
                }
                self?.router.trigger(.popToRoot)
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
    
}
