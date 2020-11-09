//
//  Double+Extension.swift
//  Backit
//
//  Created by Александр Кузьмин on 25/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

extension Double {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func checkWholeNumber() -> Bool {
        let rounded = self.rounded()
        return rounded == self ? true : false
    }
    
    func checkIfWholeOrHalfNumber() -> Bool {
        let newValue = self.truncatingRemainder(dividingBy: 1)
        
        if newValue * 10 != 5 {
            return true
        } else {
            return false
        }
    }
}

extension Float {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
}
