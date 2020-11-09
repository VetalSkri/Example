//
//  ManualEnterCheckViewModel.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class ManualEnterCheckViewModel: ManualEnterCheckModelType {
    
    private let router: UnownedRouter<ScanRoute>
    let openSingleModal: Bool
    
    init(router: UnownedRouter<ScanRoute>, openSingleModal: Bool) {
        self.router = router
        self.openSingleModal = openSingleModal
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnClose(qrString: String) {
        Analytics.sentEventManualySendQR()
        router.trigger(.dismiss(qrString))
    }
    
    func goOnScan() {
        if openSingleModal {
            router.trigger(.close)
        } else {
            router.trigger(.scan)
        }
    }
    
    func goOnHint() {
        router.trigger(.hint)
    }
}
