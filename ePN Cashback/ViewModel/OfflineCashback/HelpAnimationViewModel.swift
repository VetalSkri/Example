//
//  HelpAnimationViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

enum HelpAnimationType {
    case multi
    case scpecial
}

class HelpAnimationViewModel: NSObject {
    
    private let router: UnownedRouter<OfflineCBRoute>
    private var fromFaq: Bool!
    private var type: HelpAnimationType!
    
    init(router: UnownedRouter<OfflineCBRoute>, fromFaq: Bool, type: HelpAnimationType) {
        self.router = router
        self.fromFaq = fromFaq
        self.type = type
    }
    
    var title: String {
        return (self.type == HelpAnimationType.multi) ? multiTitle : specialTitle
    }
    
    var subtitle: String {
        return (self.type == HelpAnimationType.multi) ? multiSubtitle : specialSubtitle
    }
    
    var illustrationName: String {
        return (self.type == HelpAnimationType.multi) ? "offlineIllustration" : "specialOfflineIllustration"
    }
    
    var multiTitle: String {
        return NSLocalizedString("How to get cashback?", comment: "")
    }
    
    var multiSubtitle: String {
        return NSLocalizedString("Scan a QR code and get cashback for all offers on the receipt", comment: "")
    }
    
    var specialTitle: String {
        return NSLocalizedString("Choose a product and get cashback", comment: "")
    }
    
    var specialSubtitle: String {
        return NSLocalizedString("Choose a special offer and get cashback only for this product", comment: "")
    }
    
    func close() {
        router.trigger(.dismiss)
    }
    
    func isFromFaq() -> Bool {
        return fromFaq
    }
    
    func getType() -> HelpAnimationType {
        return type
    }
    
}
