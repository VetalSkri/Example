//
//  ShopsListModelType.swift
//  Backit
//
//  Created by Ivan Nikitin on 28/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol ShopsListModelType: BaseShopsListModelType {
    
    var alphaSortTitle: String { get }
    var newSortTitle: String { get }
    var prioritySortTitle: String { get }

    func goOnBack()
    func getSorting() -> StatusOfSort
    func changeSorting(_ sort: StatusOfSort)
    func showTitle() -> String
    
    func getTypeOfResponse() -> TypeOfEpmtyShopsResponse
}

extension ShopsListModelType {
    var alphaSortTitle: String {
        return NSLocalizedString("By alphabet", comment: "")
    }
    
    var newSortTitle: String {
        return NSLocalizedString("By newness", comment: "")
    }
    
    var prioritySortTitle: String {
        return NSLocalizedString("By popularity", comment: "")
    }
    

}
