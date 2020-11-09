//
//  PurseCountryInfoType.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import RxSwift
import RxCocoa

protocol PurseCountryInfoType {
    var loading: Observable<Bool> { get }
    var info: Observable<[CountryPurseInfoProtocol]> { get }
    var fieldsIsFull: Observable<Bool> { get }
    var titleLabel: Observable<String> { get }
    var bottomViewInfo: Observable<BottomViewDataType> { get }
    
    func pop()
    func loadData()
    func forward()
}
