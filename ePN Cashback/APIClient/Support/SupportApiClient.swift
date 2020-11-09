//
//  SupportApiClient.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

class SupportApiClient: BaseApiClient {
    
    static func getDialogs(page: Int? = nil, pageSize: Int? = nil, ticketStatus: String? = nil, search: String? = nil, completion:@escaping (Result<SupportDialogs, Error>)->Void) {
        performRequest(router: SupportApiRouter.getDialogs(page: page, pageSize: pageSize, ticketStatus: ticketStatus, search: search), completion: completion)
    }
    
    static func sendMessage(subject: String?, message: String, replyToId: Int?, subjectId: Int?, files: [File]?, ticketParam: TicketParam?, completion:@escaping (Result<SupportSendMessageResponse, Error>)->Void) {
        performRequest(router: SupportApiRouter.sendMessage(subject: subject, message: message, replyToId: replyToId, subjectId: subjectId, files: files, ticketParam: ticketParam), completion: completion)
    }
    
    static func getDialogMessages(dialogId: String, completion:@escaping (Result<SupportDialogMessages, Error>)->Void) {
        performRequest(router: SupportApiRouter.getDialogMessages(dialogId: dialogId), completion: completion)
    }
    
    static func getUnreadMessagesCount(completion:@escaping (Result<SupportUnreadMessagesCount, Error>)->Void) {
        performRequest(router: SupportApiRouter.getUnreadMessagesCount, completion: completion)
    }
    
    static func markMessageAsRead(messageId: String, completion:@escaping (Result<SupportMarkMessageAsReadResponse, Error>)->Void) {
        performRequest(router: SupportApiRouter.markMessageAsRead(messageId: messageId), completion: completion)
    }
    
    static func getFaqQuestionAnswers(search: String, completion:@escaping (Result<SupportFaq, Error>)->Void) {
        performRequest(router: SupportApiRouter.getFaq(search: search), completion: completion)
    }
    
    static func getTopics(completion:@escaping (Result<SupportTopic, Error>)->Void) {
        performRequest(router: SupportApiRouter.getTopics, completion: completion)
    }
    
    static func closeDialog(id: Int, completion: @escaping ((Result<SupportDialogStatus, Error>) -> Void)) {
        performRequest(router: SupportApiRouter.closeDialog(dialogID: id), completion: completion)
    }
    
    static func evaluateSupport(dialogID: Int, starCount: Int, comment: String?, completion: @escaping ((Result<SupportDialogStatus, Error>) -> Void)) {
        performRequest(router: SupportApiRouter.evaluateSupport(dialogID: dialogID,
                                                                starCount: starCount,
                                                                comment: comment),
                       completion: completion)
    }
}
