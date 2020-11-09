//
//  OfflineCashbackModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 02/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

protocol OfflineCashbackModelType {
    
    var titleNavBar: String { get }
    var getTextForEmptyPage: String { get }
    var getTitleForFilterPage: String { get }
    var getTitleForEmptyPage: String { get }
    var searchTitle: String { get }
    
    func getTypeOfResponse() -> TypeOfEpmtyOfflineOffersResponse
    func numberOfRowsInSection(section: Int) -> Int
    func numberOfItems() -> Int
    func cellViewModel(for index: Int) -> OfflineCBViewCellModelType?
    func displayOffers(isForced: Bool, completion: (()->())?, failure: ((Int)->())?)
    func displayResult(qrString qrCode: String, completion: @escaping (()->()))
    func getKeyNotificationName() -> Notification.Name
    func goOnBack()
    func enterManualy()
    func goOnScan()
    func goOnDetailPageForSelected(at item: Int)
    func goOnShowResultSuccess()
    func goOnShowResultError(errorMessage: String)
    func goOnFAQ()
    func showHelp(fromFaq: Bool) 
    func goOnSpecial()
    func goToLanding()
    
    func presentOffersByFilter()
    func headerViewModel() -> ReceiptMainHeaderViewModel?
    func countOfFilters() -> Int
    func displayCategories(isForced: Bool, completion: (()->())?, failure: ((Int)->())?)
    func getRouter() -> UnownedRouter<OfflineCBRoute>
    func getRepository() -> ReceiptRepositoryProtocol
    func isActiveSpecialOffers() -> Bool
    func filterHasBeenChanged() -> Bool
}

extension OfflineCashbackModelType {
    
    var titleNavBar: String {
        return NSLocalizedString("OfflineCashback", comment: "")
    }
    
    var getTextForEmptyPage: String {
        return NSLocalizedString("No products have been found for this search. Redraft it.", comment: "")
    }
    
    var getTitleForEmptyPage: String {
        return NSLocalizedString("No products have been found", comment: "")
    }
    
    var getTitleForFilterPage: String {
        return NSLocalizedString("Nothing here yet", comment: "")
    }
    
    func displayOffers(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        return displayOffers(isForced: isForced, completion: completion, failure: failure)
    }
}
