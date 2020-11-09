//
//  ImageCollectionCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 14.07.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class ImageCollectionCell: UICollectionViewCell {
    
    // Containers View's
    private var containerView = UIView()
    private var infoView = UIView()
    
    // Content View's
    private var imageView = UIImageView()
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupStyle()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupSubviews() {
        infoView.addSubview(imageView)
        infoView.addSubview(label)
        
        containerView.addSubview(infoView)
        
        self.addSubview(containerView)
    }
    
    private func setupStyle() {
        containerView.cornerRadius = CommonStyle.cardCornerRadius
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        
        imageView.cornerRadius = CommonStyle.cardCornerRadius
        imageView.clipsToBounds = true
        imageView.borderWidth = 2
        imageView.borderColor = .white
        imageView.contentMode = .scaleAspectFill
        
        label.numberOfLines = 0
        label.text = NSLocalizedString("Settings_Gallery", comment: "")
        label.font = .medium10
        label.textColor = .white
        label.textAlignment = .center
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupMoreCell() {
        label.isHidden = false
        containerView.backgroundColor = .lightGray
        imageView.borderWidth = 0
        infoView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    public func setupImage(image: UIImage?) {
        guard let image = image else {
            imageView.image = UIImage(named: "Gallery")
            setupMoreCell()
            return
        }
        setupConstraints()
        label.isHidden = true
        imageView.borderWidth = 2
        imageView.image = image
    }
}
