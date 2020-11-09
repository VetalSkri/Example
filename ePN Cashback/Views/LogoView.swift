//
//  LogoView.swift
//  Backit
//
//  Created by Виталий Скриганюк on 01.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class PurseLogoView: UIView {
    
    var containerView = UIView()
    var multicardView = UIView()
    var stackImageView = UIStackView()
    private var imagesViews: [UIImageView] = [UIImageView(image:UIImage(named: "masterCardSmall")), UIImageView(image:UIImage(named: "mirSmall"))
    ]
    var visaImageView = UIImageView(image: UIImage(named: "visaSmall"))
    
    var singleImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.addSubview(containerView)
        
        multicardView.addSubview(visaImageView)
        multicardView.addSubview(stackImageView)
        
        containerView.addSubview(singleImageView)
        containerView.addSubview(multicardView)
        
        singleImageView.contentMode = .scaleAspectFit
        
        stackImageView.axis = .horizontal
        imagesViews.enumerated().forEach { index, imageView in
            imageView.contentMode = .scaleAspectFit
            stackImageView.insertArrangedSubview(imageView, at: index)
        }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        multicardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        stackImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        visaImageView.snp.makeConstraints { make in
            make.top.equalTo(stackImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        singleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    public func setup(type: LogoImages, image: UIImage?) {
        singleImageView.isHidden = true
        
        visaImageView.isHidden = true
        stackImageView.isHidden = true
        
        switch type {
        case .single:
            singleImageView.isHidden = false
            singleImageView.image = image
        case .multiCard:
            stackImageView.isHidden = false
            visaImageView.isHidden = false
            singleImageView.image = nil
        }
    }
}

enum LogoImages {
    case multiCard
    case single
}
