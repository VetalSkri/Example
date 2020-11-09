//
//  StockFilterViewModel.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

class StockFilterViewModel: StockFilterModelType {

    private var filters : [StockFilterCategory]!
    private let router: UnownedRouter<PromotionsRoute>
    
    init(router: UnownedRouter<PromotionsRoute>, filters: [StockFilterCategory]) {
        self.router = router
        self.filters = filters
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func objectName(forIndexPath: IndexPath) -> String {
        return filters[forIndexPath.section].objects[forIndexPath.row].name
    }
    
    func numberOfSections() -> Int {
        return filters.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return filters[section].objects.count
    }
    
    func categoryName(section: Int) -> String {
        return filters[section].categoryName
    }
    
    func isSelectedItem(forIndexPath: IndexPath) -> Bool {
        return filters[forIndexPath.section].objects[forIndexPath.row].selected
    }
    
    func selectItem(atIndexPath: IndexPath) {
        if(atIndexPath.section == 1){
            for i in 0 ..< filters[atIndexPath.section].objects.count {
                filters[atIndexPath.section].objects[i].selected = false
            }
            filters[atIndexPath.section].objects[atIndexPath.row].selected = true
            return
        }
        
        if(filters[atIndexPath.section].objects.filter { $0.selected }.count<=1 && filters[atIndexPath.section].objects[atIndexPath.row].selected) {
            filters[atIndexPath.section].objects[0].selected = true
            if(atIndexPath.row == 0) {
                return
            }
        }
        else if(atIndexPath.row == 0){
            for i in 1 ..< filters[atIndexPath.section].objects.count {
                filters[atIndexPath.section].objects[i].selected = false
            }
        } else {
            filters[atIndexPath.section].objects[0].selected = false
        }
        
        filters[atIndexPath.section].objects[atIndexPath.row].selected = !filters[atIndexPath.section].objects[atIndexPath.row].selected
    }
    
    func sectionButtonTitle(section: Int) -> String {
        return filters[section].resetName
    }
    
    func header(forSection: Int) -> StockCollectionViewHeaderViewModel {
        return StockCollectionViewHeaderViewModel(name: self.categoryName(section: forSection), button: self.sectionButtonTitle(section: forSection))
    }
    
    func resetSection(section: Int) {
        for i in 1 ..< filters[section].objects.count {
            filters[section].objects[i].selected = false
        }
        filters[section].objects[0].selected = true
    }
    
    func getFilters() -> [StockFilterCategory] {
        return filters
    }
    
}

public struct StockFilterCategory {
    
    var categoryName : String
    var resetName: String
    var objects : [StockFilterObject]
    
    init(categoryName: String, resetName: String, objects: [StockFilterObject]) {
        self.categoryName = categoryName
        self.resetName = resetName
        self.objects = objects
    }
    
}

public struct StockFilterObject {
    
    var type : StockFilterObjectType
    var name : String
    var id : Int
    var selected : Bool
    
    init(type: StockFilterObjectType, name: String, id: Int, selected: Bool) {
        self.type = type
        self.name = name
        self.id = id
        self.selected = selected
    }
    
}

public enum StockFilterObjectType {
    case offer
    case product
}
