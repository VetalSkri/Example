//
//  UIApplication+Extensions.swift
//  Backit
//
//  Created by Александр Кузьмин on 19/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
