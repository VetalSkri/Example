//
//  ShopDetailRateTableViewCell.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 23/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import markymark

class ShopDetailRateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var oldRateLabel: UILabel!
    @IBOutlet weak var markdownTextView: MarkDownTextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(rate: ShopInfoRates) {
        self.view.backgroundColor = .zurich
        self.rateLabel.text = rate.newRate
        self.rateLabel.font = .bold20
        if (rate.oldRate?.isEmpty ?? true) {
            self.rateLabel.textColor = .sydney
        } else {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: rate.oldRate!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            self.rateLabel.textColor = .prague
            self.oldRateLabel.font = .semibold15
            self.oldRateLabel.textColor = .minsk
            self.oldRateLabel.attributedText = attributeString
        }
        markdownTextView.styling.headingStyling.textColorsForLevels = [
            .sydney, //H1 (i.e. # Title)
            .sydney, //H2, ... (i.e. ## Subtitle, ### Sub subtitle)
            .sydney  //H3
        ]
        markdownTextView.styling.headingStyling.isBold = true
        markdownTextView.styling.headingStyling.fontsForLevels = [
            .semibold17, //H1
            .bold17, //H2
            .medium15  //H3
        ]
        markdownTextView.styling.paragraphStyling.textColor = .sydney
        markdownTextView.styling.paragraphStyling.baseFont = .medium15
        markdownTextView.styling.listStyling.bulletFont = .medium15
        markdownTextView.styling.listStyling.bulletImages = [UIImage.circle(diameter: 10, color: .clear)]
        markdownTextView.styling.listStyling.bulletColor = .sydney
        markdownTextView.styling.listStyling.textColor = .sydney
        markdownTextView.styling.listStyling.baseFont = .medium15
        markdownTextView.styling.linkStyling.textColor = .sydney
        markdownTextView.styling.linkStyling.baseFont = .medium15
        markdownTextView.styling.linkStyling.isBold = false
        markdownTextView.styling.linkStyling.isItalic = false
        markdownTextView.styling.linkStyling.isUnderlined = false
        let description = rate.description.withoutHtml
        markdownTextView.text = description
    }

}
