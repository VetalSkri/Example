//
//  ContryTableCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 26.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class CountryTableCell: UITableViewCell {
    
    // Containers View's
    private var containerView = UIView()
    private var infoView = UIView()
    private var arrowView = UIView()
    
    // Content View's
    private var geoNameLabel = UILabel()
    private var arrowImageView = UIImageView()
    
    weak var delegate: CountryTableCellDelegate!
    
    private var tap: UITapGestureRecognizer!
    private var data: SearchGeoDataResponse!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(selected))
        
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selected() {
        delegate.selected(geo: data)
    }
    
    private func setupSubviews() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        containerView.addSubview(infoView)
        containerView.addSubview(arrowView)
        
        infoView.addSubview(geoNameLabel)
        
        arrowView.addSubview(arrowImageView)
        
        geoNameLabel.textColor = .london
        geoNameLabel.font = .medium15
        
        self.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(6)
            make.height.equalTo(48)
        }
        infoView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        arrowView.snp.makeConstraints { make in
            make.left.equalTo(infoView.snp.right)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        geoNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
    }
    
    public func setupCell(data: SearchGeoDataResponse, delegate: CountryTableCellDelegate) {
        if data.attributes?.countryCode == "UA" || data.attributes?.countryCode == "RU" {
            geoNameLabel.textColor = .black
            geoNameLabel.font = .semibold15
        } else {
            geoNameLabel.textColor = .london
            geoNameLabel.font = .medium15
        }
        geoNameLabel.text = data.attributes?.name
        arrowImageView.image = UIImage(named: "defArrowRight")
        self.delegate = delegate
        self.data = data
    }
}
