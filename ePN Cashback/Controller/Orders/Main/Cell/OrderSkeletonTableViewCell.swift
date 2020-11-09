//
//  OrderSkeletonTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 19/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Skeleton

class OrderSkeletonTableViewCell: UITableViewCell {

    @IBOutlet weak var skeletonView: GradientContainerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        selectionStyle = .none
        skeletonView.clipsToBounds = true
        skeletonView.cornerRadius = CommonStyle.cardCornerRadius
        skeletonView.gradientLayer.colors = [UIColor.montreal.cgColor, UIColor.paris.cgColor, UIColor.montreal.cgColor]
        self.slide(to: .right)
    }
    
}

extension OrderSkeletonTableViewCell: GradientsOwner {
  var gradientLayers: [CAGradientLayer] {
    return [skeletonView.gradientLayer]
  }
}
