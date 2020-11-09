//
//  OfflineCashbackViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 26/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class ReceiptMainViewModel: OfflineCashbackModelType {
    
    private var multyOffers: [OfferOffline]
    private var typeOfResponse: TypeOfEpmtyOfflineOffersResponse?
    private var idOfShop: Int = LocalSymbolsAndAbbreviations.MULTY_OFFER_ID
    private let router: UnownedRouter<OfflineCBRoute>
    private let repository: ReceiptRepositoryProtocol
    private let keyNotification: Notification.Name = .multyReceiptQR
    fileprivate var categoriesFilter: CategoriesFilter
    private var isActiveSpecial: Bool
    private var previousValueOfFilter: Int
    private var isFirstLaunch: Bool = true
    
    init(router: UnownedRouter<OfflineCBRoute>, offlineRepository: ReceiptRepositoryProtocol) {
        self.repository = offlineRepository
        self.router = router
        self.multyOffers = repository.fetchOfflineOffers(byType: .offlineMulty) ?? []
        self.categoriesFilter = CategoriesFilter(category: repository.fetchCategories() ?? [])
        self.typeOfResponse = .empty
        self.isActiveSpecial = repository.getCountSpecialOfflineOffers() > 0 ? true : false
        self.previousValueOfFilter = categoriesFilter.categories.count
    }
    
    func getKeyNotificationName() -> Notification.Name {
        return keyNotification
    }
    
    var searchTitle: String {
        return NSLocalizedString("Products or store", comment: "")
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func getRouter() -> UnownedRouter<OfflineCBRoute> {
        return router
    }
    
    func getRepository() -> ReceiptRepositoryProtocol {
        return repository
    }

    func goOnSpecial() {
        router.trigger(.specialOffer)
    }
    
    func goOnShowResultSuccess() {
        router.trigger(.successScan)
    }
    
    func goOnShowResultError(errorMessage: String) {
        router.trigger(.errorScan(errorMessage))
    }
    
    func goOnFAQ() {
        router.trigger(.faq)
    }
    
    func enterManualy() {
        router.trigger(.manual(keyNotification))
    }
    
    func isActiveSpecialOffers() -> Bool {
        return isActiveSpecial
    }
    
    func goOnDetailPageForSelected(at item: Int) {
        var offer: OfferOffline
        guard multyOffers.count > item else { return }
        offer = multyOffers[item]
        ///Send event to analytic about open scan from multyOffers
        Analytics.openEventDetailMultyOffer(title: offer.title)
        router.trigger(.detailPage(offer, .main))
    }
    
    func getTypeOfResponse() -> TypeOfEpmtyOfflineOffersResponse {
        return typeOfResponse ?? .empty
    }
        
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return multyOffers.count > 0 ? multyOffers.count : 1
        default:
            return 0
        }
    }
    
    func filterHasBeenChanged() -> Bool {
        let isChanged = previousValueOfFilter == categoriesFilter.categories.count ? false : true
        previousValueOfFilter = categoriesFilter.categories.count
        let result = isChanged || isFirstLaunch
        isFirstLaunch = false
        return result
    }
    
    func numberOfItems() -> Int {
        return multyOffers.count
    }
    
    private func buildCategoryIds(parentId: Int) -> [Int] {
        var categoryIds = [Int]()
        categoryIds.append(parentId)
        if let childCategories = CoreDataStorageContext.shared.fetchTicketsCategories(by: parentId) {
            childCategories.forEach{ (childCategory) in
                categoryIds.append(contentsOf: buildCategoryIds(parentId: childCategory.id))
            }
        }
        return categoryIds
    }
    
    func presentOffersByFilter() {
        //1.check filter on selected
        typeOfResponse = .filter
        guard let category = categoriesFilter.selected.categorySelected, category != categoriesFilter.defaultCategory else {
            multyOffers.removeAll()
            multyOffers.append(contentsOf: repository.fetchOfflineOffers(byType: .offlineMulty) ?? [])
            return
        }
        //2.fetch categoryIds by selected filter - category
        let categoryIds = buildCategoryIds(parentId: category.id)
        
        //3.remove all Offers and append only fetched OfflineOffers by categoryIds ->
        multyOffers.removeAll()
        multyOffers.append(contentsOf: repository.presentOfflineOffersCategory(ids: categoryIds) ?? [])
    }
    
    func goOnScan() {
        ///Send event to analytic about open scan from multyOffers
        Analytics.openEventScanFromMultyOffers()
        router.trigger(.scan(keyNotification))
    }
    
    func cellViewModel(for index: Int) -> OfflineCBViewCellModelType? {
        let offer = multyOffers[index]
        return OfflineCBViewCellViewModel(offer: offer)
    }
    
    func displayResult(qrString qrCode: String, completion: @escaping (()->())) {
        repository.getResultOfCheck(idOffer: idOfShop, qrString: qrCode) { [weak self] (errorMessage) in
            completion()
            if errorMessage == nil {
                self?.goOnShowResultSuccess()
            } else {
                self?.goOnShowResultError(errorMessage: errorMessage!)
            }
        }
    }
    
    func headerViewModel() -> ReceiptMainHeaderViewModel? {
        return ReceiptMainHeaderViewModel(categories: categoriesFilter)
    }
        
    func countOfFilters() -> Int {
        return categoriesFilter.categories.count
    }
    
    func displayCategories(isForced: Bool, completion: (()->())?, failure: ((Int)->())?) {
        repository.presentCategories(isForced: isForced, completion: { [weak self] (categories) in
            self?.categoriesFilter.updateCategory(newCategory: categories)
            completion?()
        }) { (error) in
            failure?(error.code)
        }
    }
    
    func displayOffers(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        repository.presentMultyOfflineOffers(isForced: isForced, completion: { [weak self] (offers) in
            self?.multyOffers.removeAll()
            self?.multyOffers.append(contentsOf: offers)
            self?.isActiveSpecial = self?.repository.getCountSpecialOfflineOffers() ?? 0 > 0 ? true : false
            completion?()
        }) { (error) in
            failure?(error.code)
        }
    }

     
    func showHelp(fromFaq: Bool) {
        router.trigger(.showHelp(fromFaq, .multi))
    }
    
    func goToLanding() {
        router.trigger(.landing)
    }
    
}

