//
//  UIImageView+Extension.swift
//  CashBackEPN
//
//  Created by Александр on 13/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func rotate(radians: Float, animation: Bool, duration: Float = 0.0){
        if(animation){
            UIView.animate(withDuration:TimeInterval(duration), animations: { [weak self] in
                self?.rotateProcess(radians: radians)
            })
        }else{
            rotateProcess(radians: radians)
        }
    }

    private func rotateProcess(radians: Float){
        let angle:CGFloat = CGFloat(radians * 3.14/180.0)
        let rotation = CGAffineTransform(rotationAngle: angle)
        
        self.transform = rotation
    }

}
