//
//  SupportApiTests.swift
//  CashBackEPNTests
//
//  Created by Александр Кузьмин on 03/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCTest
@testable import ePN_Cashback


/// BEFORE RUN THIS TEST YOU MUST CHANGE CONFIG TO n20 SERVER
class SupportApiTests: XCTestCase {

    private var createdSupportTicketId : Int = 1
    
    override func setUp() {
//        continueAfterFailure = true
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        let networkManager = AuthOperation(username: "testmail@mail.com", password: "12345678", check_ip: nil,service: NetworkBackendService(BackendConfiguration(baseURL: URL(string: "https://oauth2-n20.epndev.bz")!)))
//        networkManager.success = { (authResponse) in
//            let base64Encoded = authResponse.access_token.replacingOccurrences(of: ".", with: ",").split(separator: ",").map(String.init)[1]
//            guard let decodedData = base64Encoded.base64Decoded() else {
//                XCTAssert(false, "fail parse auth response")
//                return
//            }
//            let cashbackUserRole = decodedData.components(separatedBy: "user_role\":\"")[1].split(separator: "\"")[0].elementsEqual("cashback")
//            if !cashbackUserRole {
//                XCTAssert(false, "fail request: user not cashback role")
//            } else {
//                let access_token = authResponse.access_token
//                let refresh_token = authResponse.refresh_token
//                Session.shared.access_token = access_token
//                Session.shared.refresh_token = refresh_token
//            }
//        }
//
//        networkManager.failure = { (errorResponse, error) in
//            if errorResponse != nil {
//                print("MYLOG: Error of get access token \(String(describing: errorResponse))")
//                XCTAssert(false, "fail request")
//            } else {
//                print("MYLOG: Error of get access token \(error)")
//                XCTAssert(false, "fail request")
//            }
//        }
//        queue.addOperation(networkManager)
//        queue.waitUntilAllOperationsAreFinished()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetSupportDialogs() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsByPaging() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(page: 2, pageSize: 40) { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsBySearch() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(search: "how to") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsByStatusOpen() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(ticketStatus: "open") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsByStatusClose() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(ticketStatus: "closed") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsByStatusNotify() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(ticketStatus: "notify") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsByStatusAll() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(ticketStatus: "all") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportDialogsByStatusAndSearch() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogs(ticketStatus: "open", search: "how to") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }

    func testSendNewMessage() {
        let expectedResult = expectation(description: "Async request")
        let ticketParam = TicketParam(offerId: nil, offerTitle: nil, refLink: nil, refLogin: nil, orderDate: nil, orderNumber: nil, orderLink: nil, appPlatform: "ios", appVersion: "2.0.1")
        let operation = SupportSendMessageOperation(subject: "Тестовый заголовок", message: "Тестовое сообщение", replyToId: 0, files: nil, ticketParam: ticketParam)
        
        operation.success = { [weak self] (response) in
            print("MYLOG: Response is \(String(describing: response))")
            self?.createdSupportTicketId = response?.data.attributes.ticketId ?? 1
            expectedResult.fulfill()
        }
        operation.failure = { (response, error) in
            print("MYLOG: Error of recreate password \(error)")
            XCTAssert(false, "fail request")
            expectedResult.fulfill()
        }
        NetworkQueue.shared.addOperation(operation)
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testUploadingFile() {
        let expectedResult = expectation(description: "Async request")
        let operation = CdnImageUploadOperation(fileUrl: "")
        
        operation.success = { (response) in
            print("MYLOG: Response is \(String(describing: response))")
            expectedResult.fulfill()
        }
        operation.failure = { (response, error) in
            print("MYLOG: Error of recreate password \(error)")
            XCTAssert(false, "fail request")
            expectedResult.fulfill()
        }
        NetworkQueue.shared.addOperation(operation)
        waitForExpectations(timeout: 40, handler:nil)
    }
    
    func testGetDialogMessages() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getDialogMessages(dialogId: "1762089") { (result) in
            switch result {
            case .success(let messages):
                print("MYLOG: Response is \(String(describing: messages))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 100, handler:nil)
    }
    
    func testGetUnreadDialogMessagesCount() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getUnreadMessagesCount { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 100, handler:nil)
    }
    
    func testMarkMessageAsRead() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.markMessageAsRead(messageId: "5214408") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                if !serealizedObject.result {
                    print("MYLOG: Error response, result is false")
                    XCTAssert(false, "fail request")
                    expectedResult.fulfill()
                    return
                }
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
 
    func testGetSupportFaqForSearch() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getFaqQuestionAnswers(search: "выплат") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetSupportFaqForUnrealSearch() {
        let expectedResult = expectation(description: "Async request")
        
        SupportApiClient.getFaqQuestionAnswers(search: "dsfdssdfsdkfl sdflsdf") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error of recreate password \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
}
