//
//  PaymentBallanceCollectionViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class PaymentBallanceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setupCell(ballance: BalanceDataResponse, selected: Bool) {
        containerView.cornerRadius = CommonStyle.cornerRadius
        containerView.borderColor = selected ? .sydney : .montreal
        containerView.borderWidth = CommonStyle.borderWidth
        currencyLabel.font = .medium13
        currencyLabel.textColor = .sydney
        valueLabel.font = .bold17
        valueLabel.textColor = .sydney
        currencyLabel.text = "\(LocalSymbolsAndAbbreviations.getNameOfCurrency(value: ballance.id)),\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: ballance.id))"
        valueLabel.text = "\(ballance.attributes.availableAmount)\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: ballance.id))"
    }
    
}
