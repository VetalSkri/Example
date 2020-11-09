//
//  File.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 10/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let savePromocodePopUp = Notification.Name("savePromocodeFromPopUp")
    
    static let sendedCaptcha = Notification.Name("sendedCaptcha")
    static let changedMainStoreList = Notification.Name("mainStoreListNeedToUpdate")
    static let changedFavouriteStatusShop = Notification.Name("favouriteStatusOfShopHasBeenChanged")
    static let changedOrdersFilters = Notification.Name("filtersForOrders")
    static let dateRangeSelectedForDateFilters = Notification.Name("dateRangeSelectedForDateFilters")
    static let percentRangeSelectedForStockFilters = Notification.Name("percentRangeSelectedForStockFilters")
    static let categorySelectedForOfflineFilters = Notification.Name("categorySelectedForOfflineFilters")
    static let promocodeIsActivated = Notification.Name("promocodeIsActivated")
    static let multyReceiptQR = Notification.Name("multyReceiptQR")
    static let specialReceiptQR = Notification.Name("specialReceiptQR")
    static let detailPageReceiptQR = Notification.Name("detailPageReceiptQR")
    
    static let updateOrderFilter = Notification.Name("updateOrderFilter")
    static let updateOrderDateRangeFilter = Notification.Name("updateOrderDateRangeFilter")
}
