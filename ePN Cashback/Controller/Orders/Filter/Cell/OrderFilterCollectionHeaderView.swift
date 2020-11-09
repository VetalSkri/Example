//
//  OrderFilterCollectionHeaderView.swift
//  Backit
//
//  Created by Александр Кузьмин on 12/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class OrderFilterCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    func setupView(title: String) {
        sectionTitleLabel.text = title
        sectionTitleLabel.textColor = .sydney
        sectionTitleLabel.font = .bold17
        resetButton.setTitle(NSLocalizedString("Reset", comment: ""), for: .normal)
        resetButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        resetButton.setTitleColor(.minsk, for: .normal)
        resetButton.titleLabel?.font = UIFont.semibold17
    }
    
}
