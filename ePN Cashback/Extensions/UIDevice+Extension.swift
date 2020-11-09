//
//  UIDevice+Extension.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 15/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIDevice {
    
    private struct ScreenSizes {
        static let current: CGSize = UIScreen.main.bounds.size
        static let iPhone4: CGSize = CGSize(width: 320.0, height: 480.0)
        static let iPhone5: CGSize = CGSize(width: 320.0, height: 568.0)
        static let iPhone6: CGSize = CGSize(width: 375.0, height: 667.0)
        static let iPhone6Plus: CGSize = CGSize(width: 414.0, height: 736.0)
        static let iPhoneX: CGSize = CGSize(width: 375.0, height: 812.0)
        static let iPhoneXR: CGSize = CGSize(width: 414.0, height: 896.0)
        
        // Сомнительная функция
        static func sizeForDiagonal(_ diagonal: Diagonal) -> CGSize {
            switch diagonal {
            case .unknown:
                return CGSize.zero
            case .iPhone4:
                return iPhone4
            case .iPhone5:
                return iPhone5
            case .iPhone6:
                return iPhone6
            case .iPhone6Plus:
                return iPhone6Plus
            case .iPhoneX:
                return iPhoneX
            case .iPhoneXR:
                return iPhoneXR
            }
        }
    }
    
    enum Diagonal: CGFloat {
        case unknown = 0
        case iPhone4 = 3.5
        case iPhone5 = 4.0
        case iPhone6 = 4.7
        case iPhone6Plus = 5.5
        case iPhoneX = 5.8
        case iPhoneXR = 6.1
    }
    
    var diagonal: Diagonal {
        guard self.model == "iPhone" else { return .unknown}
        
        let size = screenSize
        let width = size.width
        let height = size.height
        
        var d: Diagonal = .unknown
        
        if width == 320 {
            if height == 480 {
                d = .iPhone4;
            } else if height == 568 {
                d = .iPhone5;
            }
        } else if width == 375 && height == 667 {
            d = .iPhone6;
        } else if width == 414 && height == 736 {
            d = .iPhone6Plus;
        } else if width == 375 && height == 812 {
            d = .iPhoneX;
        } else if width == 414 && height == 896 {
            d = .iPhoneXR;
        }
        
        return d
    }
    
    var screenSize: CGSize {
        return ScreenSizes.current
    }
    
    static func screenSize(for diagonal: Diagonal? = nil) -> CGSize {
        if let d = diagonal {
            return ScreenSizes.sizeForDiagonal(d)
        }
        return ScreenSizes.current
    }
    
}


