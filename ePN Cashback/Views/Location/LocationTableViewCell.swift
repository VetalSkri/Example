//
//  LocationTableViewCell.swift
//  Backit
//
//  Created by Elina Batyrova on 14.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class LocationTableViewCell: UITableViewCell {
    
    // MARK: - Nested Types
    
    private enum Images {
        static let arrow = UIImage(named: "defArrowRight")!
    }
    
    // MARK: - Instance Properties
    
    weak var delegate: LocationTableViewCellDelegate!
    
    // MARK: -
    
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView(image: Images.arrow)
    
    private var data: LocationCellData!
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
        self.setupConstraints()
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelect))
        
        self.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    func configureCell(data: LocationCellData, delegate: LocationTableViewCellDelegate) {
        self.delegate = delegate
        self.data = data
        
        self.titleLabel.text = data.title
    }
    
    // MARK: -
    
    @objc private func didSelect() {
        delegate.didSelectCellWith(data: self.data)
    }
    
    private func setupView() {
        titleLabel.font = .medium15
        titleLabel.textColor = .london
        titleLabel.numberOfLines = 1
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.arrowImageView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview().inset(24)
            maker.centerY.equalToSuperview()
            maker.trailing.lessThanOrEqualTo(self.arrowImageView.snp.leading).inset(-9)
        })
        
        arrowImageView.snp.makeConstraints({ maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().inset(16)
            maker.width.equalTo(24)
        })
    }
}
