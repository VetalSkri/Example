//
//  OfflineCollectionViewCellProtocol.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import UIKit

protocol OfflineCollectionViewCellDelegate:class {
    func scroll(newHeight: CGFloat, animate: Bool)
    func headerViewHeight() -> CGFloat
    func minHeaderHeight() -> CGFloat
    func maxHeaderHeight() -> CGFloat
    func hideButton()
    func showButton()
}

class OfflineCollectionViewCellBase: UICollectionViewCell, UIScrollViewDelegate {
   
    weak var delegate: OfflineCollectionViewCellDelegate?
    var startContentOffset: CGFloat = 0
    var disableDelegateHandler: Bool = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if disableDelegateHandler {
            return
        }
        
        let contentOffset = scrollView.contentOffset.y
        let minHeight = delegate?.minHeaderHeight() ?? 0
        let maxHeight = delegate?.maxHeaderHeight() ?? 0
        let headerViewHeight = delegate?.headerViewHeight() ?? 0
        let newHeaderViewHeight = headerViewHeight - contentOffset
        if newHeaderViewHeight > maxHeight {
            delegate?.scroll(newHeight: maxHeight, animate: false)
        } else if newHeaderViewHeight < minHeight {
            delegate?.scroll(newHeight: minHeight, animate: false)
        } else {
            delegate?.scroll(newHeight: newHeaderViewHeight, animate: false)
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endOfScroll(scrollView: scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endOfScroll(scrollView: scrollView)
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        disableDelegateHandler = false
    }
    
    private func endOfScroll(scrollView: UIScrollView) {
        if disableDelegateHandler {
            disableDelegateHandler = false
            return
        }
        
        let minHeight = delegate?.minHeaderHeight() ?? 0
        let maxHeight = delegate?.maxHeaderHeight() ?? 0
        let headerViewHeight = delegate?.headerViewHeight() ?? 0
        if headerViewHeight < maxHeight && (headerViewHeight - minHeight) > (maxHeight - minHeight) / 2 {
            delegate?.scroll(newHeight: maxHeight, animate: true)
        }
        if headerViewHeight > minHeight && (headerViewHeight - minHeight) < (maxHeight - minHeight) / 2 {
            delegate?.scroll(newHeight: minHeight, animate: true)
        }
    }
    
}
