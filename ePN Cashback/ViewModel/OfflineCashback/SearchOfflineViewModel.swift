//
//  SearchOfflineViewModel.swift
//  Backit
//
//  Created by Ivan Nikitin on 14/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift

class SearchOfflineViewModel: SearchOfflineModelType {
    
    var searchOfflineOffer: Box<[OfferOffline]>
    var requestFailure: Bool = false
    private var selectedIndexPath: IndexPath?
    private var typeOfResponse: TypeOfEpmtyShopsResponse
    
    private let router: UnownedRouter<OfflineCBRoute>
    private let repository: ReceiptRepositoryProtocol
    public var observerSearch: BehaviorSubject<String> = BehaviorSubject(value: "")
    var disposeBag = DisposeBag()
    
    init(router: UnownedRouter<OfflineCBRoute>, offlineRepository: ReceiptRepositoryProtocol) {
        self.router = router
        self.repository = offlineRepository
        self.searchOfflineOffer = Box(repository.fetchOfflineOffers(byType: .offlineMulty) ?? [])
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
                guard let fullOfflineOffers = self.repository.fetchOfflineOffers(byType: .offlineMulty) else { return }
                self.searchOfflineOffer.value = fullOfflineOffers
            } else {
                print("on next \(searchText)")
                self.searchOffline(by: searchText, completion: { (store) in
                    guard let currentStore = store else { return }
                    self.searchOfflineOffer.value = currentStore
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
    
    func goOnDetailPageForSelected(at item: Int) {
        var offer: OfferOffline
        guard searchOfflineOffer.value.count > item else { return }
        offer = searchOfflineOffer.value[item]
        ///Send event to analytic about open scan from multyOffers
        Analytics.openEventDetailMultyOffer(title: offer.title)
        router.trigger(.detailPage(offer, .search))
    }
    
    func numberOfItems() -> Int {
        return searchOfflineOffer.value.count
    }
    
    
    func getTypeOfResponse() -> TypeOfEpmtyShopsResponse {
        return typeOfResponse
    }
    
    func itemViewModel(for index: Int) -> OfflineCBViewCellModelType? {
        guard searchOfflineOffer.value.count > index else { return nil }
        let currentOffline = searchOfflineOffer.value[index]
        return OfflineCBViewCellViewModel(offer: currentOffline)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func searchOffline(by title: String, completion: @escaping (([OfferOffline]?)->())) {
        typeOfResponse = .search
        repository.searchOfflineOfferBy(text: title) { (offers) in
            guard let currentOffline = offers else {
                completion(nil)
                return
            }
            completion(currentOffline)
        }
    }
}

