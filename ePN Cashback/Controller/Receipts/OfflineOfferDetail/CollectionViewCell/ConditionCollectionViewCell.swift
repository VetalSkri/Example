//
//  ConditionCollectionViewCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 10/10/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import markymark

class ConditionCollectionViewCell: OfflineCollectionViewCellBase {
    
    private var viewModel: OfflineOfferDetailViewModel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var conditionsMarkdownView: MarkDownTextView!
    
    private func setupMarkdownStyle() {
        conditionsMarkdownView.backgroundColor = .paris
        
        conditionsMarkdownView.styling.headingStyling.textColorsForLevels = [
            .sydney, //H1 (i.e. # Title)
            .sydney, //H2, ... (i.e. ## Subtitle, ### Sub subtitle)
            .sydney  //H3
        ]
        conditionsMarkdownView.styling.headingStyling.isBold = true

        conditionsMarkdownView.styling.headingStyling.fontsForLevels = [
            .semibold17, //H1
            .bold17, //H2
            .medium15  //H3
        ]
        conditionsMarkdownView.styling.paragraphStyling.textColor = .sydney
        conditionsMarkdownView.styling.paragraphStyling.baseFont = .medium15
        conditionsMarkdownView.styling.listStyling.lineHeight = 4
        conditionsMarkdownView.styling.listStyling.bottomListItemSpacing = 10
        conditionsMarkdownView.styling.listStyling.bulletViewSize = CGSize(width: 20, height: 20)
        conditionsMarkdownView.styling.listStyling.bulletFont = .medium15
        conditionsMarkdownView.styling.listStyling.bulletImages = [UIImage.circle(diameter: 10, color: (viewModel?.isMultiOffer() ?? false) ? .budapest : .calgary)]
        conditionsMarkdownView.styling.listStyling.bulletColor = .sydney
        conditionsMarkdownView.styling.listStyling.textColor = .sydney
        conditionsMarkdownView.styling.listStyling.baseFont = .medium15
        conditionsMarkdownView.styling.linkStyling.textColor = .sydney
        conditionsMarkdownView.styling.linkStyling.baseFont = .medium15
        conditionsMarkdownView.styling.linkStyling.isBold = false
        conditionsMarkdownView.styling.linkStyling.isItalic = false
        conditionsMarkdownView.styling.linkStyling.isUnderlined = true

        conditionsMarkdownView.onDidConvertMarkDownItemToView = {
            markDownItem, view in
            view.backgroundColor = .clear
        }
    }
    
    private func setupScrollView() {
        self.backgroundColor = .paris
        scrollView.backgroundColor = .paris
        scrollView.delegate = self
    }
    
    func setupCell(viewModel: OfflineOfferDetailViewModel, shopInfo: OfflineShopInfo?, scrollToTop: Bool) {
        guard let shopInfo = shopInfo else {
            return
        }
        self.viewModel = viewModel
        setupScrollView()
        setupMarkdownStyle()
        if conditionsMarkdownView.text?.isEmpty ?? true {
            conditionsMarkdownView.text = shopInfo.ratesDesc ?? ""
        }
        if scrollToTop && scrollView.contentOffset.y > 5 {
            disableDelegateHandler = true
            scrollingToTop()
        }
    }
    
    func stopScroll() {
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
    }
    
    func scrollingToTop() {
        if scrollView.contentOffset.y > 5 {
            disableDelegateHandler = true
            scrollView.setContentOffset( CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

