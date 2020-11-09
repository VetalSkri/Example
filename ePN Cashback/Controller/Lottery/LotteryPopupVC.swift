//
//  LotteryPopupVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 14/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

//To show call code:
//let popUpVC = LotteryPopupVC(nibName: "LotteryPopupVC", bundle: nil)
//popUpVC.modalPresentationStyle = .overFullScreen
//popUpVC.modalTransitionStyle = .crossDissolve
//popUpVC.setup(percent: "100%", cashback: "105P", receiptNumber: "10002100230123120310230")
//self.present(popUpVC, animated: true, completion: nil)

class LotteryPopupVC: UIViewController {

    private var percent: String?
    private var cashback: String?
    private var receiptNumber: String?
    private var receiptValue: String?
    private var timer: Timer?
    private var scale = 1.0
    private var isFirstLayout = true
    
    //main container view
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerCenterYConstraint: NSLayoutConstraint!
    
    
    //Left logo and title
    @IBOutlet weak var logoImageView: UIImageView!
    
    //Close button
    @IBOutlet weak var closeButton: UIButton!
    
    //winner center title
    @IBOutlet weak var winnerCenterTitleLabel: UILabel!
    
    //win percent title
    @IBOutlet weak var winPercentLabel: UILabel!
    
    //cashback value
    @IBOutlet weak var cashbackValueLabel: UILabel!
    
    //recipt number
    @IBOutlet weak var receiptNumberLabel: UILabel!
    
    //receipt value
    @IBOutlet weak var receiptValueLabel: UILabel!
    @IBOutlet weak var receiptValueLabelTopConstraint: NSLayoutConstraint!
    
    
    //background image
    @IBOutlet weak var lotteryBackgroundImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        timer = nil
    }
    
    override func viewWillLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            setupView()
            moveUpAnimation()
        }
        pulseAnimation()
    }
    
    func setup(percent: String, cashback: String, receiptNumber: String, receiptValue: String? = nil) {
        self.percent = percent
        self.cashback = cashback
        self.receiptNumber = receiptNumber
        self.receiptValue = receiptValue
    }

    private func setupView() {
        containerView.backgroundColor = .toronto
        containerView.cornerRadius = CommonStyle.newCornerRadius
        
        winnerCenterTitleLabel.font = .extrabold28
        winnerCenterTitleLabel.textColor = .zurich
        winnerCenterTitleLabel.text = NSLocalizedString("Lottery winner", comment: "")
        
        winPercentLabel.adjustsFontSizeToFitWidth = true
        winPercentLabel.minimumScaleFactor = 0.5
        winPercentLabel.attributedText = NSAttributedString(string: percent ?? "", attributes: [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.zurich,
        NSAttributedString.Key.strokeWidth : -1.5,
        NSAttributedString.Key.font : UIFont.lotteryPercent
        ])
        
        cashbackValueLabel.text = "\(NSLocalizedString("Your cashback", comment: "")) \(cashback ?? "")"
        cashbackValueLabel.font = .bold17
        cashbackValueLabel.textColor = .zurich
        
        receiptNumberLabel.text = "\(NSLocalizedString("Receipt #", comment: "")) \(receiptNumber ?? "")"
        receiptNumberLabel.font = .semibold17
        receiptNumberLabel.textColor = .zurich
        
        receiptValueLabel.text = (receiptValue != nil) ? "\(NSLocalizedString("ReceiptValue", comment: "")) \(receiptValue ?? "")" : ""
        receiptValueLabel.font = .semibold17
        receiptValueLabel.textColor = .zurich
        receiptValueLabelTopConstraint.constant = (receiptValue != nil) ? 15 : 0
    }
    
    private func moveUpAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [weak self] in
            self?.containerCenterYConstraint.constant = 0
            self?.view.layoutIfNeeded()
        })
    }
    
    private func pulseAnimation() {
        if timer == nil {
          timer = Timer.scheduledTimer(timeInterval: 0.5,
                                       target: self,
                                       selector: #selector(updateTimer),
                                       userInfo: nil,
                                       repeats: true)
        }
    }
    
    @objc private func updateTimer() {
        self.scale = (self.scale == 1.0) ? 1.2 : 1.0
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.lotteryBackgroundImage.transform = CGAffineTransform(scaleX: CGFloat(self.scale), y: CGFloat(self.scale))
            self.winPercentLabel.attributedText = NSAttributedString(string: self.percent ?? "", attributes: [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : (self.scale == 1.0) ? UIColor.zurich : UIColor.vancouver,
            NSAttributedString.Key.strokeWidth : -1.5,
            NSAttributedString.Key.font : UIFont.lotteryPercent
            ])
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LotteryPopupVC: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("MYLOG: did start")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("MYLOG: did stop")
    }
}
