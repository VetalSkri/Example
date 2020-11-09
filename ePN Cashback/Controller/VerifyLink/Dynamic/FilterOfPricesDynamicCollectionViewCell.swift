//
//  FilterOfPricesDynamicCollectionViewCell.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 21/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class FilterOfPricesDynamicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filter: UILabel!
    
    override var isSelected: Bool {
        didSet{
            let model = viewModel as! FilterOfPricesDynamicViewCellViewModel
            changePercentFilterLayoutStatus(viewModel: model, active: isSelected)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var viewModel: FilterViewCellModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            viewModel.label.bind{ [unowned self] in
                guard let text = $0 else { return }
                self.filter.text = text
            }
            viewModel.label.value = viewModel.labelTitle()
            layer.cornerRadius = CommonStyle.cornerRadius
            layer.masksToBounds = true
            layer.borderColor = UIColor.sydney.cgColor
            layer.borderWidth = CommonStyle.borderWidth
            backgroundColor = .zurich
            filter.font = .medium15
        }
    }
    
    
    func changePercentFilterLayoutStatus(viewModel: FilterOfPricesDynamicViewCellViewModel, active isSelected: Bool) {
        if isSelected {
            filter.textColor = .zurich
            backgroundColor = .sydney
        } else {
            backgroundColor = .zurich
            filter.textColor = .sydney
        }
        layer.borderWidth = 1
    }
    
}
