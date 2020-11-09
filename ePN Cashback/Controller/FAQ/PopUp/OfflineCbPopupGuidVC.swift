//
//  OfflineCbPopupGuidVC.swift
//  CashBackEPN
//
//  Created by Александр Кузьмин on 21/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Lottie

class OfflineCbPopupGuidVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var howToBuyWithCbLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView() {
        howToBuyWithCbLabel.text = NSLocalizedString("FAQ_howToBuy", comment: "")
        let animationView = AnimationView(name: "offlineCBGuide")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        contentView.clipsToBounds = false
        contentView.layer.cornerRadius = CommonStyle.cornerRadius
        contentView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        howToBuyWithCbLabel.translatesAutoresizingMaskIntoConstraints = false
        howToBuyWithCbLabel.font = .bold17
        howToBuyWithCbLabel.textColor = .sydney
        animationView.topAnchor.constraint(equalTo: howToBuyWithCbLabel.bottomAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        self.view.layoutSubviews()
        animationView.play()
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
