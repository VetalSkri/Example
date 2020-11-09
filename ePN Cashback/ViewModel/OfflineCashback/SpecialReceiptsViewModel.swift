//
//  SpecialReceiptsViewModel.swift
//  Backit
//
//  Created by Ivan Nikitin on 10/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class SpecialReceiptsViewModel {
    
    private var singleOffers: [OfferOffline]
    private var typeOfResponse: TypeOfEpmtyOfflineOffersResponse?
    private var idOfShop: Int?
    private let router: UnownedRouter<OfflineCBRoute>
    private let repository: ReceiptRepositoryProtocol
    private let keyNotification: Notification.Name = .specialReceiptQR
    
    init(router: UnownedRouter<OfflineCBRoute>, offlineRepository: ReceiptRepositoryProtocol) {
        self.repository = offlineRepository
        self.router = router
        self.singleOffers = repository.fetchOfflineOffers(byType: .offlineSingle) ?? []
        self.typeOfResponse = .empty
    }
    
    func getKeyNotificationName() -> Notification.Name {
        return keyNotification
    }
    
    func setIdOffer(_ id: Int) {
        self.idOfShop = id
    }
    
    var searchTitle: String {
        return NSLocalizedString("Products or store", comment: "")
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnSpecial() {
        router.trigger(.specialOffer)
    }
    
    func goOnShowResultSuccess() {
        router.trigger(.successScan)
    }
    
    func enterManualy() {
        router.trigger(.manual(keyNotification))
    }
    
    func goOnShowResultError(errorMessage: String) {
        router.trigger(.errorScan(errorMessage))
    }
    
    func goOnFAQ() {
        router.trigger(.faq)
    }
    
    func getTypeOfResponse() -> TypeOfEpmtyOfflineOffersResponse {
        return typeOfResponse ?? .empty
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return singleOffers.count
    }
    
    func goOnDetailPageForSelected(at item: Int) {
        var offer: OfferOffline
        guard singleOffers.count > item else { return }
        offer = singleOffers[item]
        ///Send event to analytic about open scan from multyOffers
        Analytics.openEventDetailSpecOffer(title: offer.title)
        router.trigger(.detailPage(offer, .specialOffer))
    }
    
    func goOnScan() {
        ///Send event to analytic about scan special offers
        Analytics.openEventScanFromSpecOffers()
        router.trigger(.scan(keyNotification))
    }
    
    func cellViewModel(for index: Int) -> OfflineCBViewCellModelType? {
        let offer = singleOffers[index]
        return OfflineCBViewCellViewModel(offer: offer)
    }
    
    func displayResult(qrString qrCode: String, completion: @escaping (()->())) {
        guard let id = idOfShop else { return }
        repository.getResultOfCheck(idOffer: id, qrString: qrCode) { [weak self] (errorMessage) in
            completion()
            if errorMessage == nil {
                self?.goOnShowResultSuccess()
            } else {
                self?.goOnShowResultError(errorMessage: errorMessage!)
            }
        }
    }
    
    func displayOffers(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        repository.presentSpecialOfflineOffers(isForced: isForced, completion: { [weak self] (offers) in
            self?.singleOffers.removeAll()
            self?.singleOffers.append(contentsOf: offers)
            completion?()
        }) { (error) in
            failure?(error.code)
        }
    }
    
    func showHelp(fromFaq: Bool) {
        router.trigger(.showHelp(fromFaq, .scpecial))
    }
    
    func goToLanding() {
        router.trigger(.landing)
    }
    
}


