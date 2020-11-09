//
//  EPNOrderCard.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 10/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
final class EPNOrderCard: UIView {
    
    fileprivate let topBarView = UIView()
    fileprivate let topBarTitle = UILabel()
    fileprivate let topMainContainerView = UIView()
    fileprivate let bottomMainContainerView = UIView()
    
    fileprivate let logoShop = UIRemoteImageView()
    fileprivate let cashbackTitle = EPNLabel()
    fileprivate let costTitle = EPNLabel()
    fileprivate let identifierCode = EPNLabel()
    
    private let STATIC_HEIGHT_IMAGE = 32
    
    enum Style: Int {
        case none = 0
        case process
        case confirmed
        case canceled
    }
    
    var style: Style = .none {
        didSet { applyStyle() }
    }
    
    
    @IBInspectable private var styleType: Int {
        get { return style.rawValue }
        
        set {
            if let newStyle = Style(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    @IBInspectable var headerText: String? {
        get { return topBarTitle.text }
        set { topBarTitle.text = newValue }
    }
    
    @IBInspectable public var cashbackFontSize: CGFloat = 15.0 {
        didSet {
            cashbackTitle.font = cashbackTextFont
        }
    }
    
    private var cashbackTextFont: UIFont {
        return UIFont.systemFont(ofSize: cashbackFontSize, weight: .regular)
    }
    
    @IBInspectable var cashbackText: String? {
        get { return cashbackTitle.text }
        set { cashbackTitle.text = newValue }
    }
    
    
    @IBInspectable public var costFontSize: CGFloat = 13.0 {
        didSet {
            costTitle.font = costTextFont
        }
    }
    
    private var costTextFont: UIFont {
        return UIFont.systemFont(ofSize: costFontSize, weight: .regular)
    }
    
    @IBInspectable var costText: String? {
        get { return costTitle.text }
        set { costTitle.text = newValue }
    }
    
    @IBInspectable public var identifierFontSize: CGFloat = 13.0 {
        didSet {
            identifierCode.font = identifierTextFont
        }
    }
    
    private var identifierTextFont: UIFont {
        return UIFont(name: "Montserrat-Bold", size: identifierFontSize)!
    }
    
    @IBInspectable var identifierText: String? {
        get { return identifierCode.text }
        set { identifierCode.text = newValue }
    }
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
        applyStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyStyle()
    }
    
    private func commonInit() {
        backgroundColor = .zurich
        layer.cornerRadius = CommonStyle.cornerRadius
        layer.borderWidth = CommonStyle.borderWidth
        layer.borderColor = UIColor.montreal.cgColor
        
        addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        topBarView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        topBarView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        topBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        topBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        
        // CashbackLabel
        topBarView.addSubview(topBarTitle)
        topBarTitle.translatesAutoresizingMaskIntoConstraints = false
        topBarTitle.textColor = .zurich
        topBarTitle.font = .semibold15
        
        topBarTitle.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor, constant: 0).isActive = true
        topBarTitle.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor, constant: 0).isActive = true

        topMainContainerView.backgroundColor = .clear
        addSubview(topMainContainerView)
        topMainContainerView.translatesAutoresizingMaskIntoConstraints = false
        topMainContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 5).isActive = true
        topMainContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        topMainContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        topMainContainerView.heightAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_IMAGE)).isActive = true


        topMainContainerView.addSubview(logoShop)
        logoShop.contentMode = .scaleAspectFit

        logoShop.translatesAutoresizingMaskIntoConstraints = false
        logoShop.topAnchor.constraint(equalTo: topMainContainerView.topAnchor, constant: 0).isActive = true
        logoShop.leadingAnchor.constraint(equalTo: topMainContainerView.leadingAnchor, constant: 0).isActive = true
        logoShop.heightAnchor.constraint(equalToConstant: 32).isActive = true
        logoShop.widthAnchor.constraint(equalToConstant: 94).isActive = true
        logoShop.bottomAnchor.constraint(equalTo: topMainContainerView.bottomAnchor, constant: 0).isActive = true
        logoShop.image = UIImage(named: "defaultStore")

        //Set color fot labels
        cashbackTitle.textColor = .sydney
        cashbackTitle.font = .semibold15
        cashbackTitle.textAlignment = .right
        cashbackTitle.numberOfLines = 1

        costTitle.textColor = .sydney
        costTitle.font = .medium13
        costTitle.textAlignment = .right
        costTitle.numberOfLines = 1

        identifierCode.textColor = .minsk
        identifierCode.font = .medium13
        identifierCode.numberOfLines = 1
        identifierCode.textAlignment = .left

        //add labels in containers
        topMainContainerView.addSubview(cashbackTitle)

        cashbackTitle.translatesAutoresizingMaskIntoConstraints = false
        cashbackTitle.centerYAnchor.constraint(equalTo: topMainContainerView.centerYAnchor, constant: 0).isActive = true
        cashbackTitle.trailingAnchor.constraint(equalTo: topMainContainerView.trailingAnchor, constant: 0).isActive = true
        cashbackTitle.leadingAnchor.constraint(equalTo: logoShop.trailingAnchor, constant: 10).isActive = true

        bottomMainContainerView.backgroundColor = .clear

        
        addSubview(bottomMainContainerView)
        bottomMainContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomMainContainerView.topAnchor.constraint(equalTo: topMainContainerView.bottomAnchor, constant: 0).isActive = true
        bottomMainContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        bottomMainContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        bottomMainContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        bottomMainContainerView.addSubview(identifierCode)
        identifierCode.translatesAutoresizingMaskIntoConstraints = false
        identifierCode.bottomAnchor.constraint(equalTo: bottomMainContainerView.bottomAnchor, constant: -10).isActive = true
        identifierCode.topAnchor.constraint(equalTo: bottomMainContainerView.topAnchor, constant: 2).isActive = true
        
        //FIXME: - change this on getting width of parent
        identifierCode.leadingAnchor.constraint(equalTo: bottomMainContainerView.leadingAnchor, constant: 0).isActive = true

        bottomMainContainerView.addSubview(costTitle)
        costTitle.translatesAutoresizingMaskIntoConstraints = false
        costTitle.centerYAnchor.constraint(equalTo: bottomMainContainerView.centerYAnchor, constant: 0).isActive = true

        costTitle.topAnchor.constraint(equalTo: bottomMainContainerView.topAnchor, constant: 2).isActive = true
        costTitle.bottomAnchor.constraint(equalTo: bottomMainContainerView.bottomAnchor, constant: -10).isActive = true
        costTitle.trailingAnchor.constraint(equalTo: bottomMainContainerView.trailingAnchor, constant: 0).isActive = true

        
        updateConstraintsIfNeeded()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //FIXME: - change this on getting width of parent
        topBarView.topRoundCorners(cornerRadius: Double(CommonStyle.cornerRadius))
        identifierCode.widthAnchor.constraint(equalToConstant: bottomMainContainerView.bounds.width/2).isActive = true
        costTitle.widthAnchor.constraint(equalToConstant: bottomMainContainerView.frame.width/2).isActive = true
    }
    
    func setupCashbackText(cashback: String) {
        cashbackTitle.text = cashback
    }
    
    func setupCostText(cost: String) {
        costTitle.text = cost
    }
    
    private func applyStyle() {
        switch style {
        case .none:
            setNeedsLayout()
        case .canceled:
            topBarView.layer.backgroundColor = UIColor.prague.cgColor
            setNeedsLayout()
        case .confirmed:
            topBarView.layer.backgroundColor = UIColor.budapest.cgColor
            setNeedsLayout()
        case .process:
            topBarView.layer.backgroundColor = UIColor.minsk.cgColor
            setNeedsLayout()
        }
        updateConstraints()
    }
    
    func setUpCornerRadius() {
        topBarView.topRoundCorners(cornerRadius: Double(CommonStyle.cornerRadius))
    }
    
    func setImage(_ image: UIImage) {
        logoShop.image = image
    }
    
    func downloadImageBy(link: String?) {
        logoShop.loadImageUsingUrlString(urlString: link, defaultImage: UIImage(named: "defaultStore")!)
    }
    
}
