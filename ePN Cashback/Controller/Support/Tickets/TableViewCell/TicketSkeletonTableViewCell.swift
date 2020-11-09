//
//  TicketSkeletonTableViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Skeleton

class TicketSkeletonTableViewCell: UITableViewCell {

    @IBOutlet weak var skeletonView: GradientContainerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        backgroundColor = .clear
        view.backgroundColor = .clear
        selectionStyle = .none
        skeletonView.clipsToBounds = true
        skeletonView.backgroundColor = .paris
        skeletonView.gradientLayer.colors = [UIColor.montreal.cgColor, UIColor.paris.cgColor, UIColor.montreal.cgColor]
        self.slide(to: .right)
        skeletonView.cornerRadius = 5
    }
    
}

extension TicketSkeletonTableViewCell: GradientsOwner {
  var gradientLayers: [CAGradientLayer] {
    return [skeletonView.gradientLayer]
  }
}
