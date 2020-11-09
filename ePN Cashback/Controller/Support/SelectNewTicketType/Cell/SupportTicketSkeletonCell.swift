//
//  SupportTicketSkeletonCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 23/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Skeleton

class SupportTicketSkeletonCell: UITableViewCell {

    @IBOutlet weak var containerViiew: GradientContainerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        backgroundColor = .clear
        view.backgroundColor = .clear
        selectionStyle = .none
        containerViiew.clipsToBounds = true
        containerViiew.cornerRadius = 10
        containerViiew.backgroundColor = .paris
        containerViiew.gradientLayer.colors = [UIColor.montreal.cgColor, UIColor.paris.cgColor, UIColor.montreal.cgColor]
        self.slide(to: .right)
    }
}

extension SupportTicketSkeletonCell: GradientsOwner {
  var gradientLayers: [CAGradientLayer] {
    return [containerViiew.gradientLayer]
  }
}
