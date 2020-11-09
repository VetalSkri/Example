//
//  EPNPopUpInfo.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPNPopUpInfo: UIView {
    
    private let closeButton = EPNCloseButton()
    private let titleLabel = EPNLabel(style: .headPopUp)
    private let imageInfo = UIImageView()
    
    var handlerClosePopUp: ((EPNCloseButton) -> ())?
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = CommonStyle.cornerRadius
        backgroundColor = .zurich
        
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(didClosePopUp), for: .touchUpInside)
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
        addSubview(imageInfo)
        imageInfo.translatesAutoresizingMaskIntoConstraints = false
        imageInfo.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 5).isActive = true
        imageInfo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageInfo.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        imageInfo.widthAnchor.constraint(equalTo: imageInfo.heightAnchor).isActive = true
        imageInfo.contentMode = .scaleAspectFit
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageInfo.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .medium15
        titleLabel.textColor = .sydney
        setNeedsLayout()
    }
}

extension EPNPopUpInfo {
    
    func setInfoText(info text: String) {
        titleLabel.text = text
    }
    
    func setupImage(currentImage: UIImage) {
        imageInfo.image = currentImage
    }
    
}

extension EPNPopUpInfo {
    
    @objc private func didClosePopUp() {
        self.closeButton.alpha = 0.5
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.closeButton.alpha = 1.0
        }) { [weak self] (_) in
            if self != nil {
                self!.handlerClosePopUp?(self!.closeButton)
            }
        }
    }
    
    
}
