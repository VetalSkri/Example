//
//  EPNOfflineCbCard.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 16/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
class EPNOfflineCbCard: UIView {
    
    
    fileprivate let titleLabel = UILabel()
    fileprivate let descriptionLabel = UILabel()
    fileprivate let logo = UIRemoteImageView()
    fileprivate let qrCodeImage = UIImageView()
    fileprivate let conditionLink = EPNLinkLabel(style: .full)
    private let STATIC_HEIGHT_IMAGE = 135
    private let STATIC_HEIGHT_QRIMAGE = 30
    
    var handler: ((EPNLinkLabel) -> ())?
    
    @IBInspectable var titleText: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    
    @IBInspectable var descriptionText: String? {
        get { return descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    
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
        backgroundColor = .zurich
        layer.cornerRadius = CGFloat(CommonStyle.cornerRadius)
        borderWidth = CommonStyle.borderWidth
        borderColor = .montreal
        
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        logo.heightAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_IMAGE)).isActive = true
        logo.widthAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_IMAGE)).isActive = true
        logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        logo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        logo.contentMode = .scaleAspectFit
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .sydney
        titleLabel.font = .semibold15
        titleLabel.numberOfLines = 2
        
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .sydney
        descriptionLabel.font = .medium13
        descriptionLabel.numberOfLines = 2

        addSubview(qrCodeImage)
        qrCodeImage.translatesAutoresizingMaskIntoConstraints = false
        qrCodeImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        qrCodeImage.heightAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_QRIMAGE)).isActive = true
        qrCodeImage.widthAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_QRIMAGE)).isActive = true
        qrCodeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        qrCodeImage.contentMode = .scaleAspectFit
        qrCodeImage.image = UIImage(named: "qrIcon")
        
        addSubview(conditionLink)
        conditionLink.translatesAutoresizingMaskIntoConstraints = false
        conditionLink.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        conditionLink.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 10).isActive = true
        conditionLink.trailingAnchor.constraint(lessThanOrEqualTo: qrCodeImage.leadingAnchor, constant: -10).isActive = true
        conditionLink.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        conditionLink.textColor = .sydney
        conditionLink.font = .medium13
        conditionLink.numberOfLines = 1
        conditionLink.textAlignment = .left
        conditionLink.text = NSLocalizedString("Conditions", comment: "")
        
        conditionLink.isHidden = false
        conditionLink.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCondition))
        conditionLink.isUserInteractionEnabled = true
        conditionLink.addGestureRecognizer(tap)
        
        updateConstraintsIfNeeded()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    func downloadLogoImageBy(link: String?) {
        logo.loadImageUsingUrlString(urlString: link, defaultImage: UIImage(named: "defaultImageOffCb")!.withRenderingMode(.alwaysOriginal))
    }

}

extension EPNOfflineCbCard {
    
    @objc private func didTapCondition() {
        conditionLink.alpha = 0.9
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.conditionLink.alpha = 1.0
        }) { [weak self] (_) in
            if self != nil {
                self!.handler?(self!.conditionLink)
            }
        }
    }
}
