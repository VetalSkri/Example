//
//  ItemWithPhoto.swift
//  Backit
//
//  Created by Александр Кузьмин on 13/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Photos

final class ItemWithPhoto: UICollectionViewCell {
    
    private var asset: PHAsset?
    private weak var rootVC: TelegramPickerViewController?
    
    lazy var imageView: UIImageView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.maskToBounds = true
        return $0
    }(UIImageView())
    
    lazy var circle: UIView = {
        $0.backgroundColor = .clear
        $0.borderColor = .zurich
        $0.borderWidth = 2
        $0.maskToBounds = false
        $0.cornerRadius = 13
        return $0
    }(UIView())
    
    lazy var numberLabel: UILabel = {
        $0.font = .semibold13
        $0.textColor = .zurich
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    fileprivate let inset: CGFloat = 6
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public func setupView(asset: PHAsset, rootVC: TelegramPickerViewController) {
        self.asset = asset
        self.rootVC = rootVC
        setupSelectedIndicator()
    }
    
    func setupSelectedIndicator() {
        guard let asset = asset, let rootVC = rootVC else { return }
        let number = rootVC.selectedAssets.firstIndex(of: asset)
        numberLabel.text = number != nil ? "\(number! + 1)" : ""
        circle.backgroundColor = number != nil ? .sydney : .clear
    }
    
    public func setup() {
        backgroundColor = .clear
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.widthAnchor.constraint(equalToConstant: 26).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        circle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true
        circle.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        circle.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.frame
        imageView.cornerRadius = 12
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }
}
