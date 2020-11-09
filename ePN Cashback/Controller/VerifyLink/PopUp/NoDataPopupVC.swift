//
//  NoDataPopupVC.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 23/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class NoDataPopupVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundedPopupView: UIView!
    
    let blueView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupBlurView() {
        blueView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blueView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blueView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .light)
        view.insertSubview(blueView, at: 0)
        blueView.effect = blurEffect
        setupBlurView()

        setupView()
    }
    
    func setupView() {
        roundedPopupView.layer.cornerRadius = CommonStyle.cornerRadius
        titleLabel.text = NSLocalizedString("dynamic_no_data", comment: "")
        titleLabel.font = .medium15
        titleLabel.textColor = .sydney
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
