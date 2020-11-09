//
//  OrdersXCoordinator.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 16/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

import XCoordinator

enum OrdersRoute: Route {
    case main
    case filter(filterObject: OrderFilter)
    case dateRangePicker(filterObject: OrderFilter)
    case orderDetail(transaction: OrdersDataResponse, image: String?, name: String?)
    case back
}

class OrdersXCoordinator: NavigationCoordinator<OrdersRoute> {
    
    // MARK: - Init
    
    init() {
        super.init(initialRoute: .main)
    }
    
    // MARK: - Overrides
    
    override func prepareTransition(for route: OrdersRoute) -> NavigationTransition {
        switch route {
        case .main:
            let ordersVC = OrdersVC.controllerFromStoryboard(.orders)
            ordersVC.viewModel = OrdersViewModel(router: unownedRouter)
            return .push(ordersVC)
        case .filter(let filterObject):
            let filterVC = OrderFilterVC.controllerFromStoryboard(.orders)
            filterVC.viewModel = OrderFilterViewModel(router: unownedRouter, filterObject: filterObject)
            return .push(filterVC)
        case .dateRangePicker(let filterObject):
            let dateRangePickerVC = DateRangePickerVC.controllerFromStoryboard(.orders)
            dateRangePickerVC.viewModel = DateRangePickerViewModel(router: unownedRouter, filter: filterObject)
            return .push(dateRangePickerVC)
        case .orderDetail(let transaction, let image, let name):
            let orderDetailVC = OrderDetailVC.controllerFromStoryboard(.orders)
            orderDetailVC.viewModel = OrderDetailViewModel(router: unownedRouter, transaction: transaction, image: image, name: name)
            return .push(orderDetailVC)
        case .back:
            return .pop()
        }
    }
}
