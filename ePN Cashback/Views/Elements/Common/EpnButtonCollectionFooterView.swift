//
//  EpnButtonCollectionFooterView.swift
//  Backit
//
//  Created by Александр Кузьмин on 18/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol EpnButtonCollectionFooterViewDelegate: class {
    func buttonClicked()
}

class EpnButtonCollectionFooterView: UICollectionReusableView {
    
    weak var delegate: EpnButtonCollectionFooterViewDelegate?
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        button.backgroundColor = .moscow
        button.setTitleColor(.zurich, for: .normal)
        button.titleLabel?.font = .semibold15
        button.setTitle(NSLocalizedString("Repeat", comment: ""), for: .normal)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = CommonStyle.buttonCornerRadius
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    func setupView(isButtonHidden: Bool) {
        button.isHidden = isButtonHidden
    }
    
    @objc private func buttonClicked() {
        delegate?.buttonClicked()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
