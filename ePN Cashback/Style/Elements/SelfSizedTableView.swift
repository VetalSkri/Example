//
//  SelfSizingTableView.swift
//  Backit
//
//  Created by Александр Кузьмин on 09/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
  
  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
    self.layoutIfNeeded()
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: contentSize.width, height: contentSize.height)
  }
}
