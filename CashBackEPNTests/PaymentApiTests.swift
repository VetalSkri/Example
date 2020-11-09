//
//  PaymentApiTests.swift
//  CashBackEPNTests
//
//  Created by Александр Кузьмин on 09/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCTest
//@testable import Backit

/// BEFORE RUN THIS TEST YOU MUST CHANGE CONFIG TO n20 SERVER
class PaymentApiTests: XCTestCase {

    override func setUp() {
        XCTAssert(false, "fail request")
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
    
    func testGetPaymentInfo() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.getPaymentInfo { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }

    func testPaymentOrder() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.paymentOrder(currency: "RUB", purseId: 1, amount: 10) { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                expectedResult.fulfill()
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testCreateCharityPurse() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.createCharityPurse(charityId: 2) { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testCreatePurse() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.createPurse(purseType: "tele2", purseValue: "+72893472347") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testConfirmPurse() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.confirmPurse(purseId: 1, code: 123) { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testGetUserPurses() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.getUserPurses { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testRemovePurse() {
        let expectedResult = expectation(description: "Async request")
        
        PaymentApiClient.removeUserPurse(purseId: "1263942") { (result) in
            switch result {
            case .success(let serealizedObject):
                print("MYLOG: Response is \(String(describing: serealizedObject))")
                expectedResult.fulfill()
                break
            case .failure(let error):
                print("MYLOG: Error \(error)")
                XCTAssert(false, "fail request")
                break
            }
        }
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
}
