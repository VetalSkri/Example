//
//  ShopListViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 12/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class FavoriteShopsViewModel: FavoriteShopsModelType {
    
    var isPaging: Bool = true
    private var selectedIndexPath: IndexPath?
    private var shops: [Store]
    private var sortBy: StatusOfSort
    private var typeOfResponse: TypeOfEpmtyShopsResponse?
    private var isChanged = false
    
    var requestFailure = false
    private let router: UnownedRouter<ShopsRoute>
    private let repository: StoreRepositoryProtocol
    
    init(router: UnownedRouter<ShopsRoute>, storeRepository: StoreRepositoryProtocol) {
        self.router = router
        self.repository = storeRepository
        self.sortBy = .Priority
        self.shops = repository.fetchFavorites(sortBy: sortBy) ?? []
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func showShopDetailPage(at index: Int) {
        router.trigger(.shopDetail(shop(at: index), .favoriteShops))
    }
    
    func getTypeOfResponse() -> TypeOfEpmtyShopsResponse {
        return .empty
    }
    
    func setActivePaging(_ isPaging: Bool) {
        self.isPaging = isPaging
    }
    
    func numberOfItems() -> Int {
        return shops.count
    }
    
    func showTitle() -> String {
        return NSLocalizedString("Favorite", comment: "")
    }
    
    func presentShops(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        synced(self) {
            requestFailure = false
            typeOfResponse = .empty
            repository.presentFavorites(isForced: isForced, sortBy: sortBy, completion: { [weak self] (stores) in
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
    
    func presentPage(completion: @escaping (((Int,Int)?)->())) {
        synced(self) {
                var size = 0
            var start = 0
            guard let storePage = repository.fetchFavorites(offSet: shops.count, sortBy: sortBy) else {
                completion(nil)
                return
            }
            start = shops.count
            size = storePage.count
            shops.append(contentsOf: storePage)
            completion((size, start))
        }
    }
    
    func itemViewModel(at index: Int) -> StoreCardViewCellModelType? {
        guard shops.count > index else { return nil }
        return StoreCardViewCellViewModel(store: shops[index])
    }
    
    func changeFavouriteStatus(index: Int, to like: Bool, completion: @escaping ((IndexPath?)->())) {
        let currentShop = self.shops[index]
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
    
    func hasBeenChanged() -> Bool {
        return isChanged
    }
    
    func updateList(by changedStore: Store) -> IndexPath? {
        shops.first(where: { $0.id == changedStore.id })?.isFavorite = changedStore.isFavorite
        let index = shops.firstIndex(of: changedStore)
        isChanged = true
        return (index == nil) ? nil : IndexPath(row: index!, section: 0)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func updateSelectedItem() -> IndexPath? {
        return self.selectedIndexPath
    }
    
    func getSorting() -> StatusOfSort {
        return sortBy
    }
    
    func changeSorting(_ sort: StatusOfSort) {
        sortBy = sort
    }
    
    func shop(at index: Int) -> Store {
        return self.shops[index]
    }
    
    func index(of shop: Store) -> IndexPath? {
        let index = self.shops.firstIndex(of: shop)
        return (index == nil) ? nil : IndexPath(row: index!, section: 0)
    }
    
}


//MARK: - status of sorting shops
public enum StatusOfSort: String {
    case New = "new", Alpha = "alpha", Priority = "priority"
}
