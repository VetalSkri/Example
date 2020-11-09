//
//  ErrorResultOfflineCBVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 23/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class ErrorResultOfflineCBVC: UIViewController {

    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var successButton: EPNButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainContainer()
    }
    
    func setupMainContainer() {
        mainContainer.clipsToBounds = true
        mainContainer.layer.cornerRadius = 14
        image.image = UIImage(named: "errorScan")
        successButton.style = .primary
        successButton.text = NSLocalizedString("Ok", comment: "")
        infoLabel.text = errorMessage
        infoLabel.font = .semibold17
        infoLabel.textColor = .sydney
        successButton.handler = { [weak self] (button) in
            self?.dismiss(animated: true)
        }
    }


}
