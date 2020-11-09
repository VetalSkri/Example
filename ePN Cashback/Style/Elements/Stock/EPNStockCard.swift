//
//  EPNStockCard.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 05/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
class EPNStockCard: UIView {

    fileprivate let mainImage = UIRemoteImageView()
    fileprivate let logoShop = UIRemoteImageView()
    fileprivate let percentTitle = EPNPaddingLabel()
    fileprivate let costTitle = UILabel()
    fileprivate let cashbackTitle = UILabel()
    fileprivate let stockeNamelabel = UILabel()
    fileprivate let likeView = EPNLikeView()
    fileprivate let statusArrow = UIImageView()
    
    private let STATIC_HEIGHT_SHOP_LOGO = 20
    private let STATIC_WIDTH_SHOP_LOGO = 60
    
    var handlerLike: ((EPNLikeView, Bool) -> ())?

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
        setupSubviews()
        updateConstraintsIfNeeded()
        setNeedsLayout()
        likeView.setStatusLiked(.notFavorite)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        backgroundColor = .zurich
        
        self.clipsToBounds = true
        
        layer.cornerRadius = CommonStyle.cardCornerRadius
        
        likeView.handler = { [weak self] (likeButton, status) in
            self?.handlerLike?(likeButton, status)
        }
                
        addSubview(mainImage)
        mainImage.contentMode = .scaleAspectFit
        mainImage.backgroundColor = .paris
        mainImage.borderWidth = 1
        mainImage.borderColor = .montreal
        mainImage.cornerRadius = CommonStyle.cardCornerRadius
        mainImage.clipsToBounds = true
        
        addSubview(percentTitle)
        percentTitle.padding = UIEdgeInsets.init(top: 3, left: 5, bottom: 3, right: 5)
        percentTitle.text = "00.00%"
        percentTitle.font = .semibold13
        percentTitle.sizeToFit()
        percentTitle.textColor = .zurich
        percentTitle.textAlignment = .center
        percentTitle.numberOfLines = 1
        percentTitle.backgroundColor = .prague
        percentTitle.layer.cornerRadius = CommonStyle.cornerRadius
        
        
        addSubview(costTitle)
        costTitle.textAlignment = .left
        costTitle.numberOfLines = 0
        costTitle.font = .semibold17
        costTitle.textColor = .sydney
        
        statusArrow.image = UIImage(named: "arrow_down")
        
        addSubview(cashbackTitle)
        cashbackTitle.textAlignment = .left
        cashbackTitle.numberOfLines = 0
        cashbackTitle.font = .semibold13
        cashbackTitle.textColor = .moscow
        
        addSubview(logoShop)
        logoShop.contentMode = .scaleAspectFit
        
        stockeNamelabel.numberOfLines = 2
        stockeNamelabel.textColor = .london
        stockeNamelabel.font = .medium11
        
        addSubview(stockeNamelabel)
        addSubview(likeView)
        addSubview(statusArrow)
        
        // Лайквью появится позже, когда будет добавление раздела "Товары"
        likeView.isHidden = true
    }
    
    private func setupConstraints() {
        mainImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(self.width)
        }
        logoShop.snp.makeConstraints { (make) in
            make.top.equalTo(mainImage.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(22)
        }
        stockeNamelabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoShop.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        costTitle.snp.makeConstraints { (make) in
            make.top.equalTo(stockeNamelabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        cashbackTitle.snp.makeConstraints { (make) in
            make.top.equalTo(costTitle.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
        percentTitle.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(52)
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview()
        }
        // Этот код будет нужен при добавлении раздела "Товары"
//        likeView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().inset(8)
//            make.right.equalToSuperview()
//                .inset(8)
//            make.height.equalTo(26)
//            make.width.equalTo(26)
//        }
        statusArrow.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(22)
            make.left.equalTo(self.costTitle.snp.right)
        }
    }
    
    func setUpCashbackText(firstTitle: String, secondTitle: String) {
        let attrsTitle = [NSAttributedString.Key.font : UIFont.semibold13,
                          NSAttributedString.Key.foregroundColor: UIColor.sydney]
        let attrsPrice = [NSAttributedString.Key.foregroundColor: UIColor.sydney,
                          NSAttributedString.Key.font : UIFont.semibold13]
        let attributedString = NSMutableAttributedString(string:firstTitle, attributes:attrsTitle)
        let normalString = NSMutableAttributedString(string: secondTitle, attributes: attrsPrice)
        attributedString.append(normalString)
        cashbackTitle.attributedText = attributedString
    }
    
    func setupPercent(_ percent: String) {
        percentTitle.isHidden = percent.isEmpty
        percentTitle.text = percent
        if percent.isEmpty {
            cashbackTitle.textColor = .moscow
        } else {
            cashbackTitle.textColor = .prague
        }
    }
    
    func setupStockName(name: String) {
        stockeNamelabel.text = name
    }
    
    func setUpCostText(cost: String) {
        costTitle.text = cost
    }
    
    func setImage(_ image: UIImage) {
        mainImage.image = image
    }

    func setLogoImage(_ image: UIImage) {
        logoShop.image = image
    }
    
    func downloadLogoImageBy(link: String?) {
        logoShop.loadImageUsingUrlString(urlString: link, defaultImage: UIColor.paris.toImage())
    }
    
    func downloadImageBy(link: String?) {
        mainImage.loadImageUsingUrlString(urlString: link, defaultImage: UIColor.paris.toImage())
    }
    
}
