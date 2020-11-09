//
//  SpecialReceiptTableHeaderView.swift
//  Backit
//
//  Created by Ivan Nikitin on 05/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SpecialReceiptTableHeaderView: UIView {

    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
 
    func setupView() {
        backgroundColor = .zurich
//        mainContainerView.backgroundColor = .mainBg
//        mainContainerView.cornerRadius = CommonStyle.newCornerRadius
//        mainContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        mainContainerView.layer.shadowColor = UIColor.shadowNew.cgColor
//        mainContainerView.layer.shadowOpacity = 1
//        mainContainerView.layer.shadowRadius = 10
//        mainContainerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        headerView.backgroundColor = .toronto
        headerView.cornerRadius = 5
        
        endDateLabel.font = .semibold13
        endDateLabel.textColor = .zurich
        endDateLabel.text = "\(NSLocalizedString("until", comment: "")) \(RemoteCfg.shared.endLotteryDateString())"
        
        mainTitleLabel.font = .bold20
        mainTitleLabel.textColor = .zurich
        mainTitleLabel.text = NSLocalizedString("Win up to 100% cashback for any receipt", comment: "")
    }
    
    func setHidden(hide: Bool) {
        containerHeightConstraint.constant = hide ? 0 : 150
    }
    
    func updateDate() {
        endDateLabel.text = "\(NSLocalizedString("until", comment: "")) \(RemoteCfg.shared.endLotteryDateString())"
    }
}
