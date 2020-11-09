//
//  SuccessOrderViewController.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 24/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import StoreKit

class SuccessOrderViewController: UIViewController {

    var viewModel: SuccessOrderViewModel!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var purseInfoLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var openPaymentHistoryLabel: EPNLinkLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.cornerRadius = CommonStyle.cornerRadius
        self.view.backgroundColor = .ottawa
        openPaymentHistoryLabel.style = .partly
        self.openPaymentHistoryLabel.changeColorOfLink(for: viewModel.goToPaymentHistoryText)
        orderTitleLabel.font = .bold17
        orderTitleLabel.textColor = .sydney
        orderAmountLabel.font = .bold20
        orderAmountLabel.textColor = .sydney
        subtitleLabel.font = .medium15
        subtitleLabel.textColor = .minsk
        purseInfoLabel.font = .bold17
        purseInfoLabel.textColor = .sydney
        setupView()
    }
    
    private func setupView() {
        orderTitleLabel.text = NSLocalizedString("The payout is successfully ordered", comment: "")
        subtitleLabel.text  = NSLocalizedString("To", comment: "")
        orderAmountLabel.text = viewModel.amount
        purseInfoLabel.text = viewModel.cardNumber
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        viewModel.close {
            SKStoreReviewController.requestReview()
        }
    }
    
    @IBAction func openPaymentHistoryClicked(_ sender: Any) {
        viewModel.goToPaymentHistory {
            SKStoreReviewController.requestReview()
        }
    }
    
}
