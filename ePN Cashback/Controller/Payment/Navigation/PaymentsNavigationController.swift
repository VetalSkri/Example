//
//  PaymentsNavigationController.swift
//  Backit
//
//  Created by Виталий Скриганюк on 28.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class PaymentsNavigationController: UINavigationController {
    
    let bottomView = BottomPaymentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setConstraints()
    }
    
    public func isHideBottomView(status: Bool) {
        bottomView.isHidden = status
    }
    
    private func setSubviews() {
        bottomView.isHidden = true
        self.view.addSubview(bottomView)
    }
    
    private func setConstraints() {
        self.bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func observeControllers() {
        
    }
    
    public func isKeyBoardHide(status: Bool, duration: TimeInterval? = TimeInterval.zero, finalRect: CGRect?) {
        if !status, let finalRect = finalRect {
            UIView.animate(withDuration: duration!) {
                self.bottomView.snp.remakeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview().inset(finalRect.height)
                }
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0) {
                self.bottomView.snp.remakeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        }
    }
}
