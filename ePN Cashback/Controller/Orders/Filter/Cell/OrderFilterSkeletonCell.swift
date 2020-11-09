//
//  OrderFilterSkeletonCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 18/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Skeleton

class OrderFilterSkeletonCell: UICollectionViewCell {
    
    @IBOutlet weak var skeletonView: GradientContainerView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skeletonView.clipsToBounds = true
        skeletonView.cornerRadius = CommonStyle.cornerRadius
        skeletonView.gradientLayer.colors = [UIColor.montreal.cgColor, UIColor.paris.cgColor, UIColor.montreal.cgColor]
        self.slide(to: .right)
    }
    
}

extension OrderFilterSkeletonCell: GradientsOwner {
  var gradientLayers: [CAGradientLayer] {
    return [skeletonView.gradientLayer]
  }
}
