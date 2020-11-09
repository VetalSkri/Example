//
//  EPNLoadingFooterView.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 28/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

final class EPNLoadingFooterView : UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let activiryIndicator = UIActivityIndicatorView()
        activiryIndicator.color = .sydney
        self.addSubview(activiryIndicator)
        activiryIndicator.translatesAutoresizingMaskIntoConstraints = false
        activiryIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activiryIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        activiryIndicator.startAnimating()
    }
    
}
