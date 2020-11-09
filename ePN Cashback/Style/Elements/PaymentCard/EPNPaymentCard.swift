//
//  EPNPaymentCard.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 04/02/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

@IBDesignable
class EPNPaymentCard: UIView {

    fileprivate let topBarView = UIView()
    fileprivate let topBarTitle = UILabel()
    fileprivate let topMainContainerView = UIView()
    
    fileprivate let paymentLogo = UIImageView()
    fileprivate let paymentNumber = EPNLabel()
    fileprivate let costTitle = EPNLabel()
    fileprivate let costValue = EPNLabel()
    
    private let STATIC_HEIGHT_IMAGE = 25
    
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
    
    @IBInspectable public var headerFontSize: CGFloat = 13.0 {
        didSet {
            topBarTitle.font = headerTextFont
        }
    }
    
    private var headerTextFont: UIFont {
        return .systemFont(ofSize: headerFontSize, weight: .medium)
    }
    
    @IBInspectable var headerText: String? {
        get { return topBarTitle.text }
        set { topBarTitle.text = newValue }
    }
    
    @IBInspectable public var paymentNumberFontSize: CGFloat = 17.0 {
        didSet {
            paymentNumber.font = paymentNumberTextFont
        }
    }
    
    private var paymentNumberTextFont: UIFont {
        return .systemFont(ofSize: paymentNumberFontSize, weight: .medium)
    }
    
    @IBInspectable var paymentText: String? {
        get { return paymentNumber.text }
        set { paymentNumber.text = newValue }
    }
    
    
    @IBInspectable public var costFontSize: CGFloat = 13.0 {
        didSet {
            costTitle.font = costTextFont
        }
    }
    
    private var costTextFont: UIFont {
        return .systemFont(ofSize: costFontSize, weight: .regular)
    }
    
    @IBInspectable var costText: String? {
        get { return costTitle.text }
        set { costTitle.text = newValue }
    }
    
    @IBInspectable public var costValueFontSize: CGFloat = 17.0 {
        didSet {
            costValue.font = costValueTextFont
        }
    }
    
    private var costValueTextFont: UIFont {
        return .boldSystemFont(ofSize: costValueFontSize)
    }
    
    @IBInspectable var costValueText: String? {
        get { return costValue.text }
        set { costValue.text = newValue }
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
        
        backgroundColor = .white
        layer.cornerRadius = CommonStyle.cornerRadius
        
        self.borderWidth = CommonStyle.borderWidth
        self.borderColor = .montreal
        
        addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        topBarView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        topBarView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        topBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        topBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        
        topBarView.addSubview(topBarTitle)
        topBarTitle.translatesAutoresizingMaskIntoConstraints = false
        topBarTitle.textColor = .zurich
        topBarTitle.font = .semibold15
        
        topBarTitle.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor, constant: 0).isActive = true
        topBarTitle.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor, constant: 0).isActive = true
        
        topMainContainerView.backgroundColor = .clear
        addSubview(topMainContainerView)
        topMainContainerView.translatesAutoresizingMaskIntoConstraints = false
        topMainContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 10).isActive = true
        topMainContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        topMainContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        topMainContainerView.heightAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_IMAGE)).isActive = true
        
        
        topMainContainerView.addSubview(paymentLogo)
        paymentLogo.contentMode = .scaleAspectFit
        
        paymentLogo.translatesAutoresizingMaskIntoConstraints = false
        paymentLogo.topAnchor.constraint(equalTo: topMainContainerView.topAnchor, constant: 0).isActive = true
        paymentLogo.leadingAnchor.constraint(equalTo: topMainContainerView.leadingAnchor, constant: 0).isActive = true
        paymentLogo.heightAnchor.constraint(equalToConstant: CGFloat(STATIC_HEIGHT_IMAGE)).isActive = true
        paymentLogo.widthAnchor.constraint(equalTo: paymentLogo.heightAnchor).isActive = true
        paymentLogo.bottomAnchor.constraint(equalTo: topMainContainerView.bottomAnchor, constant: 0).isActive = true
        paymentLogo.image = UIImage(named: "defaultSmallPurse")
        
        paymentNumber.textColor = .sydney
        paymentNumber.font = .semibold17
        paymentNumber.textAlignment = .left
        paymentNumber.numberOfLines = 1
        
        costTitle.textColor = .sydney
        costTitle.font = .medium13
        costTitle.textAlignment = .left
        costTitle.numberOfLines = 1
        
        costValue.textColor = .sydney
        costValue.font = .semibold15
        costValue.numberOfLines = 1
        costValue.textAlignment = .left
        
        topMainContainerView.addSubview(paymentNumber)
        
        paymentNumber.translatesAutoresizingMaskIntoConstraints = false
        paymentNumber.centerYAnchor.constraint(equalTo: topMainContainerView.centerYAnchor, constant: 0).isActive = true
        paymentNumber.trailingAnchor.constraint(equalTo: topMainContainerView.trailingAnchor, constant: 0).isActive = true
        paymentNumber.leadingAnchor.constraint(equalTo: paymentLogo.trailingAnchor, constant: 10).isActive = true
        
        
        
        addSubview(costTitle)
        costTitle.translatesAutoresizingMaskIntoConstraints = false
        costTitle.topAnchor.constraint(equalTo: topMainContainerView.bottomAnchor, constant: 10).isActive = true
        costTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        costTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        
        addSubview(costValue)
        costValue.translatesAutoresizingMaskIntoConstraints = false
        costValue.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        costValue.topAnchor.constraint(equalTo: costTitle.bottomAnchor, constant: 3).isActive = true
        costValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        costValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        updateConstraintsIfNeeded()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //FIXME: - change this on getting width of parent
        topBarView.topRoundCorners(cornerRadius: Double(CommonStyle.cornerRadius))
        
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
        paymentLogo.image = image
    }
}
