//
//  PurseCountryTableCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

class PurseCountryInfoTableCell: UITableViewCell {
    
    // Containers View's
    private var containerView = UIView()
    private var logoView = UIView()
    private var infoView = UIView()
    
    // Content View's
    private var infoTitleLabel = UILabel()
    private var infoTextView = UITextView()
    private var logoImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        self.selectionStyle = .none
        containerView.addSubview(infoView)
        containerView.addSubview(logoView)
        
        logoView.addSubview(logoImageView)
        logoImageView.clipsToBounds = true
        
        infoView.addSubview(infoTitleLabel)
        infoView.addSubview(infoTextView)
        
        infoTextView.isScrollEnabled = false
        infoTextView.isEditable = false
        
        infoTitleLabel.textColor = .black
        infoTitleLabel.font = .semibold15
        
        infoTextView.textColor = .london
        infoTextView.font = .medium13
        infoTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    
        self.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(logoView.snp.right).offset(12)
            make.bottom.equalToSuperview()
        }
        logoView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        infoTextView.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public func setupCell(data: CountryPurseInfoProtocol) {
        infoTitleLabel.text = data.title
        infoTextView.text = data.info
        logoImageView.image = UIImage(named:data.logo.rawValue)
    }
}


