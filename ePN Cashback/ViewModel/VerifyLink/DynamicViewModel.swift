//
//  DynamicViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 25/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class DynamicViewModel: RedirectLinkProtocol {
    
    private var link: String
    private var offerLinkInfo: OfferLinkInfo
    private var priceDynamics: PriceDynamicsResponse
    private var selectedIndexPath: IndexPath?
    private var filter:[DynamicFilter]
    private var maxValuePrice: Double
    private var minValuePrice: Double
    private var currentValuePrice: Double?
    private var mobileUrlString: OfferLinkInfo?
    private var oldTappedFilterIndex : Int
    
    private let router: UnownedRouter<VerifyLinkRoute>
    
    init(router: UnownedRouter<VerifyLinkRoute>, link: String, priceDynamics: PriceDynamicsResponse, offerLinkInfo: OfferLinkInfo) {
        self.router = router
        self.link = link
        self.offerLinkInfo = offerLinkInfo
        self.priceDynamics = priceDynamics
        self.filter = [DynamicFilter]()
        self.maxValuePrice = priceDynamics.meta.maxPrice
        self.minValuePrice = priceDynamics.meta.minPrice
        self.currentValuePrice = priceDynamics.data.last?.attributes.price
        self.oldTappedFilterIndex = 0
        initDefaultFilter()
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnInfoMessage() {
        PriceDynamicsAnalytics.faqClicked()
        router.trigger(.infoMessage)
    }
    
    func listOfPrices() -> [CostOfGoods] {
        return priceDynamics.data.map{ $0.attributes }
    }
    
    func minValue() -> Double {
        return minValuePrice
    }
    
    func currentValue() -> Double? {
        return currentValuePrice
    }
    
    func maxValue() -> Double {
        return maxValuePrice
    }
    
    func redirectLink() -> String {
        return offerLinkInfo.redirectUrl
    }
    
    func changeMinMaxValue() {
        guard let currentValue = currentValuePrice else { return }
        minValuePrice = currentValue
        maxValuePrice = currentValue
    }
    
    func changeListOfPricesByError(for period: String) {
        self.priceDynamics.data.removeAll()
        guard let currentPrice = self.currentValuePrice else { return }
        changeMinMaxValue()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentPriceDynamicResponce = PriceDynamicsDataResponse(type: "priceDynamics", id: 0, attributes: CostOfGoods(date: dateFormatter.string(from: currentDate), price: currentPrice))
        switch period {
        case "two_months":
            guard let twoMonthAgoDate = Calendar.current.date(byAdding: .month, value: -2, to: Date()) else { return }
            let twoMonthAgoPriceDynamicResponce = PriceDynamicsDataResponse(type: "priceDynamics", id: 0, attributes: CostOfGoods(date: dateFormatter.string(from: twoMonthAgoDate), price: currentPrice))
            self.priceDynamics.data = [currentPriceDynamicResponce, twoMonthAgoPriceDynamicResponce]
        case "month":
            guard let oneMonthAgoDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return }
            let oneMonthAgoPriceDynamicResponce = PriceDynamicsDataResponse(type: "priceDynamics", id: 0, attributes: CostOfGoods(date: dateFormatter.string(from: oneMonthAgoDate), price: currentPrice))
            self.priceDynamics.data = [currentPriceDynamicResponce, oneMonthAgoPriceDynamicResponce]
        case "two_weeks":
            guard let twoWeeksAgoDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date()) else { return }
            let twoWeeksAgoPriceDynamicResponce = PriceDynamicsDataResponse(type: "priceDynamics", id: 0, attributes: CostOfGoods(date: dateFormatter.string(from: twoWeeksAgoDate), price: currentPrice))
            self.priceDynamics.data = [currentPriceDynamicResponce, twoWeeksAgoPriceDynamicResponce]
        case "week":
            guard let oneWeeksAgoDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else { return }
            let oneWeeksAgoPriceDynamicResponce = PriceDynamicsDataResponse(type: "priceDynamics", id: 0, attributes: CostOfGoods(date: dateFormatter.string(from: oneWeeksAgoDate), price: currentPrice))
            self.priceDynamics.data = [currentPriceDynamicResponce, oneWeeksAgoPriceDynamicResponce]
        default:
            print("default")
        }
    }
    
    func openStore(completion: @escaping ((URL)->())) {
        PriceDynamicsAnalytics.buyWithCashbackClicked(fromPriceDynamics: true)
        checkLinkForMobileApp(offerLinkInfo) { (urlLink) in
                completion(urlLink)
            }
    }
    
    func getOldFilterIndex() -> Int {
        return oldTappedFilterIndex
    }
    
    func priceDynamics(completion: (()->())?, failure: (()->())?) {
        guard let period = filter.first(where: { $0.tapped }) else { return }
        VerifyLinkApiClient.priceDynamics(link: link, period: period.period) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.priceDynamics = response
                self?.maxValuePrice = response.meta.maxPrice
                self?.minValuePrice = response.meta.minPrice
                self?.currentValuePrice = response.data.last?.attributes.price
                completion?()
                break
            case .failure(let error):
                self?.rollbackFilter()
                failure?()
                Alert.showErrorAlert(by: error)
                break
            }
        }
    }
    
    private func rollbackFilter() {
        filter.forEach({ (filter) in
            filter.tapped = false
        })
        filter[oldTappedFilterIndex].tapped = true
    }
    
    var priceTodayLabel: String {
        return NSLocalizedString("Price today", comment: "")
    }
    
    var infoText: String {
        return NSLocalizedString("DynamicInfo", comment: "")
    }
    
    func priceToday() -> String {
        guard let currentPrice = currentValuePrice else { return "" }
        return "\(currentPrice) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: priceDynamics.meta.currency))"
    }
    
    func currency() -> String {
        return LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: priceDynamics.meta.currency)
    }
    
    var minPriceLabel: String {
        return NSLocalizedString("MinPrice", comment: "")
    }
    
    func minPrice() -> String {
        return "\(priceDynamics.meta.minPrice) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: priceDynamics.meta.currency))"
    }
    
    var maxPriceLabel: String {
        return NSLocalizedString("MaxPrice", comment: "")
    }
    
    func maxPrice() -> String {
        return "\(priceDynamics.meta.maxPrice) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: priceDynamics.meta.currency))"
    }
    
    var buttonInfoText: String {
        return NSLocalizedString("Buy with cashback", comment: "")
    }
    
    func numberOfFilterItems() -> Int {
        return filter.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> FilterViewCellModelType? {
        let currentFilter = filter[indexPath.row]
        return FilterOfPricesDynamicViewCellViewModel(filter: currentFilter)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func filterCellViewModel(index: Int) -> FilterViewCellModelType {
        let currentFilter = filter[index]
        return FilterOfPricesDynamicViewCellViewModel(filter: currentFilter)
    }
    
    func initDefaultFilter() {
        let twoMonths = DynamicFilter(id: 0, period: "two_months", name: NSLocalizedString("dynamic_two_months", comment: ""), tapped: true)
        let month = DynamicFilter(id: 1, period: "month", name: NSLocalizedString("dynamic_month", comment: ""))
        let twoWeeks = DynamicFilter(id: 2, period: "two_weeks", name: NSLocalizedString("dynamic_two_weeks", comment: ""))
        let week = DynamicFilter(id: 3, period: "week", name: NSLocalizedString("dynamic_week", comment: ""))
        filter.append(twoMonths)
        filter.append(month)
        filter.append(twoWeeks)
        filter.append(week)
    }
    
    func switchOffTapped(indexPath index: IndexPath) {
        if(filter[index.row].tapped) {
            oldTappedFilterIndex = index.row
        }
        filter[index.row].tapped = false
    }
    
    func switchOnTapped(indexPath index: IndexPath) {
        filter[index.row].tapped = true
    }
    
    func getSelectedFilterIndex () -> Int? {
        return filter.firstIndex(where: { $0.tapped })
    }
}

public class DynamicFilter {
    var id: Int
    var period: String
    var name: String
    var tapped: Bool
    
    init(id: Int, period: String, name: String, tapped: Bool = false) {
        self.id = id
        self.period = period
        self.name = name
        self.tapped = tapped
    }
}
