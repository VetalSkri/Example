//
//  AllCategoryViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 18/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class AllCategoryViewModel: AllCategoryModelType {
   
    private var categories: [(Categories, String)]!
//    private var selectedIndexPath: IndexPath?

    private let imageNameToCategoryIdMapping = [
        1 : "categoryAuto",
        127 : "categoryDomesticAppliances",
        219 : "categoryForOffice",
        256 : "categoryChildrensProducts",
        395 : "categoryHomeAndGarden",
        845 : "categoryLeisureAndEntertainment",
        1097 : "categoryComputerEquipment",
        1192 : "beauty",
        1320 : "categoryEquipment",
        1393 : "clothes",
        1655 : "categoryPresentsAndFlowers",
        1716 : "categoryProducts",
        1815 : "categorySportAndRecreation",
        1975 : "categoryServices",
        2001 : "electronics"
    ]
    
    private let router: UnownedRouter<ShopsRoute>
    private let repository: StoreRepositoryProtocol
    
    init(router: UnownedRouter<ShopsRoute>, storeRepository: StoreRepositoryProtocol) {
        self.router = router
        self.repository = storeRepository
        self.categories = [(Categories, String)]()
        if let categoryes = CoreDataStorageContext.shared.fetchShopsCategories(by: -1) {
            self.buildSourceArray(categoryes: categoryes)
        }
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnShops(atIndexPath indexPath: IndexPath) {
        let currentCategory = categories[indexPath.row].0
        router.trigger(.shopsCategory(currentCategory))
    }
    
    /**
     Try to get categoryes from cache if cache time is not expired, else load categoryes from API
     */
    func presentCategories(isForced: Bool = false, completion: (()->())?, failure: ((Int)->())?) {
        repository.presentCategories(isForced: isForced, completion: { [weak self] (allCategories) in
            self?.buildSourceArray(categoryes: allCategories)
            completion?()
        }) { (error) in
            failure?((error as NSError).code)
        }
    }
    //TODO: add functionality when you get shopsByCategiryIds
    
    private func buildSourceArray(categoryes: [Categories]) {
        self.categories.removeAll()
        for i in 0..<categoryes.count {
            let imageName = imageNameToCategoryIdMapping[categoryes[i].id]
            self.categories.append((categoryes[i], imageName ?? "allCategory"))
        }
    }
    
    func numberOfItems() -> Int {
        return categories.count
    }
    
    func category(for indexPath: IndexPath) -> (Categories, String) {
        return categories[indexPath.row]
    }
    
}
