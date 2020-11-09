//
//  SupportViewModel.swift
//  Backit
//
//  Created by Александр Кузьмин on 08/11/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import XCoordinator

class SupportViewModel
{
    private let router: UnownedRouter<SupportRoute>
    var isLoading: Bool = true
    private var openTickets: [SupportDialogsAttributes]?
    private var closeTickets: [SupportDialogsAttributes]?
    private var shouldShowEvaluateSupport = false
    private var dialogIDForEvaluation: Int?
    
    init(router: UnownedRouter<SupportRoute>) {
        self.router = router
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    var title: String {
        return NSLocalizedString("Support", comment: "")
    }
    
    func setForEvaluation(dialogID: Int) {
        dialogIDForEvaluation = dialogID
        shouldShowEvaluateSupport = true
    }
    
    func viewDidAppear() {
        if shouldShowEvaluateSupport {
            guard let dialogID = dialogIDForEvaluation else {
                fatalError()
            }
            
            router.trigger(.showEvaluateSupport(dialogID: dialogID))
            shouldShowEvaluateSupport = false
            dialogIDForEvaluation = nil
        }
    }
    
    func back() {
        router.trigger(.back)
    }
    
    func createTicket() {
        router.trigger(.ticketType)
    }
    
    func loadTickets(completed: ((Bool)->())?) {
        isLoading = true
        SupportApiClient.getDialogs { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.openTickets = response.data.attributes?.filter({ return $0.status == .open })
                self?.closeTickets = response.data.attributes?.filter({ return $0.status == .closed })
                self?.isLoading = false
                NotificationCenter.default.post(name: Notification.Name("updateTickets"), object: nil)
                completed?(true)
                break
            case .failure(_):
                NotificationCenter.default.post(name: Notification.Name("updateTickets"), object: nil)
                completed?(false)
                break
            }
        }
    }
    
    func getIsLoading() -> Bool {
        return isLoading && openTickets == nil && closeTickets == nil
    }
    
    func getTicketCount(for status: DialogStatus) -> Int {
        switch status {
        case .open:
            return openTickets?.count ?? 0
        case .closed:
            return closeTickets?.count ?? 0
        default:
            return 0
        }
    }
    
    func getTicket(for status: DialogStatus, indexPath: IndexPath) -> SupportDialogsAttributes? {
        switch status {
        case .open:
            if (openTickets?.count ?? 0) > indexPath.row {
                return openTickets?[indexPath.row]
            }
        case .closed:
            if (closeTickets?.count ?? 0) > indexPath.row {
                return closeTickets?[indexPath.row]
            }
        default:
            break
        }
        return nil
    }
    
    func selectChat(indexPath: IndexPath, isOpen: Bool) {
        if !((isOpen && openTickets?.count ?? 0 > indexPath.row) || (!isOpen && closeTickets?.count ?? 0 > indexPath.row)) { return }
        let dialogId = isOpen ? openTickets?[indexPath.row].id ?? 0 : closeTickets?[indexPath.row].id ?? 0
        router.trigger(.chat(replyToId: dialogId, subjectId: nil, subjectName: nil, isOpen: isOpen))
    }
    
}

extension SupportViewModel {
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(markTicketAsRead(notification:)), name: NSNotification.Name("markTicketAsRead"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needUpdateTickets), name: NSNotification.Name("needUpdateTickets"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLastMessage(notification:)), name: NSNotification.Name("successSendMessage"), object: nil)
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func needUpdateTickets() {
        loadTickets { (success) in
            if success {
                NotificationCenter.default.post(name: Notification.Name("updateTickets"), object: nil)
            }
        }
    }
    
    @objc private func markTicketAsRead(notification: NSNotification) {
        if let userInfo = notification.userInfo as NSDictionary? {
            if let ticketId = userInfo["ticketId"] as? Int {
                var isUpdated = false
                if let ticketIndex = self.openTickets?.lastIndex(where: { return $0.id == ticketId }) {
                    var ticket = openTickets![ticketIndex]
                    ticket.isRead = true
                    self.openTickets?[ticketIndex] = ticket
                    isUpdated = true
                }
                if let ticketIndex = self.closeTickets?.lastIndex(where: { return $0.id == ticketId }) {
                    var ticket = closeTickets![ticketIndex]
                    ticket.isRead = true
                    self.closeTickets?[ticketIndex] = ticket
                    isUpdated = true
                }
                if isUpdated {
                    NotificationCenter.default.post(name: Notification.Name("updateTickets"), object: nil)
                }
            }
        }
    }
    
    @objc private func changeLastMessage(notification: NSNotification) {
        if let userInfo = notification.userInfo as NSDictionary? {
            if let ticketId = userInfo["dialogId"] as? Int, let message = userInfo["lastMessage"] as? String {
                if let index = self.openTickets?.firstIndex(where: { return $0.id == ticketId }){
                    self.openTickets?[index].message = message
                    self.openTickets?[index].lastFromSupport = false
                }
                if let index = self.closeTickets?.firstIndex(where: { return $0.id == ticketId }){
                    self.closeTickets?[index].message = message
                    self.closeTickets?[index].lastFromSupport = false
                }
            }
        }
    }
}
