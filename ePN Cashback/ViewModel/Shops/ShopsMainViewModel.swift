//
//  ShopsMainViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 07/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class ShopsMainViewModel: ShopsMainModelType {
    
    var isPaging: Bool = true
    private var selectedIndexPath: IndexPath?
    private var shops: [Store]
    private lazy var doodles: [DoodlesItem] = CoreDataStorageContext.shared.fetchDoodles()
    private var typeOfResponse: TypeOfEpmtyShopsResponse?
    var requestFailure = false
    private var isChanged = false
    var needUpdate: Bool
    
    private let router: UnownedRouter<ShopsRoute>
    private let repository: StoreRepositoryProtocol
    
    init(router: UnownedRouter<ShopsRoute>, storeRepository: StoreRepositoryProtocol, needUpdate: Bool) {
        self.router = router
        self.repository = storeRepository
        self.shops = repository.fetchStores() ?? []
        self.needUpdate = needUpdate
    }
    
    func goOnCategories() {
        router.trigger(.categories)
    }
    
    func getRouter() -> UnownedRouter<ShopsRoute> {
        return router
    }
    
    func getRepository() -> StoreRepositoryProtocol {
        return repository
    }

    func goOnFAQHowToBuy() {
        router.trigger(.faqHowToBuy)
    }
    
    func goOnFavorites()  {
        router.trigger(.favorite)
    }
    
    func showShopDetailPage(at index: Int) {
        router.trigger(.shopDetail(shop(at: index), .main))
    }
    
    func setActivePaging(_ isPaging: Bool) {
        self.isPaging = isPaging
    }
    
    func numberOfItems() -> Int {
        return shops.count
    }
    
    
    func shop(at index: Int) -> Store {
        return self.shops[index]
    }
    
    func itemViewModel(at index: Int) -> StoreCardViewCellModelType? {
        guard shops.count > index else { return nil }
        let currentStore = shops[index]
        return StoreCardViewCellViewModel(store: currentStore)
    }
    
    func presentPage(completion: @escaping (((Int, Int)?) -> ())) {
        synced(self) {
            var size = 0
            var start = 0
            guard let storePage = repository.fetchStores(offSet: shops.count) else {
                completion(nil)
                return
            }
            start = shops.count
            size = storePage.count
            shops.append(contentsOf: storePage)
            completion((size, start))
        }
    }
    
    func presentDoodles(completion: (() -> ())?) {
        repository.presentDoodles { [weak self] (currentDoodles) in
            self?.doodles = currentDoodles
            completion?()
        }
    }
    
    func presentShops(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        synced(self) {
            requestFailure = false
            typeOfResponse = .empty
            repository.presentStores(isForced: isForced, completion: { [weak self] (stores) in
                self?.shops.removeAll()
                self?.shops.append(contentsOf: stores)
                completion?()
            }) { [weak self] (error) in
                self?.requestFailure = true
                //FIXMe: change the failure closure with error
                failure?(error.code)
            }
        }
    }
    
    func changeFavouriteStatus(index: Int, to like: Bool, completion: @escaping ((IndexPath?)->())) {
        let currentShop = shops[index]
        if like {
            addToFavorite(store: currentShop) { [weak self] (store) in
                guard let changedStore = store, let self = self else { completion(nil); return }
                completion(self.updateList(by: changedStore))
            }
        } else {
            deleteFromFavorite(store: currentShop) { [weak self] (store) in
                guard let changedStore = store, let self = self else { completion(nil); return }
                completion(self.updateList(by: changedStore))
            }
        }
    }

    func updateList(by changedStore: Store) -> IndexPath? {
        shops.first(where: { $0.id == changedStore.id })?.isFavorite = changedStore.isFavorite
        let index = shops.firstIndex(of: changedStore)
        return (index == nil) ? nil : IndexPath(row: index!, section: 0)
    }
    
    func headerViewModel() -> ShopMainHeaderViewModel {
        return ShopMainHeaderViewModel(doodles: doodles, router: self.router)
    }
    
    func hasDoodles() -> Bool {
        return self.doodles.count > 0
    }
    
    func loadUserProfile() {
        ProfileApiClient.profile { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveProfileData(profile: response.data.attributes)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func loadUserBalance() {
        BalanceApiClient.balance { (result) in
            switch result {
            case .success(let response):
                OperationQueue.main.addOperation {
                    Util.saveBalance(allBalance: response.data)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
public enum TypeOfEpmtyShopsResponse {
    case search, empty
}
