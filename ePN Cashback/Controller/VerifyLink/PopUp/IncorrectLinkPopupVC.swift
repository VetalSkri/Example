//
//  IncorrectLinkPopupVC.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 23/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class IncorrectLinkPopupVC: UIViewController {

    @IBOutlet weak var roundedPopupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
    
    private func setupView() {
        roundedPopupView.layer.cornerRadius = CommonStyle.cornerRadius
        titleLabel.text = NSLocalizedString("dynamic_invalid_link_title", comment: "")
        descriptionLabel.text = NSLocalizedString("dynamic_invalid_link_description", comment: "")
        
        titleLabel.font = .bold17
        descriptionLabel.font = .medium15
        
        titleLabel.textColor = .sydney
        descriptionLabel.textColor = .sydney
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
