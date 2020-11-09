//
//  SkeletonHeaderView.swift
//  Backit
//
//  Created by Александр Кузьмин on 19/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import Skeleton

class SkeletonHeaderView: UIView {

    public var skeletonView: GradientContainerView
    
    override init(frame: CGRect) {
        self.skeletonView = GradientContainerView()
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        self.skeletonView = GradientContainerView()
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        skeletonView.clipsToBounds = true
        skeletonView.cornerRadius = CommonStyle.cardCornerRadius
        skeletonView.gradientLayer.colors = [UIColor.montreal.cgColor, UIColor.paris.cgColor, UIColor.montreal.cgColor]
        addSubview(skeletonView)
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        skeletonView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        skeletonView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        skeletonView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        slide(to: .right)
    }
}

extension SkeletonHeaderView: GradientsOwner {
  var gradientLayers: [CAGradientLayer] {
    return [skeletonView.gradientLayer]
  }
}
