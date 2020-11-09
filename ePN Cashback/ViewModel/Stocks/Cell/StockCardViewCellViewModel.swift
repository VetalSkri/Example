//
//  StockCardViewCellViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 09/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

class StockCardViewCellViewModel: StockViewCellModelType {
    
    internal var stock: Stocks
//    private var storage: StorableContext
    init(stocks currentStocks: Stocks) {
        self.stock = currentStocks
//        self.storage = storage
    }
    
    func urlStringOfLogo() -> String? {
        return CoreDataStorageContext.shared.fetchLogoUrlStringByOffer(id: self.stock.offer_id)
    }
    
    func urlStringOfImage() -> String? {
        return self.stock.image
    }
    
    func urlToOpen() -> URL? {
        return URL(string: self.stock.direct_url)
    }
    
    var costTitle: String {
        return NSLocalizedString("Price", comment: "")
    }
    
    var title: String {
        if Locale.current.languageCode == "ru" {
            return stock.title_ru
        } else {
            return stock.title
        }
    }
    
    func costOfStock() -> String {
        return String(format:"%.2f", self.stock.sale_price)
    }
    
    func percent() -> String {
        if self.stock.cashback_percent.checkIfWholeOrHalfNumber() {
            return "\(Int(self.stock.cashback_percent))%"
        } else {
            return "\(self.stock.cashback_percent)%"
        }
    }
    
    var cashbackTitle: String {
        return NSLocalizedString("Cashback", comment: "")
    }
    
    func cashback() -> String {
        return String(format:"%.2f", self.stock.cashback)
    }
    
    //FIXME: -HardCode until backend fix it
    func currencyOfGood() -> String {
        return LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: "USD")
    }
    
}
