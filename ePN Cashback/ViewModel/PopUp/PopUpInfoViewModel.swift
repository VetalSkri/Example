//
//  PopUpInfoViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class PopUpInfoViewModel: PopUpInfoModelType {
    
    private var isActivated: Bool?
    private let router: UnownedRouter<PromocodesRoute>
    
    init(router: UnownedRouter<PromocodesRoute>, isActive: Bool) {
        self.router = router
        self.isActivated = isActive
    }
    
    func goOnClose() {
        router.trigger(.close)
    }
    
    func getImageInfo() -> UIImage? {
        guard let isActive = isActivated else { return nil }
        return isActive ? UIImage(named: "successResult") : UIImage(named: "errorResult")
    }
    func getTitleText() -> String {
        guard let isActive = isActivated else { return "" }
        return isActive ? NSLocalizedString("ActivatedPromocode", comment: "") : NSLocalizedString("NotActivatedPromocode", comment: "")
    }
    
}

