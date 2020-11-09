//
//  SearchQuestionAnswerViewModel.swift
//  CashBackEPN
//
//  Created by Александр on 20/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class SearchQuestionAnswerViewModel: SearchQuestionAnswerModelType {

    private var categoryes: [FaqCategoryes]
    
    private let router: UnownedRouter<FAQRoute>
    
    init(router: UnownedRouter<FAQRoute>) {
        self.router = router
        self.categoryes = CoreDataStorageContext.shared.fetchFaqCategoryes(lang: Util.languageOfContent())?.sorted(by: { $0.priority < $1.priority }) ?? []
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnSupport() {
        router.trigger(.support)
    }
    
    func searchWithText(searchText: String){
        self.categoryes = searchText.isEmpty ? CoreDataStorageContext.shared.fetchFaqCategoryes(lang: Util.languageOfContent())?.sorted(by: { $0.priority < $1.priority }) ?? [] : CoreDataStorageContext.shared.fetchFaqCategoryes(lang: Util.languageOfContent(), searchText: searchText)?.sorted(by: { $0.priority < $1.priority }) ?? []
    }
    
    
    func countOfSections() -> Int{
        return categoryes.count
    }
    
    func countOfRowsInSection(section: Int) -> Int{
        return categoryes[section].list.count
    }
    
    func titleOfSection(section: Int) -> String{
        return categoryes[section].title
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> FAQViewCellViewModelType? {
        let questionAnswerInSection = categoryes[indexPath.section].list
        let currentQuestionAnswer = questionAnswerInSection[indexPath.row]
        return FAQCellViewModel(questionAnswer: currentQuestionAnswer)
    }
    
    func cellDidSelected(cellIndexPath: IndexPath){
        categoryes[cellIndexPath.section].list[cellIndexPath.row].openned = !categoryes[cellIndexPath.section].list[cellIndexPath.row].openned
    }
    
}
