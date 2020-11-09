//
//  OrderFilterViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

import Foundation
import XCoordinator
import RxSwift
import RxRelay

class OrderFilterViewModel: NSObject {
    
    private let router: UnownedRouter<OrdersRoute>
    private let disposeBag = DisposeBag()
    let repository: OrderRepositoryProtocol = OrderRepository.shared
    var timeIntervals = BehaviorRelay<[TimeFilter]>(value: [])
    var offers = [OffersWithMyOrdersDataResponse]()
    var offersLoadState = BehaviorRelay<OffersLoadState>(value: .loading)
    var selectedOfferIds = [Int]()
    
    var selectedTimeIntervalIndex: Int
    let dateFormatter: DateFormatter
    var filter: OrderFilter!
    
    init(router: UnownedRouter<OrdersRoute>, filterObject: OrderFilter) {
        self.router = router
        self.filter = filterObject
        self.selectedTimeIntervalIndex = filterObject.timeType.rawValue
        self.selectedOfferIds = filterObject.offerIds
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeZone = .current
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        super.init()
        self.buildTimeIntervals()
        self.subscribeToNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeDateIntervalFilter(notification:)), name: .updateOrderDateRangeFilter, object: nil)
    }
    
    @objc private func changeDateIntervalFilter(notification: Notification) {
        guard let filterObject = notification.userInfo?["filterObject"] as? OrderFilter else { return }
        filter = filterObject
        selectedTimeIntervalIndex = (filter.timeType == OrderFilterTimeType.custom) ? 3 : 2
        buildTimeIntervals()
    }
    
    private func buildTimeIntervals() {
        var intervals = [TimeFilter]()
        let currentDate = Date()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? Date()
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? Date()
        let yearAgo = Calendar.current.date(byAdding: .day, value: -180, to: currentDate) ?? Date()
        intervals.append(TimeFilter(name: NSLocalizedString("per week", comment: ""), tsFrom: dateFormatter.string(from: weekAgo), tsTo: dateFormatter.string(from: currentDate)))
        intervals.append(TimeFilter(name: NSLocalizedString("per month", comment: ""), tsFrom: dateFormatter.string(from: monthAgo), tsTo: dateFormatter.string(from: currentDate)))
        intervals.append(TimeFilter(name: NSLocalizedString("for 180 days", comment: ""), tsFrom: dateFormatter.string(from: yearAgo), tsTo: dateFormatter.string(from: currentDate)))
        if filter.timeType == .custom, let tsFrom = filter.timeRange?.tsFrom, let tsTo = filter.timeRange?.tsTo {
            let dateRangeFormatter = DateFormatter()
            dateRangeFormatter.timeZone = .current
            dateRangeFormatter.locale = .current
            dateRangeFormatter.dateStyle = .medium
            dateRangeFormatter.dateFormat = "dd MMM"
            let rangeTimeFilter = TimeFilter(name: "\(dateRangeFormatter.string(from: dateFormatter.date(from: tsFrom) ?? Date())) - \(dateRangeFormatter.string(from: dateFormatter.date(from: tsTo) ?? Date()))", tsFrom: tsFrom, tsTo: tsTo)
            intervals.append(rangeTimeFilter)
        } else {
            intervals.append(TimeFilter(name: NSLocalizedString("Select Period", comment: ""), tsFrom: nil, tsTo: nil))
        }
        timeIntervals.accept(intervals)
    }
    
    func loadOffers() {
        offersLoadState.accept(.loading)
        _ = repository.getOfferByTransactions().subscribe { [weak self] (event) in
            guard let result = event.element else { return }
            switch result {
            case .success(let response):
                self?.offers = response
                self?.offersLoadState.accept(.loaded)
                break
            case .failure(let error):
                self?.offersLoadState.accept(.error)
                Alert.showErrorToast(by: error)
                break
            }
        }.disposed(by: disposeBag)
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func headTitle() -> String {
        return NSLocalizedString("Filter", comment: "")
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return timeIntervals.value.count
        }
        return (offersLoadState.value == OffersLoadState.loading) ? 3 : offers.count
    }
    
    func getFilterName(for indexPath: IndexPath) -> String {
        if indexPath.section == 0 && timeIntervals.value.count > indexPath.row {
            return timeIntervals.value[indexPath.row].name
        }
        if indexPath.section == 1 && offers.count > indexPath.row {
            return offers[indexPath.row].attributes.name
        }
        return ""
    }
    
    func filterIsSelected(for indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return indexPath.row == selectedTimeIntervalIndex
        }
        if indexPath.section == 1 && offers.count > indexPath.row {
            return selectedOfferIds.contains(offers[indexPath.row].id)
        }
        return false
    }
    
    func sectionTitle(_ section: Int) -> String {
        return section == 0 ? NSLocalizedString("Date", comment: "") : NSLocalizedString("Stores", comment: "")
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                router.trigger(.dateRangePicker(filterObject: filter))
                return
            }
            selectedTimeIntervalIndex = indexPath.row
        } else if indexPath.section == 1 && offers.count > indexPath.row {
            let selectedOfferId = offers[indexPath.row].id
            if selectedOfferIds.contains(selectedOfferId) {
                selectedOfferIds.removeAll(selectedOfferId)
            } else {
                selectedOfferIds.append(selectedOfferId)
            }
            
        }
    }
    
    func reset(section: Int) {
        if section == 0 {
            selectedTimeIntervalIndex = 2
        } else if section == 1 {
            selectedOfferIds.removeAll()
        }
    }
    
    func acceptFilter() {
        guard let tsFrom = timeIntervals.value[selectedTimeIntervalIndex].tsFrom, let tsTo = timeIntervals.value[selectedTimeIntervalIndex].tsTo else { return }
        filter.timeType = OrderFilterTimeType(rawValue: selectedTimeIntervalIndex) ?? OrderFilterTimeType.year
        filter.timeRange = OrderFilterTime(tsFrom: tsFrom, tsTo: tsTo)
        filter.offerIds = selectedOfferIds
        NotificationCenter.default.post(name: .updateOrderFilter, object: nil, userInfo: ["filterObject": filter ?? NSObject()])
        router.trigger(.back)
    }
    
}

struct TimeFilter {
    var name: String
    var tsFrom: String?
    var tsTo: String?
}

enum OffersLoadState {
    case loading
    case error
    case loaded
}
