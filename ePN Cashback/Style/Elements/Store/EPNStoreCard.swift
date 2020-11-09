//
//  EPNStoreCard.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 09/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
final class EPNStoreCard: UIView {
    
    enum StoreCardStyle: Int {
        case none = 0
        case shop
        
    }
    
    var style: StoreCardStyle = .none {
        didSet { applyStyle() }
    }
    
    @IBInspectable private var styleType: Int {
        get { return style.rawValue }
        
        set {
            if let newStyle = StoreCardStyle(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    @IBInspectable var headText: String? {
        didSet{
            setUpCashbackText(firstTitle: headText ?? "", secondTitle: mainText ?? "")
        }
    }
    
    
    @IBInspectable var mainText: String? {
        didSet {
            setUpCashbackText(firstTitle: headText ?? "", secondTitle: mainText ?? "")
        }
    }
    
    var handlerLike: ((EPNLikeView, Bool) -> ())?
    
    //TODO: - Add on the future image of fire
    fileprivate let storeImgView = UIRemoteImageView()
    fileprivate let cashbackLabel = UILabel()
    fileprivate let containerView = UIView()
    fileprivate let oldCashBackLabel = UILabel()
    fileprivate let arrowDisableView = UIView()
    fileprivate let likeView = EPNLikeView()
    fileprivate let storeNameLabel = UILabel()
    
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
        backgroundColor = .clear
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        containerView.clipsToBounds = false
        containerView.layer.cornerRadius = CommonStyle.cardCornerRadius
        storeImgView.layer.cornerRadius = CommonStyle.cardCornerRadius
        containerView.backgroundColor = .zurich
        
        
        addSubview(containerView)
        
        containerView.addSubview(storeImgView)
        containerView.addSubview(likeView)
        
        storeImgView.contentMode = .scaleAspectFit
        storeImgView.backgroundColor = .paris
        
        likeView.handler = { [weak self] (likeButton, status) in
            self?.handlerLike?(likeButton, status)
        }
        
        likeView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor

        likeView.shadowOpacity = 1

        likeView.shadowRadius = 12

        likeView.shadowOffset = CGSize(width: 0, height: 4)
        
        containerView.addSubview(cashbackLabel)
        containerView.addSubview(storeNameLabel)
        containerView.addSubview(oldCashBackLabel)
        
        oldCashBackLabel.addSubview(arrowDisableView)
        
        arrowDisableView.backgroundColor = .minsk
        
        // Скрыт до появления API
        oldCashBackLabel.textColor = .minsk
        oldCashBackLabel.font = .medium11
        oldCashBackLabel.text = ""
        
        storeNameLabel.textColor = .london
        storeNameLabel.font = .medium11
        
        cashbackLabel.textColor = .black
        cashbackLabel.font = .semibold17
        
        cashbackLabel.textAlignment = .left
        cashbackLabel.numberOfLines = 0
        
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        likeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.right.equalToSuperview()
                .inset(8)
            make.height.equalTo(26)
            make.width.equalTo(26)
        }
        storeImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(self.width)
        }
        storeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(storeImgView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        cashbackLabel.snp.makeConstraints { (make) in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        oldCashBackLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cashbackLabel.snp.bottom).offset(2)
            make.height.equalTo(14)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        arrowDisableView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        likeView.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func setStatusOfLike(status: LikeState) {
        likeView.setStatusLiked(status)
    }
    
    func setImage(_ image: UIImage) {
        storeImgView.image = image
    }
    
    func setupStoreInfo(storeName: String, cashBack: String, isMaxRatePretext: Bool) {
        storeNameLabel.text = storeName
        cashbackLabel.text = isMaxRatePretext ? NSLocalizedString("cashBackUpTo", comment: "") + " " + cashBack : cashBack
    }
    
    func setUpCashbackText(firstTitle: String, secondTitle: String?) {
        cashbackLabel.text = secondTitle
        storeNameLabel.text = firstTitle
        if let mainText = secondTitle {
            let headText = firstTitle + "\n"
            let attrsHead = [NSAttributedString.Key.font : UIFont.medium13,
                             NSAttributedString.Key.foregroundColor: UIColor.sydney]
            
            
            let attrsMain = [NSAttributedString.Key.font : UIFont.semibold15,
                             NSAttributedString.Key.foregroundColor: UIColor.sydney]
            
            
            let attributedString = NSMutableAttributedString(string:headText, attributes:attrsHead)
            
            
            let normalString = NSMutableAttributedString(string: mainText, attributes: attrsMain)
            
            attributedString.append(normalString)
            
            cashbackLabel.attributedText = attributedString
        } else {
            cashbackLabel.text = firstTitle
            cashbackLabel.font = .medium13
            cashbackLabel.textColor = .sydney
        }
        
    }
    
    func downloadImageBy(link: String?) {
        storeImgView.loadImageUsingUrlString(urlString: link, defaultImage: UIColor.paris.toImage())
    }
    
    private func applyStyle() {
        setNeedsLayout()
    }
}
