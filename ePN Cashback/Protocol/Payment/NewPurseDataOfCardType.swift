//
//  NewPurseDataOfCardType.swift
//  Backit
//
//  Created by Виталий Скриганюк on 27.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import RxSwift
import RxCocoa

protocol NewPurseDataOfCardType: ViewModelProtocol {
    var loading: Observable<Bool> { get }
    var fieldsIsFull: Observable<Bool> { get }
    var recipentData: Observable<[RecipientDataCell]> { get }
    var titleLabel: Observable<String> { get }
    var bottomViewInfo: Observable<BottomViewDataType> { get }
    var isLogoNeded: Observable<Bool> { get }
    var isProgressOn: Observable<Bool> { get }
    var singleLogo: Observable<PurseType> { get }
    var showAlert: Observable<Error> { get }
    
    
    func pop()
    func loadData()
    func forward()
    func getCounty()
    func unableDisableButton()
    func setGeo(type: SearchType, geo: SearchGeoDataResponse)
    func checkFields(value: String, type: RecipientData) -> Bool
    func setFields(value: String, recipient: RecipientData) 
}
