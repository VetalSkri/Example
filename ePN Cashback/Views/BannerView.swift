//
//  BannerView.swift
//  Backit
//
//  Created by Elina Batyrova on 21.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class BannerView: UIView {
    
    // MARK: - Nested Types
    
    private enum Images {
        static let linkCheckerBannerIcon = UIImage(named: "bannerInfoIcon")
    }
    
    // MARK: - Instance Properties
    
    private var bannerTitleLabel: UILabel!
    private var bannerDescriptionLabel: UILabel!
    private var bannerActionButton: UIButton!
    private var bannerImageView: UIImageView!
    
    // MARK: -
    
    var title: String? {
        get {
            bannerTitleLabel.text
        }
        
        set {
            bannerTitleLabel.text = newValue
        }
    }
    
    var descriptionTitle: String? {
        get {
            bannerDescriptionLabel.text
        }
        
        set {
            bannerDescriptionLabel.text = newValue
        }
    }
    
    var buttonTitle: String? {
        get {
            bannerActionButton.titleLabel?.text
        }
        
        set {
            bannerActionButton.setTitle(newValue, for: .normal)
        }
    }
    
    var onButtonTapped: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    private func setupView() {
        self.backgroundColor = UIColor.vilnius.withAlphaComponent(0.4)
        self.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bannerTitleLabel = UILabel()
        bannerTitleLabel.text = title
        bannerTitleLabel.font = UIFont.semibold15
        bannerTitleLabel.textColor = UIColor.sydney
        
        bannerDescriptionLabel = UILabel()
        bannerDescriptionLabel.text = descriptionTitle
        bannerDescriptionLabel.font = UIFont.medium13
        bannerDescriptionLabel.textColor = UIColor.moscow
        bannerDescriptionLabel.numberOfLines = 0
        
        bannerImageView = UIImageView(image: Images.linkCheckerBannerIcon)
        bannerImageView.tintColor = UIColor.budapest
        
        bannerActionButton = UIButton()
        bannerActionButton.translatesAutoresizingMaskIntoConstraints = false
        bannerActionButton.setTitle(buttonTitle, for: .normal)
        bannerActionButton.setTitleColor(UIColor.zurich, for: .normal)
        bannerActionButton.titleLabel?.font = UIFont.semibold13
        bannerActionButton.backgroundColor = UIColor.moscow
        bannerActionButton.cornerRadius = 2
        bannerActionButton.addTarget(self, action: #selector(onBannerActionButtonTouchUpInside(sender:)), for: .touchUpInside)
        
        self.addSubview(bannerTitleLabel)
        self.addSubview(bannerDescriptionLabel)
        self.addSubview(bannerActionButton)
        self.addSubview(bannerImageView)
        
        bannerImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.width.height.equalTo(24)
        }
        
        bannerTitleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(16)
            maker.leading.equalToSuperview().inset(16)
            maker.trailing.equalTo(bannerImageView.snp.leading).inset(-16)
        }
        
        bannerDescriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(bannerTitleLabel.snp.bottom).inset(-4)
            maker.leading.equalTo(bannerTitleLabel.snp.leading)
            maker.trailing.equalTo(bannerTitleLabel.snp.trailing)
        }

        bannerActionButton.snp.makeConstraints { maker in
            maker.top.equalTo(bannerDescriptionLabel.snp.bottom).inset(-16)
            maker.leading.equalTo(bannerDescriptionLabel.snp.leading)
            maker.bottom.equalToSuperview().inset(16)
            maker.width.equalTo(100)
        }
    }
    
    @objc private func onBannerActionButtonTouchUpInside(sender: Any) {
        self.onButtonTapped?()
    }
}
