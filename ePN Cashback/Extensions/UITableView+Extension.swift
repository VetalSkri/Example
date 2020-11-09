//
//  UITableView+Extension.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 16/01/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setupStyle() {
        self.tableFooterView = UIView()
        self.separatorStyle = .none
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: 0 - self.contentInset.top), animated: animated)
//        let indexPath = IndexPath(row: 0, section: 0)
//        if self.hasRowAtIndexPath(indexPath: indexPath) {
//            self.scrollToRow(at: indexPath, at: .top, animated: animated)
//        }
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
}
