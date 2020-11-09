//
//  SearchShopsModelType.swift
//  Backit
//
//  Created by Ivan Nikitin on 23/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift
protocol SearchShopsModelType: ShopsFavoriteBehaviour, BaseShopsListModelType {
    var observerSearch: BehaviorSubject<String> { get set }
    var searchStore: Box<[Store]> { get set }
    func updateList(by changedStore: Store) -> IndexPath?
    func hasBeenChanged() -> Bool
    var disposeBag: DisposeBag { get }
    func getTypeOfResponse() -> TypeOfEpmtyShopsResponse
    func dispose()
}
