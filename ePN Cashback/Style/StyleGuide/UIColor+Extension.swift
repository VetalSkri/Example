//
//  UIColor+Extension.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 27/08/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

private extension Int64 {
    func duplicate4bits() -> Int64 {
        return (self << 4) + self
    }
}

extension UIColor {
    
    private convenience init(hex3: Int64, alpha: Float) {
        self.init(red: CGFloat(((hex3 & 0xF00) >> 8).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex3 & 0x0F0) >> 4).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex3 & 0x00F) >> 0).duplicate4bits()) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init(hex4: Int64, alpha: Float?) {
        self.init(red: CGFloat(((hex4 & 0xF000) >> 12).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex4 & 0x0F00) >> 8).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex4 & 0x00F0) >> 4).duplicate4bits()) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat(((hex4 & 0x000F) >> 0).duplicate4bits()) / 255.0)
    }

    private convenience init(hex6: Int64, alpha: Float) {
        self.init(red: CGFloat((hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((hex6 & 0x0000FF) >> 0) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init(hex8: Int64, alpha: Float?) {
        self.init(red: CGFloat((hex8 & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((hex8 & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((hex8 & 0x0000FF00) >> 8) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat((hex8 & 0x000000FF) >> 0) / 255.0)
    }
    
    convenience init?(hex: String, alpha: Float = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        guard let hexVal = Int64(cString, radix: 16) else {
            return nil
        }
        
        switch cString.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
            
        case 4:
            self.init(hex4: hexVal, alpha: alpha)
            
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
            
        case 8:
            self.init(hex8: hexVal, alpha: alpha)
            
        default:
            return nil
        }
    }
    
    static var doodleDefault: UIColor {
        UIColor.init(hex: "#00BDFF")!
    }
    
    static var munich: UIColor {
        return UIColor(hex: "#85EBF5")!
    }
    
    static var vilnius: UIColor {
        return UIColor(hex: "#B5FF73")!
    }
    
    static var budapest: UIColor {
        return UIColor(hex: "#00D961")!
    }
    
    static var prague: UIColor {
        return UIColor(hex: "#FF4F61")!
    }
    
    static var toronto: UIColor {
        return UIColor(hex: "#00BDFF")!
    }
    
    static var calgary: UIColor {
        return UIColor(hex: "#FF54BF")!
    }
    
    static var vancouver: UIColor {
        return UIColor(hex: "#CFFC00")!
    }
    
    static var linkNEW: UIColor {
        return UIColor(hex: "#296AB6")!
    }
    
    static var linkCustom: UIColor {
        return UIColor(hex: "#287FE4")!
    }
    
    static var ottawa: UIColor {
        return UIColor(hex: "#FAFAFA")!
    }
    
    static var paris: UIColor {
        return UIColor(hex: "#F7F7F7")!
    }
    
    static var moscow: UIColor {
        return UIColor(hex: "#202020")!
    }
    
    static var sydney: UIColor {
        return UIColor(hex: "#000000")!
    }
    
    static var zurich: UIColor {
        return .white
    }
    
    static var montreal: UIColor {
        return UIColor(hex: "#F0F0F0")!
    }
    
    static var minsk: UIColor {
        return UIColor(hex: "#9E9E9E")!
    }
    
    static var london: UIColor {
        return UIColor(hex: "#5D5D5D")!
    }
    
    class var shadow: UIColor { //SUPPORT
        return UIColor(hex: "d0d0d0")!
    }
        
    class var loginStartGradientColor: UIColor {
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.55)
    }
    
}
