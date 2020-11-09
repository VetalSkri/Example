//
//  SelectTicketTypeVC.swift
//  Backit
//
//  Created by Александр Кузьмин on 11/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class SelectTicketTypeViewModel {
    
    private let router: UnownedRouter<SupportRoute>
    var selectedRow: Int?
    private var isLoad = false
    private var topics:[SupportTopicAttributes]? = nil
    
    init(router: UnownedRouter<SupportRoute>) {
        self.router = router
    }
    
    var title: String {
        return NSLocalizedString("Subject of issue", comment: "")
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func typesCount() -> Int {
        return (isLoad && topics == nil) ? 10 : topics?.count ?? 0
    }
    
    func topic(for indexPath: IndexPath) -> SupportTopicAttributes? {
        if let topics = topics, topics.count > indexPath.row {
            return topics[indexPath.row]
        }
        return nil
    }
    
    func startDialogue(complete:((Bool)->())?) {
        if let selectedRow = selectedRow {
            SupportApiClient.sendMessage(subject: topics![selectedRow].name, message: topics![selectedRow].name, replyToId: nil, subjectId: topics![selectedRow].id, files: nil, ticketParam: nil) { [weak self] (result) in
                switch result {
                case .success(let response):
                    complete?(true)
                    NotificationCenter.default.post(name: NSNotification.Name("needUpdateTickets"), object: nil)
                    guard let self = self else { return }
                    self.router.trigger(.chat(replyToId: response.data.attributes.ticketId, subjectId: nil, subjectName: nil, isOpen: true))
                    break
                case .failure(_):
                    complete?(false)
                    break
                }
            }
        }
    }
    
    func loadTopics(complete: ((Bool)->())?) {
        if isLoad {
            return
        }
        isLoad = true
        SupportApiClient.getTopics { [weak self] (result) in
            self?.isLoad = false
            switch result {
            case .success(let response):
                self?.topics = response.data.attributes
                complete?(true)
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                complete?(false)
                break
            }
        }
    }
    
    func showSkeleton() -> Bool {
        return (isLoad && topics == nil)
    }
}

struct TicketType {
    var id: Int
    var name: String
    var answer: String
}
