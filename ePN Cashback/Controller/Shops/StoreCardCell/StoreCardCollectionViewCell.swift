//
//  MainStoreCardCollectionViewCell.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 30/11/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

class StoreCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeCard: EPNStoreCard!
       
    weak var viewModel: StoreCardViewCellModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            storeCard.style = .shop
            let title = viewModel.shopTitle()
            storeCard.setupStoreInfo(storeName:title.storeName, cashBack: title.maxRate ?? "", isMaxRatePretext: title.isMaxRatePretext)
            storeCard.setStatusOfLike(status: viewModel.getStatusOfLike() ? .favorite : .notFavorite )
            storeCard.downloadImageBy(link: viewModel.urlStringOfLogo())
        }
    }
}
