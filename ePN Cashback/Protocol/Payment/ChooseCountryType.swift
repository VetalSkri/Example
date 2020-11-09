//
//  ChooseCountryType.swift
//  Backit
//
//  Created by Виталий Скриганюк on 25.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ChooseCountryType {
    var country: Observable<[SearchGeoDataResponse]> { get }
    var loading: Observable<Bool> { get }
    var isEmptyResponse: Observable<Bool> { get }
    var showAlert: Observable<Error> { get }
    var selectViewType: SelectViewType { get }
    
    func loadData()
    func searchCountry(searchName: String)
    func selected(geo:SearchGeoDataResponse)
    func pop()
}

