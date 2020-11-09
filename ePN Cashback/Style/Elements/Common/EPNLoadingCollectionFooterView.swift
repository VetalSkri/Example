//
//  EPNLoadingCollectionFooterView.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 28/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class EPNLoadingCollectionFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        let activityIndicator = UIActivityIndicatorView()//(frame: CGRect(x: self.frame.width/2-25, y: 0, width: 30, height: 30))
        activityIndicator.color = .sydney
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
