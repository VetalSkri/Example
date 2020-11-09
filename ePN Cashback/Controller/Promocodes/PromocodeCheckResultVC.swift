//
//  PromocodeCheckResultVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 28/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD

class PromocodeCheckResultVC: UIViewController {

    @IBOutlet weak var headerStatusResultLabel: UILabel!
    @IBOutlet weak var promocodeNameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var promocodePeriodLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var promocodeValidityLabel: UILabel!
    @IBOutlet weak var activateButton: EPNButton!
    
    var viewModel: PromocodeCheckResultModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorSpinner(UIColor.sydney)
        self.view.backgroundColor = .zurich
        setUpNavigationBar()
        setUpMainInfo()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    func setUpNavigationBar() {
        title = viewModel?.headTitle
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setUpMainInfo() {
        headerStatusResultLabel.text = viewModel?.headerStatusResultTitle
        promocodeNameLabel.text = viewModel?.promocodeNameText()
        periodLabel.text = viewModel?.activatePeriodTitle
        promocodePeriodLabel.text = viewModel?.activatePeriodText()
        validityLabel.text = viewModel?.validityTitle
        promocodeValidityLabel.text = viewModel?.validityText()
        activateButton.text = viewModel?.activateButtonTitle
        
        headerStatusResultLabel.font = .bold17
        promocodeNameLabel.font = .medium15
        periodLabel.font = .medium13
        promocodePeriodLabel.font = .semibold17
        validityLabel.font = .medium13
        promocodeValidityLabel.font = .semibold17
        
        headerStatusResultLabel.textColor = .sydney
        promocodeNameLabel.textColor = .minsk
        periodLabel.textColor = .sydney
        promocodePeriodLabel.textColor = .sydney
        validityLabel.textColor = .sydney
        promocodeValidityLabel.textColor = .sydney
        
        activateButton.handler = { [weak self] (button) in
            ProgressHUD.show()
            self?.activateButton.style = .disabled
            self?.viewModel?.activatePromocode(completion: { [weak weakSelf = self] (activatedPromo) in
                OperationQueue.main.addOperation {
                    ProgressHUD.dismiss()
                    weakSelf?.activateButton.style = .primary
                    NotificationCenter.default.post(name: .promocodeIsActivated, object: activatedPromo)
                    weakSelf?.viewModel.goOnBack()
                }
                }, failure: { [weak self] in
                    OperationQueue.main.addOperation { [weak self] in
                        ProgressHUD.dismiss()
                        self?.activateButton.style = .primary
                        NotificationCenter.default.post(name: .promocodeIsActivated, object: nil)
                        self?.viewModel.goOnBack()
                    }
            })
        }
    }
    
    @objc private func backButtonTapped() {
        viewModel.goOnBack()
    }
}
