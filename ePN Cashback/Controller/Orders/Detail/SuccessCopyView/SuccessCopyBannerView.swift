//
//  SuccessCopyBannerView.swift
//  Backit
//
//  Created by Александр Кузьмин on 25/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class SuccessCopyBannerView: UIView {

    private var isFirstLayout = true
    var statusText: String?
    var actionText: String?
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    
    class func instanceFromNib() -> SuccessCopyBannerView {
        return UINib(nibName: "SuccessCopyBannerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SuccessCopyBannerView
    }
    
    override func layoutSubviews() {
        if isFirstLayout {
            setupView()
        }
        isFirstLayout = false
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        mainContainerView.backgroundColor = .vilnius
        mainContainerView.cornerRadius = CommonStyle.modalCornerRadius
        mainContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        iconImageView.image = UIImage(named: "done")
        statusLabel.text = (statusText ?? "")+": "
        statusLabel.textColor = .sydney
        statusLabel.font = .semibold13
        
        actionLabel.text = actionText ?? ""
        actionLabel.textColor = .sydney
        actionLabel.font = .medium13
    }

}
