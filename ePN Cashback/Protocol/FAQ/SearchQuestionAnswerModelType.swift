//
//  SearchQuestionAnswerModelType.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 01/08/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol SearchQuestionAnswerModelType {

    var bottomInfoText: String { get }
    var buttonToSupportText: String { get }
    
    func goOnBack()
    func goOnSupport()
    
    func searchWithText(searchText: String)
    func countOfSections() -> Int
    func countOfRowsInSection(section: Int) -> Int
    func titleOfSection(section: Int) -> String
    func cellViewModel(forIndexPath indexPath: IndexPath) -> FAQViewCellViewModelType?
    func cellDidSelected(cellIndexPath: IndexPath)
    
}

extension SearchQuestionAnswerModelType {
    
    var bottomInfoText: String {
        return NSLocalizedString("FAQ_bottomInfo", comment: "")
    }
    
    var buttonToSupportText: String {
        return NSLocalizedString("FAQ_buttonToSupport", comment: "")
    }
    
}
