//
//  IntroductionToTheAppViewModel.swift
//  CashBackEPN
//
//  Created by Александр on 08/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

public enum IntroductionToTheAppType {
    case normal
    case onBoarding
}

class IntroductionToTheAppViewModel : IntroductionToTheAppModelType {
    private var pageType : IntroductionToTheAppType
    
    private var fragments : [FaqCollectionViewFragment] {
        var fragments = [FaqCollectionViewFragment]()
        fragments.append(FaqCollectionViewFragment(illustrationName: "illustration5.1", title: NSLocalizedString("FAQ_Welcome", comment: ""), description: NSLocalizedString("FAQ_OurAppWillHelp", comment: ""), nextButtonTitle:NSLocalizedString("FAQ_Good", comment: "")))
        fragments.append(FaqCollectionViewFragment(illustrationName: "illustration5.2", title: NSLocalizedString("FAQ_WePayCashback", comment: ""), description: NSLocalizedString("FAQ_GetBackAPart", comment: ""), nextButtonTitle:NSLocalizedString("FAQ_Ok", comment: "")))
        fragments.append(FaqCollectionViewFragment(illustrationName: "illustration5.3", title: NSLocalizedString("FAQ_CashbackForReceipts", comment: ""), description: NSLocalizedString("FAQ_SearchForOffers", comment: ""), nextButtonTitle:NSLocalizedString("FAQ_WhatElse", comment: "")))
        fragments.append(FaqCollectionViewFragment(illustrationName: "illustration5.4", title: NSLocalizedString("FAQ_CollectTheBestOffers", comment: ""), description: NSLocalizedString("FAQ_PromotionsSection", comment: ""), nextButtonTitle:self.lastButtonText()))
        return fragments
    }
    
    private let router: UnownedRouter<FAQRoute>
    
    init(router: UnownedRouter<FAQRoute>, type: IntroductionToTheAppType = .normal) {
        self.router = router
        self.pageType = type
    }
    
    func goOnBack() {
        router.trigger(.back)
    }

    func goOnMain() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.router.trigger(.main(0), with: TransitionOptions(animated: false))
    }
    
    func goOnAuth() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.router.trigger(.auth(animate: false), with: TransitionOptions(animated: false))
    }
    
//    func setPageType(type: IntroductionToTheAppType) {
//        self.pageType = type
//    }
    
    func type() -> IntroductionToTheAppType {
        return pageType
    }
    
    func numberOfFragments() -> Int {
        return fragments.count
    }
    
    func fragment(forRow: Int) -> FaqCollectionViewFragment{
        return fragments[forRow];
    }
    
    func skipButtonTitle() -> String{
        return NSLocalizedString("FAQ_Skip", comment: "")
    }
    
    func lastButtonText() -> String {
        switch (self.pageType) {
        case .normal:
            return NSLocalizedString("FAQ_Good", comment: "")
        case .onBoarding:
            return NSLocalizedString("FAQ_Register", comment: "")
        }
    }
    
}
