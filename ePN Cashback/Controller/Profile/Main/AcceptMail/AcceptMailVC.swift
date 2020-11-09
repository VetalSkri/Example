//
//  AcceptMailVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 10.04.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol AcceptMailVCDelegate: class {
    func emailIsSend()
}

class AcceptMailVC: UIViewController {

    weak var delegate: AcceptMailVCDelegate?
    
    //Main container view
    @IBOutlet weak var mainContainerView: UIView!
    
    //Title and subtitle labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //Resend button
    @IBOutlet weak var resendButtonLabel: UILabel!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var resendActivityIndicator: UIActivityIndicatorView!
    
    
    //Close button
    @IBOutlet weak var closeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        mainContainerView.cornerRadius = CommonStyle.newCornerRadius
        mainContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.font = .bold24
        titleLabel.textColor = .sydney
        titleLabel.text = NSLocalizedString("Check your email!", comment: "")
        
        subtitleLabel.font = .medium15
        subtitleLabel.textColor = .moscow
        subtitleLabel.text = NSLocalizedString("A confirmation mail has been set to your mailbox", comment: "")
        
        resendButtonLabel.font = .semibold13
        resendButtonLabel.textColor = .moscow
        resendButtonLabel.text = NSLocalizedString("Send again", comment: "")
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: dashedView.frame.size.width, y: 0)])
        shapeLayer.path = path
        dashedView.layer.addSublayer(shapeLayer)
        dashedView.clipsToBounds = true
        
        closeButton.backgroundColor = .moscow
        closeButton.titleLabel?.font = .semibold15
        closeButton.setTitleColor(.zurich, for: .normal)
        closeButton.setTitle(NSLocalizedString("Ok, thanks", comment: ""), for: .normal)
    }
    
    @IBAction func resendButtonClicked(_ sender: Any) {
        dashedView.isHidden = true
        resendButtonLabel.isHidden = true
        resendActivityIndicator.startAnimating()
        ProfileApiClient.confirmEmail { [weak self] (result) in
            switch result {
            case .success(_):
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.delegate?.emailIsSend()
                })
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                self?.resendActivityIndicator.stopAnimating()
                self?.dashedView.isHidden = false
                self?.resendButtonLabel.isHidden = false
                break
            }
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
