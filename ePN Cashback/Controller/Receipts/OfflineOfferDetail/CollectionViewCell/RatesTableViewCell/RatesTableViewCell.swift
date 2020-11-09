//
//  RatesTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 10/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class RatesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rateContainerView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(rate: OfflineShopInfoRates, isMulti: Bool) {
        setupStyle()
        descriptionLabel.text = rate.description.withoutHtml
        rateLabel.text = "\(rate.newRate)"
        rateContainerView.backgroundColor = isMulti ? .budapest : .calgary
    }
    
    private func setupStyle() {
        containerView.backgroundColor = .clear
        rateContainerView.backgroundColor = .budapest
        circleView.backgroundColor = .paris
        descriptionLabel.font = .medium15
        descriptionLabel.textColor = .london
        rateLabel.font = .bold20
        rateLabel.textColor = .zurich
    }
}
