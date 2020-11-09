//
//  SearchShopsViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 20/12/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift
import RxCocoa

class SearchShopsViewModel: SearchShopsModelType {
    
    var searchStore: Box<[Store]>
    var isPaging: Bool = true
    var requestFailure: Bool = false
    private var selectedIndexPath: IndexPath?
    private var typeOfResponse: TypeOfEpmtyShopsResponse
    
    private let router: UnownedRouter<ShopsRoute>
    private let repository: StoreRepositoryProtocol
    private var isChanged = false
    public var observerSearch: BehaviorSubject<String> = BehaviorSubject(value: "")
    private var searchTitle: String = ""
    var disposeBag = DisposeBag()
    
    init(router: UnownedRouter<ShopsRoute>, storeRepository: StoreRepositoryProtocol) {
        self.router = router
        self.repository = storeRepository
        self.searchStore = Box([])
        self.typeOfResponse = .empty
        observerSearch.asObservable()
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map{ (query) -> String in
                query.count >= 3 ? query : ""
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (searchText) in
                guard let self = self else { return }
                if searchText.isEmpty {
                    guard let fullStores = self.repository.fetchStores() else { return }
                    self.searchStore.value = fullStores
                } else {
                    print("on next \(searchText)")
                    self.searchTitle = searchText
                    self.searchShops(by: searchText, completion: { (store) in
                        guard let currentStore = store else { return }
                        self.searchStore.value = currentStore
                    })
                }
            }, onError: { (err) in
                    print(err.localizedDescription)
            },
                onCompleted: {
                    print("Completed")
            },
                onDisposed: {
                    print("Disposed")
            }).disposed(by: disposeBag)
    }
    
    func dispose() {
        observerSearch.dispose()
    }
    
    func showShopDetailPage(at index: Int) {
        router.trigger(.shopDetail(shop(at: index), .search))
    }
    
    func numberOfItems() -> Int {
        return searchStore.value.count
    }
    
    func setActivePaging(_ isPaging: Bool) {
        self.isPaging = isPaging
    }
    
    func getTypeOfResponse() -> TypeOfEpmtyShopsResponse {
        return typeOfResponse
    }
    
    func itemViewModel(at index: Int) -> StoreCardViewCellModelType? {
        guard searchStore.value.count > index else { return nil }
        let currentStore = searchStore.value[index]
        return StoreCardViewCellViewModel(store: currentStore)
    }
    
    func changeFavouriteStatus(index: Int, to like: Bool, completion: @escaping ((IndexPath?)->())) {
        let currentShop = searchStore.value[index]
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
        searchStore.value.first(where: { $0.id == changedStore.id })?.isFavorite = changedStore.isFavorite
        let index = searchStore.value.firstIndex(of: changedStore)
        isChanged = true
        return (index == nil) ? nil : IndexPath(row: index!, section: 0)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func updateSelectedItem() -> IndexPath? {
        return self.selectedIndexPath
    }
    
    func shop(at index: Int) -> Store {
        return self.searchStore.value[index]
    }
    
    func presentPage(completion: @escaping (((Int, Int)?) -> ())) {
        var size = 0
        var start = 0
        repository.searchStoresBy(text: searchTitle, offSet: searchStore.value.count) { [weak self] (stores) in
            guard let storePage = stores, let self = self else {
                completion(nil)
                return
            }
            start = self.searchStore.value.count
            size = storePage.count
            self.searchStore.value.append(contentsOf: storePage)
            completion((size, start))
        }
    }
    
    func searchShops(by title: String, completion: @escaping (([Store]?)->())) {
        typeOfResponse = .search
        repository.searchStoresBy(text: title) { (stores) in
            guard let currentShops = stores else {
                completion(nil)
                return
            }
            completion(currentShops)
        }
    }
    
}
