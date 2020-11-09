//
//  InviteFriendsFaqVC.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 29/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class InviteFriendsFaqVC: UIViewController {

    
    var viewModel: InviteFriendsFaqModelType!
    
    //01 view fields
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstHeaderLabel: UILabel!
    @IBOutlet weak var firstDescriptionLabel: UILabel!
    @IBOutlet weak var firstLinkView: UIView!
    @IBOutlet weak var firstLinkLabel: UILabel!
    
    //02 view fields
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondHeaderLabel: UILabel!
    @IBOutlet weak var secondDescriptionLabel: UILabel!
    @IBOutlet weak var secondRegistrationView: UIView!
    @IBOutlet weak var secondRegistrationLabel: UILabel!
    @IBOutlet weak var secondRegistrationCountLabel: UILabel!
    
    //03 view fields
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdHeaderLabel: UILabel!
    @IBOutlet weak var thirdDescriptionLabel: UILabel!
    @IBOutlet weak var thirdOnPagelabel: UILabel!
    @IBOutlet weak var thirdInProcessView: UIView!
    @IBOutlet weak var thirdInProcessLabel: UILabel!
    @IBOutlet weak var thirdInProcessCountLabel: UILabel!
    @IBOutlet weak var thirdUnderLabel: UILabel!
    
    //04 view fields
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fourthHeaderLabel: UILabel!
    @IBOutlet weak var fourthWhenAcceptIncomeLabel: UILabel!
    @IBOutlet weak var fourthAllIncomeLabel: UILabel!
    @IBOutlet weak var fourthInAccountLabel: UILabel!
    @IBOutlet weak var fourthIncomeView: UIView!
    @IBOutlet weak var fourthIncomeLabel: UILabel!
    @IBOutlet weak var fourthIncomeCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupView()
    }
    
    func setUpNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.sydney,
            NSAttributedString.Key.font : UIFont.semibold17
        ]
        navigationController?.navigationBar.backgroundColor = .zurich
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.isTranslucent = false
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupView() {
        self.view.backgroundColor = .zurich
        
        firstHeaderLabel.textColor = .prague
        secondHeaderLabel.textColor =  .prague
        thirdHeaderLabel.textColor =  .prague
        fourthHeaderLabel.textColor =  .prague
        firstDescriptionLabel.textColor = UIColor.sydney
        secondDescriptionLabel.textColor = UIColor.sydney
        secondRegistrationLabel.textColor = UIColor.sydney
        thirdDescriptionLabel.textColor = UIColor.sydney
        thirdOnPagelabel.textColor = UIColor.sydney
        thirdInProcessLabel.textColor = UIColor.sydney
        fourthWhenAcceptIncomeLabel.textColor = UIColor.sydney
        fourthAllIncomeLabel.textColor = UIColor.sydney
        fourthInAccountLabel.textColor = UIColor.sydney
        fourthIncomeLabel.textColor = UIColor.sydney
        fourthIncomeCountLabel.textColor = UIColor.sydney
        thirdInProcessCountLabel.textColor = UIColor.sydney
        secondRegistrationCountLabel.textColor = UIColor.sydney
        firstLinkLabel.textColor = UIColor.minsk
        thirdUnderLabel.textColor = UIColor.minsk
        
        firstHeaderLabel.font = .bold20
        secondHeaderLabel.font = .bold20
        thirdHeaderLabel.font = .bold20
        fourthHeaderLabel.font = .bold20
        firstDescriptionLabel.font = .medium15
        secondDescriptionLabel.font = .medium15
        secondRegistrationLabel.font = .medium15
        thirdDescriptionLabel.font = .medium15
        thirdOnPagelabel.font = .medium15
        thirdInProcessLabel.font = .medium15
        fourthWhenAcceptIncomeLabel.font = .medium15
        fourthAllIncomeLabel.font = .medium15
        fourthInAccountLabel.font = .medium15
        fourthIncomeLabel.font = .medium15
        fourthIncomeCountLabel.font = .semibold15
        thirdInProcessCountLabel.font = .semibold15
        secondRegistrationCountLabel.font = .semibold15
        firstLinkLabel.font = .semibold17
        thirdUnderLabel.font = .medium13
        
        firstDescriptionLabel.text = viewModel.sendReferalLinkText
        secondDescriptionLabel.text = viewModel.friendsRegisterText
        secondRegistrationLabel.text = viewModel.registrationText
        secondRegistrationCountLabel.text = "10"
        thirdDescriptionLabel.text = viewModel.whenFriendBuyText
        thirdOnPagelabel.text = viewModel.onTheInviteFriendsText
        thirdInProcessLabel.text = viewModel.inProcessText
        thirdInProcessCountLabel.text = "0.123$"
        thirdUnderLabel.text = viewModel.inProcessingIncomeText
        fourthWhenAcceptIncomeLabel.text = viewModel.whenWeConfirmIncomeText
        fourthAllIncomeLabel.text = viewModel.allTheIncomeYouHaveText
        fourthInAccountLabel.text = viewModel.inTheAccountText
        fourthIncomeLabel.text = viewModel.incomeText
        fourthIncomeCountLabel.text = "6.12345$"
        
        firstView.layer.cornerRadius = CommonStyle.cornerRadius
        secondView.layer.cornerRadius = CommonStyle.cornerRadius
        thirdView.layer.cornerRadius = CommonStyle.cornerRadius
        fourthView.layer.cornerRadius = CommonStyle.cornerRadius
        firstLinkView.layer.cornerRadius = CommonStyle.cornerRadius
        secondRegistrationView.layer.cornerRadius = CommonStyle.cornerRadius
        thirdInProcessView.layer.cornerRadius = CommonStyle.cornerRadius
        fourthIncomeView.layer.cornerRadius = CommonStyle.cornerRadius
        
        firstView.backgroundColor = UIColor.zurich
        secondView.backgroundColor = UIColor.zurich
        thirdView.backgroundColor = UIColor.zurich
        fourthView.backgroundColor = UIColor.zurich
        
        firstView.borderWidth = CommonStyle.borderWidth
        secondView.borderWidth = CommonStyle.borderWidth
        thirdView.borderWidth = CommonStyle.borderWidth
        fourthView.borderWidth = CommonStyle.borderWidth
        
        firstView.borderColor = .montreal
        secondView.borderColor = .montreal
        thirdView.borderColor = .montreal
        fourthView.borderColor = .montreal
        
        firstLinkView.backgroundColor = .paris
        secondRegistrationView.backgroundColor = .paris
        thirdInProcessView.backgroundColor = .paris
        fourthIncomeView.backgroundColor = .paris
        
    }
    
    @objc func backButtonTapped() {
        viewModel.goOnBack()
    }
    
}
