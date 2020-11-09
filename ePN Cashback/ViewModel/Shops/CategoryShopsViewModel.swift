//
//  CategoryShopsViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 20/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class CategoryShopsViewModel: FavoriteShopsModelType {
    
    var isPaging: Bool = true
    var requestFailure = false
    private var isChanged = false
    private var selectedIndexPath: IndexPath?
    private var shops: [Store]!
    private var category: Categories!
    private var sortBy: StatusOfSort!
    private var categoryIds: [Int]?
    private var typeOfResponse: TypeOfEpmtyShopsResponse?
    private let router: UnownedRouter<ShopsRoute>!
    private let repository: StoreRepositoryProtocol!
    
    init(router: UnownedRouter<ShopsRoute>, storeRepository: StoreRepositoryProtocol, category currentCategory: Categories) {
        self.router = router
        self.repository = storeRepository
        self.category = currentCategory
        self.sortBy = .Priority
        self.shops = repository.presentPageShopCategory(ids: buildCategoryIds(parentId: category.id), sortBy: sortBy) ?? []
    }
    
    private func buildCategoryIds(parentId: Int) -> [Int] {
        var categoryIds = [Int]()
        categoryIds.append(parentId)
        if let childCategories = CoreDataStorageContext.shared.fetchShopsCategories(by: parentId) {
            childCategories.forEach{ (childCategory) in
                categoryIds.append(contentsOf: buildCategoryIds(parentId: childCategory.id))
            }
        }
        return categoryIds
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func showShopDetailPage(at index: Int) {
        router.trigger(.shopDetail(shop(at: index), .category))
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
        return category.name
    }
    
    func presentShops(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        synced(self) {
            if categoryIds == nil {
                categoryIds = buildCategoryIds(parentId: category.id)
            }
            guard let categoryIds = categoryIds else {
                failure?(0000010)
                return
            }
            repository.presentShopsCategory(isForced: isForced, ids: categoryIds, sortBy: sortBy, completion: { [weak self] (currentStores) in
                self?.shops.removeAll()
                self?.shops.append(contentsOf: currentStores)
                completion?()
            }) { (error) in
                failure?((error as NSError).code)
            }
        }
    }

    func presentPage(completion: @escaping (((Int,Int)?)->())) {
        synced(self) {
            var size = 0
            var start = 0
            if categoryIds == nil {
                categoryIds = buildCategoryIds(parentId: category.id)
            }
            guard let categoryIds = categoryIds else {
                completion(nil)
                return
            }
            guard let storePage = repository.presentPageShopCategory(ids: categoryIds, offSet: shops.count, sortBy: sortBy) else {
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
