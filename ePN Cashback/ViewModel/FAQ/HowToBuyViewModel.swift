//
//  HowToBuyViewModel.swift
//  CashBackEPN
//
//  Created by Александр on 07/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class HowToBuyViewModel: HowToBuyModelType {
    
    private let fragments : [FaqCollectionViewFragment]
    
    private let router: UnownedRouter<FAQRoute>
    
    init(router: UnownedRouter<FAQRoute>) {
        self.router = router
        self.fragments = [
            FaqCollectionViewFragment(illustrationName: "illustration2.1", title: NSLocalizedString("FAQ_Choose_store_head", comment: ""), description: NSLocalizedString("FAQ_Choose_store_and_click_on_it", comment: ""), nextButtonTitle:""),
            FaqCollectionViewFragment(illustrationName: "illustration2.2", title: NSLocalizedString("FAQ_BeShureToGetCashback_head", comment: ""), description: NSLocalizedString("FAQ_OpenTheSection", comment: ""), nextButtonTitle:""),
            FaqCollectionViewFragment(illustrationName: "illustration2.3", title: NSLocalizedString("FAQ_Withdraw_cashback", comment: ""), description: NSLocalizedString("FAQ_WhenTheOrderStatusChanged", comment: ""), nextButtonTitle:"")
        ]
    }
 
    func numberOfFragments() -> Int {
        return fragments.count
    }
    
    func fragment(forRow: Int) -> FaqCollectionViewFragment{
        return fragments[forRow]
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
}

public struct FaqCollectionViewFragment{
    let illustrationName : String
    let title : String
    let description : String
    let nextButtonTitle : String
}
