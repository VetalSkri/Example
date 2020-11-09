//
//  SearchOfflineModelType.swift
//  Backit
//
//  Created by Ivan Nikitin on 14/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchOfflineModelType {
    
    var getTextForEmptyPage: String { get }
    var getTitleForEmptyPage: String { get }
    
    var observerSearch: BehaviorSubject<String> { get set }
    var searchOfflineOffer: Box<[OfferOffline]> { get set }
    var disposeBag: DisposeBag { get }
    func getTypeOfResponse() -> TypeOfEpmtyShopsResponse
    func dispose()
    func goOnDetailPageForSelected(at item: Int)
    func numberOfItems() -> Int
    func itemViewModel(for index: Int) -> OfflineCBViewCellModelType?
    func searchOffline(by title: String, completion: @escaping (([OfferOffline]?)->()))
}

extension SearchOfflineModelType {
    var getTextForEmptyPage: String {
        return NSLocalizedString("No products have been found for this search. Redraft it.", comment: "")
    }
    
    var getTitleForEmptyPage: String {
        return NSLocalizedString("No products have been found", comment: "")
    }
    
}
