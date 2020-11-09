//
//  SuccessResultOfflineCBVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 12/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SuccessResultOfflineCBVC: UIViewController {

    @IBOutlet weak var headTitleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var closeButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headTitleLabel.text = NSLocalizedString("SuccessScanTitle", comment: "")
        infoLabel.text = NSLocalizedString("SuccessScanText", comment: "")
        
        headTitleLabel.font = .semibold17
        headTitleLabel.textColor = .sydney
        
        infoLabel.font = .medium15
        infoLabel.textColor = .sydney

        let tap = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(tap)
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }

}
