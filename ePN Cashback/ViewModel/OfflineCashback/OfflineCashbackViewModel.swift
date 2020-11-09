//
//  OfflineCashbackViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 26/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class OfflineCashbackViewModel: OfflineCashbackModelType {
    
    private lazy var offlineOffers: [Store] = CoreDataStorageContext.shared.fetchOffersBy(typeId: .offline) ?? []
    private var findedOfflineOffers: [Store]
    private var typeOfResponse: TypeOfEpmtyOfflineOffersResponse?
    var isSearching: Bool
    private var idOfShop: String = ""
    private let router: AnyRouter<OfflineCBRoute>
    
    init(router: AnyRouter<OfflineCBRoute>) {
        self.router = router
        self.findedOfflineOffers = []
        self.typeOfResponse = .empty
        self.isSearching = false
    }
    
    var searchTitle: String {
        return NSLocalizedString("Products or store", comment: "")
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnShowResultSuccess() {
        router.trigger(.successScan)
    }
    
    func goOnShowResultError(errorMessage: String) {
        router.trigger(.errorScan(errorMessage))
    }
    
    func goOnFAQ() {
        router.trigger(.faq)
    }
    
    func goToDetailPage(row: Int) {
        router.trigger(.detail(shop(at: row)))
    }
    
    func getTypeOfResponse() -> TypeOfEpmtyOfflineOffersResponse {
        return typeOfResponse ?? .empty
    }
    
    func setActiveSearching(_ isActive: Bool) {
        self.isSearching = isActive
    }
    
    func numberOfRowsInSection() -> Int {
        return offlineOffers.count
    }
    
    func numberOfFindedItems() -> Int {
        return findedOfflineOffers.count
    }
    
    func searchOffers(by title: String) {
        typeOfResponse = .search
        if title.isEmpty {
            findedOfflineOffers.removeAll()
            findedOfflineOffers.append(contentsOf: offlineOffers)
        } else {
            let findShops = self.offlineOffers.filter{ $0.store.title.lowercased().contains(title.lowercased()) }
            findedOfflineOffers.removeAll()
            findedOfflineOffers.append(contentsOf: findShops)
        }
    }
    
    func goOnScanForSelectedOfferId(at item: Int) {
        if isSearching {
            idOfShop = String(findedOfflineOffers[item].id)
        } else {
            idOfShop = String(offlineOffers[item].id)
        }
        router.trigger(.scan)
    }
    
    func shop(at index: Int) -> Store {
        if isSearching {
            return findedOfflineOffers[index]
        } else {
            return offlineOffers[index]
        }
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> OfflineCBViewCellModelType? {
        let offer = offlineOffers[indexPath.row]
        return OfflineCBViewCellViewModel(offer: offer)
    }
    
    func findedItemViewModel(forIndexPath indexPath: IndexPath) -> OfflineCBViewCellModelType? {
        let offer = findedOfflineOffers[indexPath.item]
        return OfflineCBViewCellViewModel(offer: offer)
    }
    
    func loadOffersOfflineCB(completion: (()->())?, behaviourHandle: ((FailureBehaviourProtocol)->())?, failure: ((Int)->())?) {
        let networkOperation = OffersOperation(labelIds: nil, search: nil, limit: Util.MAX_SIZE_OF_SHOPS_FROM_SERVER, offset: nil, categoryIds: nil, order: nil, typeId: ShopTypeId.offline.rawValue)
        networkOperation.start()
        networkOperation.success = { [weak self] (offers) in
            guard let offers = offers else {
                //FIXME: - add TExt for failure loading shops!!!
                failure?(000001)
                return
            }
            let currentStores = offers.map { Store(id: $0.id, offer: $0.attributes) }
            OperationQueue.main.addOperation {
                CoreDataStorageContext.shared.addAllOfflineShops(objects: currentStores)
                self?.offlineOffers = CoreDataStorageContext.shared.fetchOffersBy(typeId: ShopTypeId.offline) ?? []
                completion?()
            }
        }
        networkOperation.failure = { [weak self] (errorResponse, error) in
            print("failure loadStores")
            if errorResponse != nil {
                ErrorValidator.chooseActionAfterResponse(errorResponse: errorResponse as! ErrorInfo, success: { () in
                    self?.loadOffersOfflineCB(completion: completion, behaviourHandle: behaviourHandle, failure: failure)
                }, failureBehaviour: { (behaviour) in
                    print("failure failureBehaviour loadStores")
                    behaviourHandle?(behaviour)
                } , failure: { (errorCode) in
                    print("failure failure loadLabelsFromServer")
                    failure?(errorCode)
                })
            } else {
                failure?(error.code)
            }
        }
    }
    
    func showResultOfCheck(qrString qr: String, completion: (()->())?, behaviourHandle: ((FailureBehaviourProtocol)->())?, failure: (()->())?) {
        getAffiliateLink(completion: { [weak weakSelf = self] (linkResult) in
            weakSelf?.generateQRLink(link: linkResult, completion: { [weak weakSelf = self] (redirectLink) in
                weakSelf?.checkResult(redirectLink: redirectLink, qr: qr, completion: {
                    completion?()
                    OperationQueue.main.addOperation {
                        weakSelf?.goOnShowResultSuccess()
                    }
                }, behaviourHandle: { (behaviour) in
                    behaviourHandle?(behaviour)
                }) {  [weak weakSelf = self] (errorMessage) in
                    failure?()
                    OperationQueue.main.addOperation {
                        weakSelf?.goOnShowResultError(errorMessage: errorMessage)
                    }
                }
            }, behaviourHandle: { (behaviour) in
                behaviourHandle?(behaviour)
            }) {  [weak weakSelf = self] (errorMessage) in
                failure?()
                OperationQueue.main.addOperation {
                    weakSelf?.goOnShowResultError(errorMessage: errorMessage)
                }
            }
            }, behaviourHandle: { (behaviour) in
                behaviourHandle?(behaviour)
        }) { [weak weakSelf = self] (errorMessage) in
            failure?()
            OperationQueue.main.addOperation {
                weakSelf?.goOnShowResultError(errorMessage: errorMessage)
            }
        }
    }
    
    func generateQRLink(link: String, completion: ((String)->())?, behaviourHandle: ((FailureBehaviourProtocol)->())?, failure: ((String)->())?) {
        guard let url = URL(string: link) else {
            failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
            return
        }
        let networkOperation = OfflineCbRedirectUrlOperation(service: NetworkBackendService(BackendConfiguration(baseURL: url)))
        networkOperation.start()
        
        networkOperation.success = { (response) in
            completion?(response)
        }
        
        networkOperation.failure = { [weak weakSelf = self] (errorResponse, error) in
            if errorResponse != nil {
                ErrorValidator.chooseActionAfterResponse(errorResponse: errorResponse as! ErrorInfo, success: { () in
                    weakSelf?.generateQRLink(link: link, completion: completion, behaviourHandle: behaviourHandle, failure: failure)
                }, failureBehaviour: { (behaviour) in
                    behaviourHandle?(behaviour)
                } , failure: { (errorCode) in
                    print("error inside getAffiliateLink \(error.localizedDescription) \n errorCode: \(errorCode)")
                    failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
                })
            } else {
                print("error inside getAffiliateLink \(error.localizedDescription)")
                failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
            }
        }
    }
    
    func getAffiliateLink(completion: ((String)->())?, behaviourHandle: ((FailureBehaviourProtocol)->())?, failure: ((String)->())?) {
        guard let idShop = Int(idOfShop) else {
            failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
            return
        }
        let networkOperation = OfflineCbAffiliateLinkOperation(id: idShop)
        networkOperation.start()
        
        networkOperation.success = { (response) in
            guard let link = response?.attributes.cashbackPackage?.link else {
                failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
                return
            }
            completion?(link)
        }
        
        networkOperation.failure = { [weak weakSelf = self] (errorResponse, error) in
            if errorResponse != nil {
                ErrorValidator.chooseActionAfterResponse(errorResponse: errorResponse as! ErrorInfo, success: { () in
                    weakSelf?.getAffiliateLink(completion: completion, behaviourHandle: behaviourHandle, failure: failure)
                }, failureBehaviour: { (behaviour) in
                    behaviourHandle?(behaviour)
                } , failure: { (errorCode) in
                    print("error inside getAffiliateLink \(error.localizedDescription) \n errorCode: \(errorCode)")
                    failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
                })
            } else {
                print("error inside getAffiliateLink \(error.localizedDescription)")
                failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
            }
        }
    }
    
    func checkResult(redirectLink link: String, qr qrData: String, completion: (()->())?, behaviourHandle: ((FailureBehaviourProtocol)->())?, failure: ((String)->())?) {
        guard let urlSourse = URL(string: link) else {
            failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
            return
        }
        let url = urlSourse.appending("qrdata", value: qrData).appending("response", value: "json")
        
        let networkOperation = CheckResultOfflineCBOperation(service: NetworkBackendService(BackendConfiguration(baseURL: url)))
        networkOperation.start()
        
        networkOperation.success = { (result) in
            if result.type == "success" {
                completion?()
            } else {
                //TODO: - add message here
                guard let type = TypeOfStatusOfflineCheck(rawValue: result.status) else {
                    failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
                    return
                }
                switch type {
                case .none:
                    failure?(NSLocalizedString("noneCB", comment: ""))
                case .off:
                    failure?(NSLocalizedString("offCB", comment: ""))
                case .on_duplicate:
                    failure?(NSLocalizedString("on_duplicateCB", comment: ""))
                case .on_duplicate_2:
                    failure?(NSLocalizedString("on_duplicate2CB", comment: ""))
                case .on_incompat_1:
                    failure?(NSLocalizedString("on_incompat_1CB", comment: ""))
                case .on_incompat_2:
                    failure?(NSLocalizedString("on_incompat_2CB", comment: ""))
                case .on_invalid:
                    failure?(NSLocalizedString("on_invalidCB", comment: ""))
                case .on_limited:
                    failure?(NSLocalizedString("on_limitedCB", comment: ""))
//                case .on_ok:
//                    failure?(NSLocalizedString("on_okCB", comment: ""))
                }
            }
        }
        
        networkOperation.failure = { [weak weakSelf = self] (errorResponse, error) in
            if errorResponse != nil {
                ErrorValidator.chooseActionAfterResponse(url: url, errorResponse: errorResponse as! ErrorInfo, success: { () in
                    weakSelf?.checkResult(redirectLink: link, qr: qrData, completion: completion, behaviourHandle: behaviourHandle, failure: failure)
                }, failureBehaviour: { (behaviour) in
                    behaviourHandle?(behaviour)
                } , failure: { (errorMessage) in
                    print("error inside checkResult \(error.localizedDescription)")
                    failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
                })
            } else {
                print("error inside checkResult \(error.localizedDescription)")
                failure?(NSLocalizedString("An unexpected error has occurred.", comment: ""))
            }
        }
    }
}

public enum TypeOfEpmtyOfflineOffersResponse {
    case search, empty
}
