//
//  ShopDetailConditionViewController.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 23/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import markymark

class ShopDetailConditionViewController: UIViewController, SwipeUiViewController {
    
    private var viewModel: ShopDetailViewModel!
    private let cellId = "shopDetailConditionCellId"
    @IBOutlet weak var tableView: EPNSelfSizedTableView!
    @IBOutlet weak var upDownImageView: UIImageView!
    @IBOutlet weak var offerDescriptionMarkdownTextView: MarkDownTextView!
    @IBOutlet weak var markdownTextView: MarkDownTextView!
    @IBOutlet weak var showAllLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .zurich
        tableView.backgroundColor = .zurich
        showAllLabel.text = NSLocalizedString("Show all", comment: "")
        showAllLabel.font = .medium15
        showAllLabel.textColor = .minsk
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
    }
    
    func bindViewModel(viewModel: ShopDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func updateContent() {
        tableView.reloadData()
        setupDescriptionText()
    }
    
    func setupDescriptionText() {
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
        markdownTextView.styling.listStyling.lineHeight = 4
        markdownTextView.styling.listStyling.bottomListItemSpacing = 10
        markdownTextView.styling.listStyling.bulletViewSize = CGSize(width: 20, height: 20)
        markdownTextView.styling.listStyling.bulletFont = .medium15
        markdownTextView.styling.listStyling.bulletImages = [UIImage.circle(diameter: 10, color: .vancouver)]
        markdownTextView.styling.listStyling.bulletColor = .sydney
        markdownTextView.styling.listStyling.textColor = .sydney
        markdownTextView.styling.listStyling.baseFont = .medium15
        markdownTextView.styling.linkStyling.textColor = .sydney
        markdownTextView.styling.linkStyling.baseFont = .medium15
        markdownTextView.styling.linkStyling.isBold = false
        markdownTextView.styling.linkStyling.isItalic = false
        markdownTextView.styling.linkStyling.isUnderlined = true

        markdownTextView.onDidConvertMarkDownItemToView = {
            markDownItem, view in
            view.backgroundColor = .clear
        }

        offerDescriptionMarkdownTextView.styling.headingStyling.textColorsForLevels = [
            .sydney, //H1 (i.e. # Title)
            .sydney, //H2, ... (i.e. ## Subtitle, ### Sub subtitle)
            .sydney  //H3
        ]
        offerDescriptionMarkdownTextView.styling.headingStyling.isBold = true
        offerDescriptionMarkdownTextView.styling.headingStyling.fontsForLevels = [
            .semibold17, //H1
            .bold17, //H2
            .medium15  //H3
        ]
        offerDescriptionMarkdownTextView.styling.paragraphStyling.textColor = .sydney
        offerDescriptionMarkdownTextView.styling.paragraphStyling.baseFont = .medium15
        offerDescriptionMarkdownTextView.styling.listStyling.lineHeight = 4
        offerDescriptionMarkdownTextView.styling.listStyling.bottomListItemSpacing = 10
        offerDescriptionMarkdownTextView.styling.listStyling.bulletViewSize = CGSize(width: 20, height: 20)
        offerDescriptionMarkdownTextView.styling.listStyling.bulletFont = .medium15
        offerDescriptionMarkdownTextView.styling.listStyling.bulletImages = [UIImage.circle(diameter: 10, color: .vancouver)]
        offerDescriptionMarkdownTextView.styling.listStyling.bulletColor = .sydney
        offerDescriptionMarkdownTextView.styling.listStyling.textColor = .sydney
        offerDescriptionMarkdownTextView.styling.listStyling.baseFont = .medium15
        offerDescriptionMarkdownTextView.styling.linkStyling.textColor = .sydney
        offerDescriptionMarkdownTextView.styling.linkStyling.baseFont = .medium15
        offerDescriptionMarkdownTextView.styling.linkStyling.isBold = false
        offerDescriptionMarkdownTextView.styling.linkStyling.isItalic = false
        offerDescriptionMarkdownTextView.styling.linkStyling.isUnderlined = true

        offerDescriptionMarkdownTextView.onDidConvertMarkDownItemToView = {
            markDownItem, view in
                view.backgroundColor = .clear
        }

        markdownTextView.text = viewModel.conditionDescription()
        offerDescriptionMarkdownTextView.text = viewModel.shopDescription()
    }
    
    @IBAction func showHideButtonTapped(_ sender: Any) {
        viewModel.switchConditionHiddenFlag()
        if viewModel.isFaqConditionHidden() {
            upDownImageView.rotate(radians: 0, animation: true, duration: 0.4)
            showAllLabel.text = NSLocalizedString("Show all", comment: "")
        } else {
            upDownImageView.rotate(radians: 180, animation: true, duration: 0.4)
            showAllLabel.text = NSLocalizedString("Hide", comment: "")
        }
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.tableView.beginUpdates()
            if(self?.viewModel.isFaqConditionHidden() ?? false) {
                self?.tableView.deleteRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .fade)
            } else {
                self?.tableView.insertRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .fade)
            }
            self?.tableView.endUpdates()
            self?.view.layoutIfNeeded()
        }
    }
    
}

extension ShopDetailConditionViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFaqConditions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ShopDetailConditionTableViewCell
        cell.setupCell(faqCondition: viewModel.faqCondition(forIndexPath: indexPath))
        return cell
    }
    
}
