//
//  PurseTypeTableCell.swift
//  Backit
//
//  Created by Виталий Скриганюк on 24.06.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit
import SnapKit

class PurseTypeTableCell: UITableViewCell {
    
    // Containers View's
    private var containerView = UIView()
    private var mainView = UIView()
    private var hintView = UIView()
    private var infoView = UIView()
    
    private var namePlateView = UIView()
    private var namePlateLabel = UILabel()
    private var logoView = PurseLogoView()
    private var circleHelperView = UIView()
    private var helperBlockView = UIView()
    
    // Content View's
    private var purseNameLabel = UILabel()
    private var charityTitle = UILabel()
    
    private var hintInfoView = UIView()
    private var hintTitle = UILabel()
    private var hintText = UILabel()
    
    private var hintActionView = UIView()
    private var hintCancelButton = UIButton()
    
    private var purse: PurseType!
    
    var index: Int?
    var isHintNeed: Bool = false
    
    weak var delegate: PurseTypeCellDelegate?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelHint() {
        switch purse {
        case .cardUrkV2:
            Util.isUkrainV2PurseHint = false
        default:
            Util.isCardsPursesHint = false
        }
        hideHint()
    }
    
    private func setupSubviews() {
        mainView.addSubview(infoView)
        mainView.addSubview(logoView)
        mainView.addSubview(namePlateView)
        mainView.addSubview(helperBlockView)
        
        namePlateView.addSubview(namePlateLabel)
        
        helperBlockView.addSubview(circleHelperView)
        
        circleHelperView.backgroundColor = .zurich
        circleHelperView.cornerRadius = 4
        
        namePlateView.backgroundColor = .budapest
        helperBlockView.backgroundColor = .budapest
        
        namePlateLabel.text = NSLocalizedString("New", comment: "")
        namePlateLabel.textColor = .zurich
        namePlateLabel.font = .semibold10
        
        containerView.addSubview(mainView)
        containerView.addSubview(hintView)
        
        hintView.cornerRadius = 8
        
        
        hintInfoView.addSubview(hintTitle)
        hintInfoView.addSubview(hintText)
        
        hintTitle.numberOfLines = 0
        hintTitle.font = .semibold13
        
        hintText.numberOfLines = 0
        hintText.font = .medium13
        hintText.textColor = UIColor(red: 0.365, green: 0.365, blue: 0.365, alpha: 1)
        
        
        hintActionView.addSubview(hintCancelButton)
        
        hintCancelButton.addTarget(self, action: #selector(cancelHint), for: .touchDown)
        
        hintCancelButton.setImage(UIImage(named: "closeHint"), for: .normal)
        
        hintView.addSubview(hintInfoView)
        hintView.addSubview(hintActionView)
        
        hintView.backgroundColor = UIColor(hex: "E1FFC7")
        
        containerView.addShadows(color: #colorLiteral(red: 0.9406071305, green: 0.9406071305, blue: 0.9406071305, alpha: 1), radius: 14, opacity: 1, offset: CGSize(width: 2, height: 4))
        
        infoView.addSubview(purseNameLabel)
        infoView.addSubview(charityTitle)
        
        charityTitle.numberOfLines = 0
        
        containerView.cornerRadius = CommonStyle.cardCornerRadius
        hintView.layer.cornerRadius = CommonStyle.cardCornerRadius
        
        containerView.borderColor = .montreal
        logoView.backgroundColor = .clear
        containerView.backgroundColor = .zurich
        
        purseNameLabel.textColor = .sydney
        purseNameLabel.font = .semibold13
        
        charityTitle.textColor = .minsk
        charityTitle.font = .medium13
        
        self.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(6)
        }
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(84)
        }
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(logoView.snp.right).offset(12)
            make.bottom.equalToSuperview().inset(24)
        }
        namePlateView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(22)
            make.right.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(42)
        }
        helperBlockView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(22)
            make.height.equalTo(16)
            make.width.equalTo(4)
            make.right.equalTo(namePlateView.snp.left)
        }
        circleHelperView.snp.makeConstraints { (make) in
            make.height.equalTo(8)
            make.width.equalTo(8)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(-4)
        }
        namePlateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        purseNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        charityTitle.snp.makeConstraints { make in
            make.top.equalTo(purseNameLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        hintView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(CommonStyle.modalCornerRadius)
            make.right.equalToSuperview().inset(CommonStyle.modalCornerRadius)
            make.bottom.equalToSuperview().inset(CommonStyle.modalCornerRadius)
        }
        hintInfoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(CommonStyle.modalCornerRadius)
            make.left.equalToSuperview().inset(CommonStyle.modalCornerRadius)
            make.right.equalTo(hintActionView.snp.left)
            make.bottom.equalToSuperview().inset(CommonStyle.modalCornerRadius)
        }
        hintTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(255)

        }
        hintText.snp.makeConstraints { (make) in
            make.top.equalTo(hintTitle.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(255)
        }
        hintActionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(40)
            make.bottom.equalToSuperview().inset(CommonStyle.modalCornerRadius)
        }
        hintCancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(4)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }

    private func hideHint() {
        self.hintView.isHidden = true
        self.hintCancelButton.isHidden = true
        self.hintView.snp.remakeConstraints { (make) in
            make.height.equalTo(0)
        }
        self.delegate?.reloadCell(index: self.index!)
    }
    
    public func setupCell(purse: PaymentInfoData, index: Int) {
        self.index = index
        self.purse = purse.purseType
        self.hintTitle.text = purse.hintInfo?.title
        self.hintText.text = purse.hintInfo?.text
        
        containerView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(index == 0 ? 15 : 6)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(6)
            layoutIfNeeded()
        }
        isHintNeed = purse.hintView
        switch purse.purseType {
        case .cardUrkV2:
            namePlateView.isHidden = false
            helperBlockView.isHidden = false
            if Util.isUkrainV2PurseHint && purse.hintView {
                hintView.isHidden = false
                hintView.isHidden = !purse.hintView
                self.mainView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalTo(self.hintView.snp.top)
                }
                self.view.layoutIfNeeded()
            } else {
                hintView.isHidden = true
                self.mainView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                self.layoutIfNeeded()
            }
        case .cardpay:
            namePlateView.isHidden = true
            helperBlockView.isHidden = true
            if Util.isCardsPursesHint &&
                purse.hintView {
                hintView.isHidden = false
                hintView.isHidden = !purse.hintView
                self.mainView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalTo(self.hintView.snp.top)
                }
                self.view.layoutIfNeeded()
            } else {
                hintView.isHidden = true
                self.mainView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                self.layoutIfNeeded()
            }
        default:
            hintView.isHidden = true
            namePlateView.isHidden = true
            helperBlockView.isHidden = true
            self.mainView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
        
    
        if purse.purseType == PurseType.khabensky {
            purseNameLabel.text = NSLocalizedString("CharityTitle", comment: "")
            purseNameLabel.textColor = .toronto
            charityTitle.text = NSLocalizedString("CharitySubitle", comment: "")
            logoView.setup(type: .single, image: UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseSmalllogo(forType: purse.purseType!)))
        } else {
            let amountInfo = purse.attributes.info!.filter{
                $0.currency == "USD"
            }
            var amount = "\(amountInfo.first!.min)"
            if amountInfo.first!.min.checkWholeNumber() {
                amount = "\(Int(amountInfo.first!.min))"
            }
            if !amountInfo.isEmpty {
                charityTitle.text = NSLocalizedString("The min. withdrawal amount is", comment: "") + " " + " \(amount) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: "USD"))"
            } else {
                charityTitle.text = NSLocalizedString("The min. withdrawal amount is", comment: "") + " " + "\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: purse.attributes.info?.first?.currency ?? ""))"
            }
            purseNameLabel.textColor = .black
            
            // Перекрытие название карты ( одна ячейка для карт )
            if purse.purseType == PurseType.cardpay {
                purseNameLabel.text = NSLocalizedString("Bank card", comment: "")
                 charityTitle.text = NSLocalizedString("The min. withdrawal amount from", comment: "") + " " + " \(amount) \(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: "USD"))"
                logoView.setup(type: .multiCard, image: nil)
            } else {
                purseNameLabel.text = purse.attributes.name
                logoView.setup(type: .single, image: UIImage(named: LocalSymbolsAndAbbreviations.getPurseChooseSmalllogo(forType: purse.purseType!)))
            }
        }
    }
}
