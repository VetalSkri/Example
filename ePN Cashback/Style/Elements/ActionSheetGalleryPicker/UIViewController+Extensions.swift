//
//  UIViewController+Extensions.swift
//  Backit
//
//  Created by Александр Кузьмин on 13/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
    
    func hideKeyboardScroll(table: UITableView) {
        table.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
    }
}
