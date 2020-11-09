//
//  FaqViewModel.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 26/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import XCoordinator

enum FaqViewType {
    case normal
    case fromOfflineCB
    case webmasterInfo
}

class FaqViewModel: FAQModelType {

    private var type : FaqViewType!
    private var faq: [FaqCategoryes]!
    private let router: UnownedRouter<FAQRoute>
    
    init(router: UnownedRouter<FAQRoute>, type: FaqViewType /*= .normal*/) {
        self.router = router
        self.faq = []
        self.type = type
    }
    
    func goOnBack() {
        router.trigger(.back)
    }
    
    func goOnSupport() {
        router.trigger(.support)
    }
    
    func goOnAuth() {
        router.trigger(.dismiss)
    }
    
    func goOnPopUpGuid() {
        router.trigger(.popupGuid)
    }
    
    func goOnFAQRulesToBuy() {
        router.trigger(.rulesToBuy)
    }
    
    func goOnFAQWhatIsCB() {
        router.trigger(.whatIsCB)
    }
    
    func goOnFAQHowOrderPayments() {
        router.trigger(.howOrderPayments)
    }
    
    func goOnFAQWhatToDoAfter() {
        router.trigger(.whatToDoAfter)
    }
    
    func goOnHowToBuy() {
        router.trigger(.howToBuy)
    }
    
    func goOnIntroduction() {
        router.trigger(.introduction)
    }
    
    func searchViewModel() -> SearchQuestionAnswerViewModel {
        return SearchQuestionAnswerViewModel(router: router)
    }
    
    let categoryesForOfflineCb = [
        FaqCategoryes(id: 0, title: NSLocalizedString("FAQ_QuestionsAndAnswers", comment: ""), priority: 1, faq: [
            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_CameraDoesntDetect", comment: ""), answer: NSLocalizedString("FAQ_IfTheCameraDoesntDetect", comment: ""), lang: ""),
            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_HowDoIKnow", comment: ""), answer: NSLocalizedString("FAQ_ClickTheButtonConditions", comment: ""), lang: ""),
            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_WhyHasTheOrderCanceled", comment: ""), answer: NSLocalizedString("FAQ_ReceiptWithTheGoods", comment: ""), lang: ""),
            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_WhyTheOrderProcessingSoLong", comment: ""), answer: NSLocalizedString("FAQ_ItTakesFromSeveralDays", comment: ""), lang: "")
            ])
    ]
    
    let categoryesForWebmasters = [
        FaqCategoryes(id: 0, title: "", priority: 1, faq: [
            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_whyBeforeWork", comment: ""), answer: NSLocalizedString("FAQ_allStoreAddedAutomatically", comment: ""), lang: ""),
            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_whatToDoIfWebmaster", comment: ""), answer: NSLocalizedString("FAQ_registerNewAccount", comment: ""), lang: "")
//            QuestionAnswer(id: 0, question: NSLocalizedString("FAQ_whatToDoIfIWorkAsWebmaster", comment: ""), answer: NSLocalizedString("FAQ_ourTeam", comment: ""), lang: "")
            ])
    ]
    
//    func setType(type: FaqViewType) {
//        self.type = type
//    }
    
    var titleFAQ: String {
        return NSLocalizedString("HelpFAQ", comment: "")
    }
    
    func getType() -> FaqViewType {
        return type
    }
    
    func numberOfRowsInSection(fromSection section: Int) -> Int {
        return faq[section].list.count
    }
    
    func titleOfSection(inSection section: Int) -> String {
        return faq[section].title
    }
    
    func countOfSections() -> Int {
        return faq.count
    }
    
    func getSectionHeaderHeight() -> Int {
        return (self.type == .webmasterInfo) ? 0 : 50
    }
    
    func indexSetOfSections() -> NSIndexSet {
        return NSIndexSet(indexesIn: NSRange(location: 0, length: faq.count-1))
    }
    
    func cellDidSelected(cellIndexPath: IndexPath){
        faq[cellIndexPath.section].list[cellIndexPath.row].openned = !faq[cellIndexPath.section].list[cellIndexPath.row].openned
    }

    func cellViewModel(forIndexPath indexPath: IndexPath) -> FAQViewCellViewModelType? {
        let questionAnswerInSection = faq[indexPath.section].list
        let currentQuestionAnswer = questionAnswerInSection[indexPath.row]
        return FAQCellViewModel(questionAnswer: currentQuestionAnswer)
    }
    
    func loadData(forceRefresh: Bool, completion: (()->())?, failure: (()->())?) {
        if type == FaqViewType.fromOfflineCB {
            self.faq = categoryesForOfflineCb
            completion?()
            return
        }
        if type == FaqViewType.webmasterInfo {
            self.faq = categoryesForWebmasters
            completion?()
            return
        }
        let now = Date()
        guard let date = Session.shared.timeOfTableFaq else {
            print("load data from server because there is not Cache")
            loadListOfFAQ(completion: {
                Session.shared.timeOfTableFaq = now
                completion?()
            }) {
                failure?()
            }
            return
        }
        if now.timeIntervalSince(date) > Util.TIME_OF_UPDATING_FAQ || forceRefresh {
            print("load data from Cache after expired time of Cache or force refresh (from refresh control)")
            loadListOfFAQ(completion: {
                Session.shared.timeOfTableFaq = now
                completion?()
            }) {
                failure?()
            }
        } else {
            self.faq = CoreDataStorageContext.shared.fetchFaqCategoryes(lang: Util.languageOfContent())?.sorted(by: { $0.priority < $1.priority }) ?? [FaqCategoryes]()
            if(self.faq.count == 0) {   //if language was changed
                loadListOfFAQ(completion: {
                    Session.shared.timeOfTableFaq = now
                    completion?()
                }) {
                    failure?()
                }
                return
            }
            completion?()
            print("load data from Cache not expired time of Cache")
        }
    }
    
    private func loadListOfFAQ(completion: (()->())?, failure: (()->())?) {
        FaqApiClient.answers { [weak self] (result) in
            switch result {
            case .success(let response):
                let faqServer = response.data.attributes.map({ (faqAnswersCategory) -> FaqCategoryes in
                               let questionAnswer = faqAnswersCategory.data.map{ QuestionAnswer(id: $0.question_answer_id, question: $0.question, answer: $0.answer, lang: $0.lang)}
                               return FaqCategoryes(id: Int64(faqAnswersCategory.category_id), title: faqAnswersCategory.category_title, priority: faqAnswersCategory.category_priority, faq: questionAnswer)
                           })
                           OperationQueue.main.addOperation( { [weak self] in
                               CoreDataStorageContext.shared.addAllFaqCategoryes(objects: faqServer)
                               self?.faq.removeAll()
                               self?.faq.append(contentsOf: faqServer)
                               completion?()
                           })
                break
            case .failure(let error):
                failure?()
                Alert.showErrorAlert(by: error)
                break
            }
        }
    }
    
}
