//
//  PromocodesViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class PromocodesViewModel: PromocodesModelType {
    private lazy var promocodes: [Promocodes]! = CoreDataStorageContext.shared.fetchPromocodes() ?? [Promocodes]()
    var isErrorCheckPromo: Bool
    private var errorCode: Int!
    private var promocodeString: String?
    private var currentPromocode: PromocodeInfo?
    private var isActive: Bool?
    var isActivating: Bool
    private var page: Int!
    private let DEFAULT_PAGE = 1
    private let DEFAULT_SIZE = 40
    private var isPagging: Bool = false
    private let requestQueue = OperationQueue()
    
    private let router: UnownedRouter<PromocodesRoute>
    
    init(router: UnownedRouter<PromocodesRoute>) {
        self.router = router
        self.requestQueue.maxConcurrentOperationCount = 1
        self.requestQueue.qualityOfService = .userInitiated
        self.isErrorCheckPromo = false
        self.isActivating = false
        self.errorCode = -1
        self.isPagging = (self.promocodes.count >= DEFAULT_SIZE)
        self.page = isPagging ? 2 : DEFAULT_PAGE
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnVerifyLink() {
        router.trigger(.back)
    }
    
    func goOnCheckPromocode() {
        self.isActivating = false
        guard let promocode = currentPromocode else { return }
        router.trigger(.resultOfChecking(promocode))
    }
    
    func goOnShowActivatePromocodeResult() {
        if isActivating {
            guard let activate = isActive else { return }
            router.trigger(.result(activate))
        }
    }
    
    deinit {
        self.requestQueue.cancelAllOperations()
    }
    
    func errorMessage() -> String {
        switch errorCode {
        case 400030:
            return NSLocalizedString("Promocode not found", comment: "")
        case 400031:
            return NSLocalizedString("Promocode expired", comment: "")
        case 400032:
            return NSLocalizedString("Promocode has not yet begun", comment: "")
        case 400033:
            return NSLocalizedString("Promocode over limit", comment: "")
        case 400034:
            return NSLocalizedString("Promo code already activated", comment: "")
        case 422001:
            return NSLocalizedString("Incorrect promocode", comment: "")
        default:
            return ""
        }
    }
    
    func getErrorCode() -> Int {
        return errorCode
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return promocodes.count
        default:
            return 0
        }
    }
    
    func cellViewModel(index: Int) -> PromocodeViewCellViewModel? {
        let currentPromocode = promocodes[index]
        return PromocodeViewCellViewModel(currentPromocode: currentPromocode)
    }
    
    func setPromocode(promocode: String) {
        self.promocodeString = promocode
    }
    
    func checkPromocode(completion: (()->())?, failure: ((String?)->())?) {
        guard let code = promocodeString else { return }
        
        PromocodeApiClient.check(code: code) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.currentPromocode = response.data.attributes
                self?.isErrorCheckPromo = false
                completion?()
                break
            case .failure(let error):
                self?.errorCode = (error as NSError).code
                if let errorString = self?.errorMessage(), !errorString.isEmpty {
                    failure?(errorString)
                } else {
                    failure?(nil)
                    Alert.showErrorAlert(by: error)
                }
                break
            }
        }
    }
    
    func activateNewPromocode(_ activatedPromocode: PromocodeActivateInfo?) {
        self.isActivating = true
        if let newActivatedPromocode = activatedPromocode {
            self.isActive = true
            CoreDataStorageContext.shared.addPromocode(object: Promocodes(code: newActivatedPromocode.code, activated_at: newActivatedPromocode.activation_date, expire_at: newActivatedPromocode.expired_at, status: newActivatedPromocode.status),id: 0)
            self.promocodes = CoreDataStorageContext.shared.fetchPromocodes()
            self.isPagging = (self.promocodes.count >= DEFAULT_SIZE)
            self.page = isPagging ? 2 : DEFAULT_PAGE
        } else {
            self.isActive = false
        }
    }
    
    func isPagingPromocodes(atIndexPath indexPath: IndexPath) -> Bool {
        guard promocodes.count > 0 else { print("error here"); return false }
        if (indexPath.row == promocodes.count - 1) && isPagging {
            return true
        } else {
            return false
        }
    }
    
    func loadListOfPromocodes(completion: (()->())?, failure: (()->())?) {
        synced(self) {
            page = DEFAULT_PAGE
            isErrorCheckPromo = false
            
            PromocodeApiClient.promocodes(page: page, perPage: DEFAULT_SIZE, offerIds: nil, status: nil) { [weak self] (result) in
                switch result {
                case .success(let response):
                    guard let dataPromocodeResponse = response.data else {
                        self?.promocodes.removeAll()
                        OperationQueue.main.addOperation {
                            CoreDataStorageContext.shared.removeAllPromocodes()
                        }
                        self?.isPagging = false
                        completion?()
                        return
                    }
                    let currentPromocodes = dataPromocodeResponse.map{ $0.attributes }
                    self?.promocodes.removeAll()
                    self?.promocodes.append(contentsOf: currentPromocodes)
                    self?.replaceCache(promocodes: currentPromocodes)
                    if response.meta.hasNext {
                        self?.isPagging = true
                        self?.page += 1
                    } else {
                        self?.isPagging = false
                    }
                    completion?()
                    break
                case .failure(let error):
                    failure?()
                    Alert.showErrorAlert(by: error)
                    break
                }
            }
        }
    }
    
    func pagingListOfPromocodes(completion: (()->())?, failure: (()->())?) {
        synced(self) {
            
            PromocodeApiClient.promocodes(page: (page == 2) ? 1 : page, perPage: (page == 2) ? DEFAULT_SIZE * 2 : DEFAULT_SIZE, offerIds: nil, status: nil) { [weak self] (result) in
                switch result {
                case .success(let response):
                    guard let dataPromocodeResponse = response.data else {
                        self?.isPagging = false
                        completion?()
                        return
                    }
                    let currentPromocodes = dataPromocodeResponse.map{ $0.attributes }
                    if (self?.page == 2 && self != nil) {
                        self?.promocodes = currentPromocodes
                        self?.replaceCache(promocodes: Array(currentPromocodes.prefix(self!.DEFAULT_SIZE)))
                    } else {
                        self?.promocodes.append(contentsOf: currentPromocodes)
                    }
                    if response.meta.hasNext {
                        self?.isPagging = true
                        self?.page += 1
                    } else {
                        self?.isPagging = false
                    }
                    completion?()
                    break
                case .failure(let error):
                    failure?()
                    Alert.showErrorAlert(by: error)
                    break
                }
            }
        }
    }
    
    private func replaceCache(promocodes: [Promocodes]) {
        OperationQueue.main.addOperation {
            Session.shared.timeOfTablePromocode = Date()
            CoreDataStorageContext.shared.addAllPromocodes(objects: promocodes)
        }
    }
    
    func cacheLifeTimeIsExpired() -> Bool {
        let now = Date()
        guard let date = Session.shared.timeOfTablePromocode else {
            return true
        }
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_PROMOCODE {
            return true
        } else {
            return false
        }
    }
    
}
