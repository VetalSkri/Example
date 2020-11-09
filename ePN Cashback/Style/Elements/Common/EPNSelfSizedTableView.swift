//
//  EPNSelfSizedTableView.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 24/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class EPNSelfSizedTableView: UITableView {
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

}
