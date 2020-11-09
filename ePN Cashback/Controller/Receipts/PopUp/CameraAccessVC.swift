//
//  CameraAccessVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 18/02/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol CameraAccessVCDelegate: class {
    func manualEnterClicked()
}

class CameraAccessVC: UIViewController {

    weak var delegate: CameraAccessVCDelegate?
    
    //main container
    @IBOutlet weak var mainContainerView: UIView!
    
    //Labels
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //Manual enter button
    @IBOutlet weak var manualEnterContainerView: UIView!
    @IBOutlet weak var manualEnterLabel: UILabel!
    @IBOutlet weak var separatorDashedView: UIView!
    
    //Button fields
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var accessButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        mainContainerView.backgroundColor = .zurich
        mainContainerView.layer.cornerRadius = 10
        mainContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        mainTitleLabel.font = .bold20
        mainTitleLabel.textColor = .sydney
        mainTitleLabel.text = NSLocalizedString("Сamera access", comment: "")
        
        subtitleLabel.font = .medium15
        subtitleLabel.textColor = .london
        subtitleLabel.text = NSLocalizedString("Allow access to the camera to scan checks", comment: "")
        
        manualEnterLabel.font = .semibold13
        manualEnterLabel.textColor = .sydney
        manualEnterLabel.text = NSLocalizedString("Enter data manually", comment: "")
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: separatorDashedView.frame.size.width, y: 0)])
        shapeLayer.path = path
        separatorDashedView.layer.addSublayer(shapeLayer)
        
        backButton.backgroundColor = .paris
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        backButton.titleLabel?.font = .semibold15
        backButton.setTitleColor(.sydney, for: .normal)
        backButton.cornerRadius = 5
        
        accessButton.backgroundColor = .sydney
        accessButton.setTitle(NSLocalizedString("Allow", comment: ""), for: .normal)
        accessButton.titleLabel?.font = .semibold15
        accessButton.setTitleColor(.zurich, for: .normal)
        accessButton.cornerRadius = 5
    }

    @IBAction func manualEnterClicked(_ sender: Any) {
        dismiss(animated: true) { [weak self ] in
            self?.delegate?.manualEnterClicked()
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func accessButtonClicked(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
}
