//
//  StockCardCollectionViewCell.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 09/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class StockCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stockCard: EPNStockCard!
    
    var viewModel: StockViewCellModelType? {
        willSet(viewModel){
            guard let viewModel = viewModel else { return }
     
            let currency = viewModel.currencyOfGood()
            stockCard.setupStockName(name: viewModel.title)
            stockCard.setUpCostText(cost: "\(viewModel.costOfStock())\(currency)")
            stockCard.setUpCashbackText(firstTitle: "\(viewModel.cashbackTitle) ", secondTitle: "\(viewModel.cashback())\(currency)")
            stockCard.downloadLogoImageBy(link: viewModel.urlStringOfLogo())
            stockCard.downloadImageBy(link: viewModel.urlStringOfImage())
            stockCard.setupPercent(viewModel.percent())
        }
    }
}
