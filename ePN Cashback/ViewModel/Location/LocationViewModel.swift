//
//  LocationViewModel.swift
//  Backit
//
//  Created by Elina Batyrova on 13.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator
import RxSwift

enum LocationStep {
    case country
    case region(_ data: [LocationCellData])
    case city(_ data: [LocationCellData])
}

struct LocationData {
    var countryCode: String
    var regionCode: String?
    var cityID: Int?
    
    init(countryCode: String) {
        self.countryCode = countryCode
        self.regionCode = nil
        self.cityID = nil
    }
}

class LocationViewModel: LocationViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String {
        NSLocalizedString("Settings_Location", comment: "")
    }
    
    var backButtonTitle: String {
        NSLocalizedString("Back", comment: "")
    }
    
    var searchTextFieldPlaceholder: String {
        switch step {
        case .country:
            return NSLocalizedString("Settings_Country", comment: "")
            
        case .region:
            return NSLocalizedString("Settings_Region", comment: "")
            
        case .city:
            return NSLocalizedString("Settings_City", comment: "")
        }
    }
    
    var emptyStateViewTitle: String {
        NSLocalizedString("Nothing was found", comment: "")
    }
    
    var isLoading: Observable<Bool> {
        isLoadingSubject.asObserver()
    }
    
    var isEmptyData: Observable<Bool> {
        isEmptyDataSubject.asObserver()
    }
    
    var error: Observable<Error> {
        errorSubject.asObserver()
    }
    
    var tableData: Observable<[LocationCellData]> {
        tableDataSubject.asObserver()
    }
    
    // MARK: -
    
    private let router: UnownedRouter<ProfileRoute>
    private let repository: ProfileRepository
    private let step: LocationStep
    private var data: LocationData?
    
    private var isLoadingSubject = PublishSubject<Bool>()
    private var isEmptyDataSubject = PublishSubject<Bool>()
    private var tableDataSubject = PublishSubject<[LocationCellData]>()
    private var errorSubject = PublishSubject<Error>()
    
    private var tableFullData: [LocationCellData] = []
    
    // MARK: - Initializers
    
    init(router: UnownedRouter<ProfileRoute>, repository: ProfileRepository, step: LocationStep, data: LocationData? = nil) {
        self.router = router
        self.repository = repository
        self.step = step
        self.data = data
    }
    
    // MARK: - Instance Methods
    
    func loadData() {
        switch step {
        case .country:
            self.loadCountries()
            
        case .region(let data), .city(let data):
            self.tableFullData = data
            self.tableDataSubject.onNext(data)
        }
    }
    
    func goBack() {
        router.trigger(.back)
    }
    
    func didSelect(data: LocationCellData) {
        switch step {
        case .country:
            guard let countryData = data as? CountryData else {
                return
            }
            
            self.data = LocationData(countryCode: countryData.countryCode)
            
            self.loadRegions(completion: { regionData in
                if regionData.isEmpty {
                    self.configureNextStep()
                } else {
                    self.router.trigger(.location(step: .region(regionData), data: self.data))
                }
            })
            
        case .region:
            guard let regionData = data as? RegionData else {
                return
            }
            
            self.data?.regionCode = regionData.regionCode
            
            self.configureNextStep()
            
        case .city:
            guard let cityData = data as? CityData else {
                return
            }
            
            self.data?.cityID = cityData.cityID
            
            self.updateLocation()
        }
    }
    
    func searchData(text: String) {
        if text.isEmpty {
            tableDataSubject.onNext(self.tableFullData)
            
            isEmptyDataSubject.onNext(self.tableFullData.isEmpty)
        } else {
            let searchedData = self.tableFullData.filter({ $0.title.contains(text) })
            
            tableDataSubject.onNext(searchedData)
            
            isEmptyDataSubject.onNext(searchedData.isEmpty)
        }
    }
    
    // MARK: -
    
    private func configureNextStep() {
        self.loadCities(completion: { cityData in
            if cityData.isEmpty {
                self.updateLocation()
            } else {
                self.router.trigger(.location(step: .city(cityData), data: self.data))
            }
        })
    }
    
    private func loadCountries() {
        isLoadingSubject.onNext(true)
        
        repository.getCountries(completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success(let coutryData):
                self.tableFullData = coutryData
                self.tableDataSubject.onNext(coutryData)
                
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        })
    }
    
    private func loadRegions(completion: @escaping ((_ regionData: [RegionData]) -> Void)) {
        guard let code = self.data?.countryCode else {
            return
        }
        
        isLoadingSubject.onNext(true)
        
        repository.getRegions(countryCode: code, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success(let regionData):
                completion(regionData)
                
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        })
    }
    
    private func loadCities(completion: @escaping ((_ cityData: [CityData]) -> Void)) {
        guard let countryCode = self.data?.countryCode else {
            return
        }
        
        isLoadingSubject.onNext(true)
        
        repository.getCities(countryCode: countryCode, regionCode: self.data?.regionCode, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success(let cityData):
                completion(cityData)
                
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        })
    }
    
    private func updateLocation() {
        guard let countryCode = self.data?.countryCode else {
            return
        }
        
        isLoadingSubject.onNext(true)
        
        repository.updateLocation(countryCode: countryCode, regionCode: self.data?.regionCode, cityID: self.data?.cityID, completion: { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            self.isLoadingSubject.onNext(false)
            
            switch result {
            case .success:
                self.router.trigger(.backToEditProfile)
                
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        })
    }
}
