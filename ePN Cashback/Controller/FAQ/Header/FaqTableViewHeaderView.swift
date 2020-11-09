//
//  FaqTableViewHeaderView.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 21/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol FaqTableViewHeaderViewDelegate : class {
    func cardViewSelected(cardViewIndex: Int)
}

class FaqTableViewHeaderView: UIView {

    weak var delegate : FaqTableViewHeaderViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstCardView: UIView!
    @IBOutlet weak var secondCardView: UIView!
    @IBOutlet weak var thirdCardView: UIView!
    @IBOutlet weak var fourthCardView: UIView!
    @IBOutlet weak var fifthCardView: UIView!
    @IBOutlet weak var sixthCardView: UIView!
    @IBOutlet var contentView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FaqTableViewHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = .zurich
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    func setupView() {
        
        titleLabel.text = NSLocalizedString("FAQ_ImportantThings", comment: "")
        titleLabel.font = .bold17
        titleLabel.textColor = .sydney
        firstCardView.clipsToBounds = true
        firstCardView.layer.cornerRadius = CommonStyle.cornerRadius
        firstCardView.backgroundColor = .sydney
        let whatIsCBLabel = UILabel()
        firstCardView.addSubview(whatIsCBLabel)
        whatIsCBLabel.translatesAutoresizingMaskIntoConstraints = false
        whatIsCBLabel.topAnchor.constraint(equalTo: firstCardView.topAnchor, constant: 15).isActive = true
        whatIsCBLabel.leadingAnchor.constraint(equalTo: firstCardView.leadingAnchor, constant: 5).isActive = true
        whatIsCBLabel.centerXAnchor.constraint(equalTo: firstCardView.centerXAnchor).isActive = true
        whatIsCBLabel.bottomAnchor.constraint(equalTo: firstCardView.bottomAnchor, constant: -15).isActive = true
        whatIsCBLabel.numberOfLines = 2
        whatIsCBLabel.textAlignment = .center
        whatIsCBLabel.font = .semibold15
        whatIsCBLabel.text = NSLocalizedString("FAQ_whatIsCB", comment: "")
        whatIsCBLabel.textColor = .zurich
        
        secondCardView.clipsToBounds = true
        secondCardView.layer.cornerRadius = CommonStyle.cornerRadius
        secondCardView.backgroundColor = .sydney
        let howToBuyLabel = UILabel()
        secondCardView.addSubview(howToBuyLabel)
        howToBuyLabel.translatesAutoresizingMaskIntoConstraints = false
        howToBuyLabel.topAnchor.constraint(equalTo: secondCardView.topAnchor, constant: 15).isActive = true
        howToBuyLabel.leadingAnchor.constraint(equalTo: secondCardView.leadingAnchor, constant: 5).isActive = true
        howToBuyLabel.centerXAnchor.constraint(equalTo: secondCardView.centerXAnchor).isActive = true
        howToBuyLabel.bottomAnchor.constraint(equalTo: secondCardView.bottomAnchor, constant: -15).isActive = true
        howToBuyLabel.numberOfLines = 2
        howToBuyLabel.textAlignment = .center
        howToBuyLabel.font = .semibold15
        howToBuyLabel.text = NSLocalizedString("FAQ_howToBuy", comment: "")
        howToBuyLabel.textColor = .zurich
        
        thirdCardView.clipsToBounds = true
        thirdCardView.layer.cornerRadius = CommonStyle.cornerRadius
        thirdCardView.backgroundColor = .sydney
        let whatToDoAfterBuyLabel = UILabel()
        thirdCardView.addSubview(whatToDoAfterBuyLabel)
        whatToDoAfterBuyLabel.translatesAutoresizingMaskIntoConstraints = false
        whatToDoAfterBuyLabel.topAnchor.constraint(equalTo: thirdCardView.topAnchor, constant: 15).isActive = true
        whatToDoAfterBuyLabel.leadingAnchor.constraint(equalTo: thirdCardView.leadingAnchor, constant: 5).isActive = true
        whatToDoAfterBuyLabel.centerXAnchor.constraint(equalTo: thirdCardView.centerXAnchor).isActive = true
        whatToDoAfterBuyLabel.bottomAnchor.constraint(equalTo: thirdCardView.bottomAnchor, constant: -15).isActive = true
        whatToDoAfterBuyLabel.numberOfLines = 2
        whatToDoAfterBuyLabel.textAlignment = .center
        whatToDoAfterBuyLabel.font = .semibold15
        whatToDoAfterBuyLabel.text = NSLocalizedString("FAQ_whatToDoAfterBuy", comment: "")
        whatToDoAfterBuyLabel.textColor = .zurich
        
        fourthCardView.clipsToBounds = true
        fourthCardView.layer.cornerRadius = CommonStyle.cornerRadius
        fourthCardView.backgroundColor = .sydney
        let howOrderPaymentsLabel = UILabel()
        fourthCardView.addSubview(howOrderPaymentsLabel)
        howOrderPaymentsLabel.translatesAutoresizingMaskIntoConstraints = false
        howOrderPaymentsLabel.topAnchor.constraint(equalTo: fourthCardView.topAnchor, constant: 15).isActive = true
        howOrderPaymentsLabel.leadingAnchor.constraint(equalTo: fourthCardView.leadingAnchor, constant: 5).isActive = true
        howOrderPaymentsLabel.centerXAnchor.constraint(equalTo: fourthCardView.centerXAnchor).isActive = true
        howOrderPaymentsLabel.bottomAnchor.constraint(equalTo: fourthCardView.bottomAnchor, constant: -15).isActive = true
        howOrderPaymentsLabel.numberOfLines = 2
        howOrderPaymentsLabel.textAlignment = .center
        howOrderPaymentsLabel.font = .semibold15
        howOrderPaymentsLabel.text = NSLocalizedString("FAQ_howOrderPayments", comment: "")
        howOrderPaymentsLabel.textColor = .zurich
        
        fifthCardView.clipsToBounds = true
        fifthCardView.layer.cornerRadius = CommonStyle.cornerRadius
        fifthCardView.backgroundColor = .vancouver
        let onBoardingLabel = UILabel()
        fifthCardView.addSubview(onBoardingLabel)
        onBoardingLabel.translatesAutoresizingMaskIntoConstraints = false
        onBoardingLabel.topAnchor.constraint(equalTo: fifthCardView.topAnchor, constant: 15).isActive = true
        onBoardingLabel.leadingAnchor.constraint(equalTo: fifthCardView.leadingAnchor, constant: 5).isActive = true
        onBoardingLabel.centerXAnchor.constraint(equalTo: fifthCardView.centerXAnchor).isActive = true
        onBoardingLabel.bottomAnchor.constraint(equalTo: fifthCardView.bottomAnchor, constant: -15).isActive = true
        onBoardingLabel.numberOfLines = 2
        onBoardingLabel.textAlignment = .center
        onBoardingLabel.font = .semibold15
        onBoardingLabel.text = NSLocalizedString("FAQ_onBoarding", comment: "")
        onBoardingLabel.textColor = .sydney
        
        sixthCardView.clipsToBounds = true
        sixthCardView.layer.cornerRadius = CommonStyle.cornerRadius
        sixthCardView.backgroundColor = .vancouver
        let rulesLabel = UILabel()
        sixthCardView.addSubview(rulesLabel)
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        rulesLabel.topAnchor.constraint(equalTo: sixthCardView.topAnchor, constant: 15).isActive = true
        rulesLabel.leadingAnchor.constraint(equalTo: sixthCardView.leadingAnchor, constant: 5).isActive = true
        rulesLabel.centerXAnchor.constraint(equalTo: sixthCardView.centerXAnchor).isActive = true
        rulesLabel.bottomAnchor.constraint(equalTo: sixthCardView.bottomAnchor, constant: -15).isActive = true
        rulesLabel.numberOfLines = 2
        rulesLabel.textAlignment = .center
        rulesLabel.font = .semibold15
        rulesLabel.text = NSLocalizedString("FAQ_rules", comment: "")
        rulesLabel.textColor = .sydney
        
    }
    
    @IBAction func firstCardViewSelected(_ sender: Any) {
        delegate?.cardViewSelected(cardViewIndex: 1)
    }
    
    @IBAction func secondCardViewSelected(_ sender: Any) {
        delegate?.cardViewSelected(cardViewIndex: 2)
    }
    
    @IBAction func thirdCardViewSelected(_ sender: Any) {
        delegate?.cardViewSelected(cardViewIndex: 3)
    }
    
    @IBAction func fourthCardViewSelected(_ sender: Any) {
        delegate?.cardViewSelected(cardViewIndex: 4)
    }
    
    @IBAction func fifthCardViewSelected(_ sender: Any) {
        delegate?.cardViewSelected(cardViewIndex: 5)
    }
    
    @IBAction func sixthCardViewSelected(_ sender: Any) {
        delegate?.cardViewSelected(cardViewIndex: 6)
    }
    
    
}
