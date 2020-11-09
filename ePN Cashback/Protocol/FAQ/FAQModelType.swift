//
//  FAQModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 25/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol FAQModelType {

    var titleFAQ: String { get }
    var topInfoText: String { get }
    var whatIsCBText: String { get }
    var howToBuyText: String { get }
    var whatToDoAfterBuyText: String { get }
    var howOrderPaymentsText: String { get }
    var onBoardingText: String { get }
    var rulesText: String { get }
    var bottomInfoText: String { get }
    var buttonToSupportText: String { get }
    var yourAccountNotSuitableText: String { get }
    var yourRegisterWebmasterAccountText : String { get }
    func getType() -> FaqViewType
    func numberOfRowsInSection(fromSection section: Int) -> Int
    func titleOfSection(inSection section: Int) -> String
    func countOfSections() -> Int
    func getSectionHeaderHeight() -> Int
    func indexSetOfSections() -> NSIndexSet
    func cellDidSelected(cellIndexPath: IndexPath)
    func cellViewModel(forIndexPath indexPath: IndexPath) -> FAQViewCellViewModelType?
    func loadData(forceRefresh: Bool, completion: (()->())?, failure: (()->())?)
    
    func goOnBack()
    func goOnSupport()
    func goOnPopUpGuid()
    func goOnFAQRulesToBuy()
    func goOnFAQWhatIsCB()
    func goOnFAQHowOrderPayments()
    func goOnFAQWhatToDoAfter()
    func goOnHowToBuy()
    func goOnIntroduction()
    func goOnAuth()
    
    func searchViewModel() -> SearchQuestionAnswerViewModel
}

extension FAQModelType {
    
    var titleFAQ: String {
        return NSLocalizedString("HelpFAQ", comment: "")
    }
    
    var topInfoText: String {
        return NSLocalizedString("FAQ_ImportantThings", comment: "")
    }
    
    var whatIsCBText: String {
        return NSLocalizedString("FAQ_whatIsCB", comment: "")
    }
    
    var howToBuyText: String {
        return NSLocalizedString("FAQ_howToBuy", comment: "")
    }
    
    var whatToDoAfterBuyText: String {
        return NSLocalizedString("FAQ_whatToDoAfterBuy", comment: "")
    }
    
    var howOrderPaymentsText: String {
        return NSLocalizedString("FAQ_howOrderPayments", comment: "")
    }
    
    var onBoardingText: String {
        return NSLocalizedString("FAQ_onBoarding", comment: "")
    }
    
    var rulesText: String {
        return NSLocalizedString("FAQ_rules", comment: "")
    }
    
    var bottomInfoText: String {
        return NSLocalizedString("FAQ_bottomInfo", comment: "")
    }
    
    var buttonToSupportText: String {
        return NSLocalizedString("FAQ_buttonToSupport", comment: "")
    }
    
    var yourAccountNotSuitableText : String {
        return NSLocalizedString("FAQ_yourAccountNotValid", comment: "")
    }
    
    var yourRegisterWebmasterAccountText : String {
        return NSLocalizedString("FAQ_yourRegisterWebmasterAccount", comment: "")
    }
    
}
