//
//  DateRangePickerViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 17/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class DateRangePickerViewModel {
    
    private let router: UnownedRouter<OrdersRoute>
    private var filter: OrderFilter
    let df = DateFormatter()
    
    init(router: UnownedRouter<OrdersRoute>, filter: OrderFilter) {
        self.router = router
        self.filter = filter
        self.df.dateFormat = "yyyy-MM-dd"
        self.df.timeZone = .current
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func headTitle() -> String {
        return NSLocalizedString("Filter", comment: "")
    }
    
    func apply(selectedDates dates: [Date]) {
        guard dates.count > 0 else {
            if filter.timeType == .custom {
                filter.timeType = .year
                let dateYearAgo = Calendar.current.date(byAdding: .day, value: -180, to: Date()) ?? Date()
                filter.timeRange = OrderFilterTime(tsFrom: df.string(from: dateYearAgo), tsTo: df.string(from: Date()))
                NotificationCenter.default.post(name: .updateOrderDateRangeFilter, object: nil, userInfo: ["filterObject": filter])
            }
            goOnBack()
            return
        }
        let stringDates = dates.map({ df.string(from: $0)})
        filter.timeType = .custom
        filter.timeRange = OrderFilterTime(tsFrom: stringDates.min()!, tsTo: stringDates.max()!)
        NotificationCenter.default.post(name: .updateOrderDateRangeFilter, object: nil, userInfo: ["filterObject": filter])
        goOnBack()
    }
    
    func getInitDateRange() -> (String, String)? {
        guard let tsFrom = filter.timeRange?.tsFrom, let tsTo = filter.timeRange?.tsTo, filter.timeType == .custom  else { return nil }
        return (tsFrom, tsTo)
    }
    
}