public enum TypeOfEpmtyOfflineOffersResponse {
    case filter, empty
}

struct CategoryFilterSelection {
    var indexSelected: Int?
    var categorySelected: Categories?
}

public class CategoriesFilter {
    var categories: [Categories]
    var selected: CategoryFilterSelection
    
    let defaultCategory = Categories(id: -1,
                                     name: NSLocalizedString("All", comment: ""),
                                     tree: nil)
    private let defaultCategoryIndex = 0
    
    init(category: [Categories], selected: Int? = nil) {
        self.categories = [defaultCategory]
        self.categories.append(contentsOf: category)
        if let selectedIndex = selected, selectedIndex < categories.count {
            self.selected = CategoryFilterSelection(indexSelected: selected, categorySelected: categories[selectedIndex])
        } else {
            self.selected = CategoryFilterSelection(indexSelected: defaultCategoryIndex,
                                                    categorySelected: defaultCategory)
        }
    }
    
    func deselectFilter() {
        selected.indexSelected = defaultCategoryIndex
        selected.categorySelected = defaultCategory
    }
    
    func selectFilter(index: Int) {
        selected.indexSelected = index
        selected.categorySelected = categories[index]
    }
    
    func updateCategory(newCategory: [Categories]) {
        categories.removeAll()
        categories.append(defaultCategory)
        categories.append(contentsOf: newCategory)
        
        let index = newCategory.firstIndex{ $0.name == selected.categorySelected?.name }
        guard index != nil else {
            selected.indexSelected = defaultCategoryIndex
            selected.categorySelected = defaultCategory
            return
        }
        selected.indexSelected = index
    }
}
