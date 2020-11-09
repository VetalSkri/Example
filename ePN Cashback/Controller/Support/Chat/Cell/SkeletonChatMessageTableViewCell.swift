//
//  SkeletonChatMessageTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 05/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Skeleton

class SkeletonChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: GradientContainerView!
    @IBOutlet weak var containerViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(row: Int) {
        backgroundColor = .clear
        
        containerView.cornerRadius = CommonStyle.newCornerRadius
        containerView.clipsToBounds = true
        if row == 0 || row == 1 || row == 4 {
            containerViewLeftConstraint.constant = UIScreen.main.bounds.width / 7.5
            containerViewRightConstraint.constant = 16
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            containerViewLeftConstraint.constant = 16
            containerViewRightConstraint.constant = UIScreen.main.bounds.width / 5
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
        containerViewHeightConstraint.constant = heightForRow(row: row)
        containerView.backgroundColor = .paris
        containerView.gradientLayer.colors = [UIColor.montreal.cgColor, UIColor.paris.cgColor, UIColor.montreal.cgColor]
        self.slide(to: .right)
    }
    
    private func heightForRow(row: Int) -> CGFloat {
        switch row {
        case 0:
            return 88
        case 1:
            return 77
        case 2:
            return 96
        case 3:
            return 55
        case 4:
            return 88
        default:
            return 88
        }
    }
    
}


extension SkeletonChatMessageTableViewCell: GradientsOwner {
  var gradientLayers: [CAGradientLayer] {
    return [containerView.gradientLayer]
  }
}
