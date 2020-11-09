//
//  NewPurseWebViewViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 18/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class NewPurseWebViewViewModel : NewPurseWebViewProtocol
{
    private let router: UnownedRouter<PaymentsRoute>
    var purseType: PurseType!
    let baseUrl = "https://backit.me"
    
    init(router: UnownedRouter<PaymentsRoute>, purseType: PurseType) {
        self.router = router
        self.purseType = purseType
    }
    
    var title: String {
        return NSLocalizedString("Addition of the wallet", comment: "")
    }
    
    func pop() {
        router.trigger(.back)
    }
    
    func getLink(completion: ((String?)->())?) {
        let alias = (purseType == PurseType.cardpay) ? "cardpay" : "capitalist"
        SsoApiClient.sso { (result) in
            switch result {
            case .success(let response):
                completion?("\(self.baseUrl)/ru/sso/auth?ssoToken=\(response.data.attributes.ssoToken)&urlAlias=\(alias)")
                break
            case .failure(let error):
                completion?(nil)
                break
            }
        }
    }
    
    func cardWasAdded(id: String, type: String, value: String) {
        let purseConfirm = NewPurseConfirm(type: (type.lowercased() == "send email") ? .email : .phone, value: value)
        if let integerId = Int(id) {
            PaymentUtils.shared.saveNewPurse(purse: purseConfirm, purseId: integerId)
            NotificationCenter.default.post(name: Notification.Name("NewPurseDidAdded"), object: nil)
            if let purseType = self.purseType {
                Analytics.sendEventAddPurse(purseType: purseType)
            }
            router.trigger(.popToRoot)
        }
        
    }
    
}
