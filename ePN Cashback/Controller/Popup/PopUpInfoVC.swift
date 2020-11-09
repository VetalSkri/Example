//
//  PopUpActivatePromocodeVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 29/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class PopUpInfoVC: UIViewController {

    @IBOutlet weak var popup: EPNPopUpInfo!
    var viewModel: PopUpInfoModelType!
    
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
        popup.setupImage(currentImage: viewModel.getImageInfo()!)
        popup.setInfoText(info: viewModel.getTitleText())
        
        popup.handlerClosePopUp = { [unowned self] (popup) in
            self.dismiss(animated: true)
        }
        popup.updateConstraintsIfNeeded()
        popup.setNeedsLayout()
        
    }
}
