//
//  PromocodeViewCell.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class PromocodeViewCell: UITableViewCell {
    
    @IBOutlet weak var titlePromocode: UILabel!
    @IBOutlet weak var timeLeftText: UILabel!
    @IBOutlet weak var gradientContentLabelView: UIView!
    @IBOutlet weak var backgroundContentView: UIView!
    
    var viewModel: PromocodeViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            self.backgroundColor = .zurich
            self.view.backgroundColor = .zurich
            
            titlePromocode.font = .semibold17
            titlePromocode.textColor = .sydney
            
            timeLeftText.font = .semibold13
            timeLeftText.textColor = .zurich
            
            backgroundContentView.borderColor = .montreal
            backgroundContentView.borderWidth = CommonStyle.borderWidth
            backgroundContentView.cornerRadius = CommonStyle.cornerRadius
            
            titlePromocode.text = viewModel.promocodeName()
            titlePromocode.numberOfLines = 1
            timeLeftText.text = viewModel.timeLeftPromocode()
            timeLeftText.numberOfLines = 1
            timeLeftText.backgroundColor = .clear
            gradientContentLabelView.layer.masksToBounds = true
            gradientContentLabelView.layer.cornerRadius = CommonStyle.cornerRadius
            gradientContentLabelView.backgroundColor = .clear
            backgroundContentView.backgroundColor = .zurich
            backgroundContentView.layer.masksToBounds = true
            backgroundContentView.layer.cornerRadius = CommonStyle.cornerRadius
            
            guard let type = viewModel.getTypeOfPromo() else {
                gradientContentLabelView.backgroundColor = .zurich
                return
            }
            switch type {
            case .red:
                gradientContentLabelView.backgroundColor = .prague
            case .orange:
                gradientContentLabelView.backgroundColor = .budapest
            case .green:
                gradientContentLabelView.backgroundColor = .budapest
            case .expired:
                gradientContentLabelView.backgroundColor = .minsk
            }
        }
    }
}
