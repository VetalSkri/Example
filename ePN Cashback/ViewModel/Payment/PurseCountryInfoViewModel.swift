//
//  PurseCountryInfoViewModel.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//
import Foundation
import XCoordinator
import RxSwift
import RxCocoa

struct PurseCountryInfoViewModel: PurseCountryInfoType  {
    
    private let router: UnownedRouter<PaymentsRoute>
    private let loadingSubject = PublishSubject<Bool>()
    private let infoSubject = PublishSubject<[CountryPurseInfoProtocol]>()
    private let titleLabelSubject = PublishSubject<String>()
    private let bottomViewInfoSubject = PublishSubject<BottomViewDataType>()
    private let fieldsIsFullSubject = PublishSubject<Bool>()
    
    var loading: Observable<Bool> {
        return loadingSubject.asObserver()
    }
    var info: Observable<[CountryPurseInfoProtocol]> {
        return infoSubject.asObserver()
    }
    var titleLabel: Observable<String> {
        return titleLabelSubject.asObserver()
    }

    var fieldsIsFull: Observable<Bool> {
        return fieldsIsFullSubject.asObserver()
    }
    
    var bottomViewInfo: Observable<BottomViewDataType> {
        return bottomViewInfoSubject.asObserver()
    }
    
    private let partSelected : Double
    private var country: SearchGeoDataResponse?
    private var regionOrCity: SearchGeoDataResponse?
    private let currentPurseType: PaymentInfoData
    
    init(router: UnownedRouter<PaymentsRoute>,country: SearchGeoDataResponse?, regionOrCity: SearchGeoDataResponse?, partSelected: Double,
        currentPurseType: PaymentInfoData) {
        self.partSelected = partSelected
        self.router = router
        self.country = country
        self.regionOrCity = regionOrCity
        self.currentPurseType = currentPurseType
    }
    
    func loadData() {
        checkCountry()
        fieldsIsFullSubject.onNext(true)
    }
    
    func pop() {
        router.trigger(.back)
    }
    
    func forward() {
        router.trigger(.newPurseDataOfCard(partSelected: 2, isDataOfClien: false, currentPurse: currentPurseType, dataOfNewPurse: DataOfNewPurse(country: country, city: regionOrCity)))
    }
    
    private func checkCountry() {
        
        var infoAboutAmount = ""
        currentPurseType.attributes.info?.forEach{ elem in
            if elem.min.checkWholeNumber() {
                infoAboutAmount += "\(Int(elem.min)) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: elem.currency))" + ", "
            } else {
                infoAboutAmount += "\(elem.min) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: elem.currency))" + ", "
            }
        }
        
        guard let country = country, let countryCode = country.attributes?.countryCode else {
            
            switch currentPurseType.purseType {
                case .cardUrkV2:
                    infoSubject.onNext([CountryPurseInfo(title: NSLocalizedString("Minimum amount", comment: ""), info: NSLocalizedString("Minimum one-time payment", comment: "") + infoAboutAmount + NSLocalizedString("Maximum one-time payment Ukraine V2", comment: ""), logo: .minAmount),CountryPurseInfo(title: NSLocalizedString("Term for transferring funds", comment: ""), info: NSLocalizedString("Term for transferring funds Info Ukrain V2", comment: ""), logo: .time)])
                    
                    bottomViewInfoSubject.onNext(BottomViewData(part: 2, partSelected: partSelected, dismiss:
                        false))
                    titleLabelSubject.onNext(self.currentPurseType.attributes.name)
            default: break
            }
            return
        }
                
        
        titleLabelSubject.onNext(country.attributes?.name ?? "")
        
        switch CountryType(rawValue: countryCode) {
        case .ru:
            infoAboutAmount = ""
            currentPurseType.attributes.info?.forEach{ elem in
                if elem.min.checkWholeNumber() {
                    infoAboutAmount += "\(Int(elem.min)) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: elem.currency))" + ", "
                } else {
                    infoAboutAmount += "\(elem.min) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: elem.currency))" + ", "
                }
            }
            infoAboutAmount.removeLast()
            infoAboutAmount.removeLast()
            infoAboutAmount += "."
            infoSubject.onNext([CountryPurseInfo(title: NSLocalizedString("Minimum amount", comment: ""), info: NSLocalizedString("Minimum one-time payment", comment: "") + infoAboutAmount, logo: .minAmount),CountryPurseInfo(title: NSLocalizedString("Term for transferring funds", comment: ""), info: NSLocalizedString("Term for transferring funds Info", comment: ""), logo: .time)])
            bottomViewInfoSubject.onNext(BottomViewData(part: 2, partSelected: partSelected, dismiss: false))
        case .ua:
            infoSubject.onNext([CountryPurseInfo(title: NSLocalizedString("Minimum amount", comment: ""), info: NSLocalizedString("Minimum one-time payment", comment: "") + infoAboutAmount + NSLocalizedString("Maximum one-time payment", comment: ""), logo: .minAmount), CountryPurseInfo(title: NSLocalizedString("Term for transferring funds", comment: ""), info: NSLocalizedString("Term for transferring funds Info", comment: ""), logo: .time)])
            bottomViewInfoSubject.onNext(BottomViewData(part: 3, partSelected: partSelected, dismiss: false))
        default:
            infoSubject.onNext([CountryPurseInfo(title: NSLocalizedString("Minimum amount", comment: ""), info: NSLocalizedString("Minimum one-time payment", comment: "") + infoAboutAmount + NSLocalizedString("Maximum one-time payment", comment: ""), logo: .minAmount), CountryPurseInfo(title: NSLocalizedString("Term for transferring funds", comment: ""), info: NSLocalizedString("Term for transferring funds Info", comment: ""), logo: .time)])
            bottomViewInfoSubject.onNext(BottomViewData(part: 3, partSelected: partSelected, dismiss: false))
        }
    }
}

