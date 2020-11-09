//
//  StockFilterHeaderCollectionView.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 10/06/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class StockFilterHeaderCollectionView: UICollectionReusableView {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryTitleButton: UIButton!
    
    weak var viewModel: StockCollectionViewHeaderViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            categoryTitleLabel.text = viewModel.titleSection
            categoryTitleLabel.textColor = .sydney
            categoryTitleLabel.font = .bold17
            categoryTitleButton.setTitle(viewModel.titleButton, for: .normal)
            categoryTitleButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            categoryTitleButton.setTitleColor(.minsk, for: .normal)
            categoryTitleButton.titleLabel?.font = UIFont.semibold17
        }
    }
}
