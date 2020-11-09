//
//  SupportApiRouter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

enum SupportApiRouter: BaseApiRouter {
    
    case sendMessage(subject: String?, message: String, replyToId: Int?, subjectId: Int?, files: [File]?, ticketParam: TicketParam?)
    case getDialogs(page: Int?, pageSize: Int?, ticketStatus: String?, search: String?)
    case getDialogMessages(dialogId: String)
    case getUnreadMessagesCount
    case markMessageAsRead(messageId: String)
    case getFaq(search: String)
    case getTopics
    case closeDialog(dialogID: Int)
    case evaluateSupport(dialogID: Int, starCount: Int, comment: String?)
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
        case .markMessageAsRead, .sendMessage, .closeDialog, .evaluateSupport:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .getDialogMessages(let dialogId):
            return "/support/dialogs/\(dialogId)/messages"
        case .getUnreadMessagesCount:
            return "/support/dialogs/messages/unread/count"
        case .markMessageAsRead(let messageId):
            return "/support/dialogs/messages/\(messageId)/read"
        case .getFaq(_):
            return "/support/dialogs/messages/search"
        case .getDialogs:
            return "/support/dialogs"
        case .sendMessage:
            return "/support/dialogs/messages"
        case .getTopics:
            return "/support/topics"
        case .closeDialog(let dialogID):
            return "/support/dialogs/\(dialogID)/status"
        case .evaluateSupport(let dialogID, _, _):
            return "/support/dialogs/\(dialogID)/rating"
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
        case .getFaq(let search):
            return [Constants.APIParameterKey.search: search]
        case .getDialogs(let page, let pageSize, let ticketStatus, let search):
            var parameters = Alamofire.Parameters()
            if let page = page {
                parameters[Constants.APIParameterKey.page] = page
            } else {
                parameters[Constants.APIParameterKey.page] = 1
            }
            if let pageSize = pageSize {
                parameters[Constants.APIParameterKey.pageCount] = pageSize
            } else {
                parameters[Constants.APIParameterKey.pageCount] = 1000
            }
            if let ticketStatus = ticketStatus {
                parameters[Constants.APIParameterKey.ticketStatus] = ticketStatus
            }
            if let search = search {
                parameters[Constants.APIParameterKey.search] = search
            }
            return parameters.keys.count > 0 ? parameters : nil
        case .sendMessage(let subject, let message, let replyToId, let subjectId, let files, let ticketParam):
            var parameters = Alamofire.Parameters()
            parameters[Constants.APIParameterKey.message] = message
            if let topicId = subjectId {
                parameters[Constants.APIParameterKey.topic_id] = topicId
            }
            if let subject = subject {
                parameters[Constants.APIParameterKey.subject] = subject
            }
            if let replyToId = replyToId {
                parameters[Constants.APIParameterKey.replyToId] = replyToId
            }
            if let ticketParam = ticketParam {
                parameters[Constants.APIParameterKey.ticketParams] = ticketParam
            }
            if let files = files {
                var filesDictionaryArray = [[String:Any]]()
                for i in 0 ..< files.count {
                    filesDictionaryArray.append(files[i].toDictionary())
                }
                parameters[Constants.APIParameterKey.files] = filesDictionaryArray
            }
            return parameters
        case .closeDialog:
            var parameters = Alamofire.Parameters()
            
            parameters[Constants.APIParameterKey.status] = DialogStatus.closed.rawValue
            
            return parameters
        case .evaluateSupport(_, let starCount, let comment):
            var parameters = Alamofire.Parameters()
            
            parameters[Constants.APIParameterKey.rating] = starCount
            parameters[Constants.APIParameterKey.description] = comment
            
            return parameters
        default:
            return nil
        }
    }
    
    internal var timeout: TimeInterval {
        switch self {
        default:
            return 10
        }
    }
    
    internal var queryType: Query {
        switch self {
        case .sendMessage, .closeDialog, .evaluateSupport:
            return .json
        default:
            return .path
        }
    }
    
    var headers: HTTPHeaders {
        var head = defaultHeader()
        switch self {
        case .sendMessage:
            head["X-API-VERSION"] = "2.1"
            break
        default:
            break
        }
        return head
    }
    
    var baseUrl: URL? {
        return nil
    }
}
