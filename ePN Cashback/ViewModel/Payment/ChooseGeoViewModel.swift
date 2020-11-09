//
//  ChooseCountry.swift
//  Backit
//
//  Created by Виталий Скриганюк on 25.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift
import RxCocoa

struct ChooseGeoViewModel: ChooseCountryType {
    
    private let router: UnownedRouter<PaymentsRoute>
    
    private let countryBehaviorSubject = BehaviorRelay<[SearchGeoDataResponse]>(value: [])
    private let countrySubject = PublishSubject<[SearchGeoDataResponse]>()
    private let loadingSubject = PublishSubject<Bool>()
    private let countries: [SearchGeoDataResponse] = []
    private let isEmptyResponseSubject = PublishSubject<Bool>()
    private let showAlertSubject = PublishSubject<Error>()
    
    var country: Observable<[SearchGeoDataResponse]> {
        return countrySubject.asObserver()
    }
    var loading: Observable<Bool> {
        return loadingSubject.asObserver()
    }
    var isEmptyResponse: Observable<Bool> {
        return isEmptyResponseSubject.asObserver()
    }
    var showAlert: Observable<Error> {
        return showAlertSubject.asObserver()
    }
    
    var selectedCountry: SearchGeoDataResponse? = nil
    let selectViewType: SelectViewType
    private var purseTypes: [PaymentInfoData]
    private var currentPurseType: PaymentInfoData? = nil
    private var isBackVM: ViewModelProtocol? = nil
    
    var ignoreCountries = ["US","AS","ET","GU","GY","IR","IQ","KP","LA","LY"
,"ML","MR","MP","PK","RS","SO","LK","SD","SY","TT","TN","UG"
,"VU","YE","AF"]
    
    init(router: UnownedRouter<PaymentsRoute>, selectViewType: SelectViewType, selectedCountry: SearchGeoDataResponse? = nil, purseTypes: [PaymentInfoData],currentPurseType: PaymentInfoData? = nil, isBackVM: ViewModelProtocol? = nil) {
        self.router = router
        self.selectedCountry = selectedCountry
        self.selectViewType = selectViewType
        self.purseTypes = purseTypes
        self.currentPurseType = currentPurseType
        self.isBackVM = isBackVM
    }
    
    private func hundlerResponse(geo: SearchGeoResponse ) -> [SearchGeoDataResponse] {

        var priorityGeo:[SearchGeoDataResponse] = []
        
        var currentData = geo.data.filter{
            guard let name = $0.attributes?.name, let code = $0.attributes?.countryCode else { return false }
            if self.isBackVM == nil {
                if self.ignoreCountries.contains(code) {
                    return false
                }
            }
            if code == "UA" || code == "RU" {
                priorityGeo.append($0)
                return false
            }
            return true
        }
        
        priorityGeo.enumerated().forEach{index, elem in
            currentData.insert(elem, at: index)
        }
        
        return currentData
    }
    
    private func loadCountries() {
        loadingSubject.onNext(true)
        switch selectViewType.searchType {
        case .country:
            PaymentApiClient.getCountries { (result) in
                switch result {
                case .success(let contryResponse):
                    let validCountry = self.hundlerResponse(geo: contryResponse)

                    self.isEmptyResponseSubject.onNext(validCountry.isEmpty)
                    self.loadingSubject.onNext(false)
                    self.countrySubject.onNext(validCountry)
                    self.countryBehaviorSubject.accept(validCountry)
                    break
                case .failure(let error):
                    self.showAlertSubject.onNext(error)
                    self.loadingSubject.onNext(false)
                    break
                }
            }
        case .city:
            PaymentApiClient.getCities(search: "", countryCode: selectedCountry?.attributes?.countryCode ?? "") { (result) in
                switch result {
                case .success(let contryResponse):
                    self.isEmptyResponseSubject.onNext(contryResponse.data.isEmpty)
                    self.countrySubject.onNext(contryResponse.data)
                    self.countryBehaviorSubject.accept(contryResponse.data)
                    self.loadingSubject.onNext(false)
                    break
                case .failure(let error):
                    self.showAlertSubject.onNext(error)
                    self.loadingSubject.onNext(false)
                    break
                }
            }
        }
    }
    
    func loadData() {
        loadCountries()
    }
    
    func pop() {
        router.trigger(.back)
    }
    
    func selected(geo:SearchGeoDataResponse) {
        if isBackVM != nil {
            (isBackVM as? NewPurseDataOfCardType)?.setGeo(type: .country, geo: geo)
            router.trigger(.back)
        } else {
        switch selectViewType.searchType {
        case .country:
            var currentPurse: [PaymentInfoData] = []
            switch CountryType(rawValue: geo.attributes!.countryCode!) {
            case .ru: currentPurse = purseTypes.filter{
                $0.purseType == PurseType.cardpay
                }
            router.trigger(.purseCountryInfo(selectCountry: geo, selectRegion: geo, partSelected: 1, purses: currentPurse.first!))
            case .ua: currentPurse = purseTypes.filter{
                $0.purseType == PurseType.cardUrk
                }
                router.trigger(.chooseCity(country: geo, purses: purseTypes, currentPurseType: currentPurse.first!))
            default:
                currentPurse = purseTypes.filter{
                    $0.purseType == PurseType.cardpayUsd
                }
                router.trigger(.chooseCity(country: geo, purses: purseTypes, currentPurseType: currentPurse.first!))
            }
        case .city:
            router.trigger(.purseCountryInfo(selectCountry: selectedCountry!, selectRegion: geo, partSelected: 1, purses: currentPurseType!))
        }
        }
    }
    
    func searchCountry(searchName: String) {
        var searchRequest = searchName
        if searchRequest.last == " " {
            searchRequest.removeLast()
        }
        if !searchName.isEmpty {
            let result = countryBehaviorSubject.value.filter{
                guard let name = $0.attributes?.name else { return false }
                if name.containsIgnoringCase(find: searchRequest) {
                    return true
                } else {
                    return false
                }
            }
            isEmptyResponseSubject.onNext(result.isEmpty)
            countrySubject.onNext(result)
        } else {
            isEmptyResponseSubject.onNext(false)
            countrySubject.onNext(countryBehaviorSubject.value)
        }
    }
}

