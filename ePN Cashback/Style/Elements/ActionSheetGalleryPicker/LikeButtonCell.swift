//
//  LikeButtonCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 13/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

import UIKit

final class LikeButtonCell: UITableViewCell {
    
    // MARK: Properties
    
    private var isFirstLayout = true
    static let identifier = String(describing: LikeButtonCell.self)
    
    
    // MARK: Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = nil
        contentView.backgroundColor = nil
        textLabel?.textColor = UIColor(hex: 0x007AFF)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout {
            let separatorView = UIView()
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(separatorView)
            separatorView.backgroundColor = UIColor.sydney.withAlphaComponent(0.2)
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            isFirstLayout = false
            layoutIfNeeded()
        }
        textLabel?.textAlignment = .center
    }
}
