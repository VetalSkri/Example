//
//  CashBackEPNTests.swift
//  CashBackEPNTests
//
//  Created by Ivan Nikitin on 20.08.18.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import XCTest
@testable import ePN_Cashback

class ServerRequestsTests: XCTestCase {
    
    let email = "ios.testPromocode44@x.ru"
    let promocode = "testapp-20180912-3"
    
    let username = "Test.ios@bk.ru"
    let password = "Qwerty123!"
    
    let tokenVk = ""
    let tokenFacebook = ""
    let tokenGoogle = ""
    let hashes = ""
    let new_password = ""
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        NetworkQueue.shared = NetworkQueue()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func test1SSIDAPP() {
        XCTAssert(false, "fail request get ssid")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//
//        let operation = SSIDOperation()
//
////        operation.start()
//
//        operation.success = { () in
//            let ssid_token = Session.shared.ssid
//            print("ssid_token is \(ssid_token)")
////            Session.shared.ssid = ssid_token
//            XCTAssertNotNil(ssid_token)
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of get ssid is \(error)")
//            XCTAssert(false, "fail request get ssid")
//            expectedResult.fulfill()
//        }
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test2CheckEmail() {
        XCTAssert(false, "fail request check email")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//        let ssid_token = Session.shared.ssid
//
//        XCTAssertNotNil(ssid_token)
//
//        let operation = CheckEmailOperation(email: email)
//
//        operation.success = { (response) in
//            let result = response.result
//            print("check email is \(result)")
//            XCTAssertTrue(result)
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of check email is \(error)")
//            XCTAssert(false, "fail request check email")
//            expectedResult.fulfill()
//        }
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test3CheckPromo() {
        XCTAssert(false, "fail request get ssid")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//
//        let ssid_token = Session.shared.ssid
//
//        XCTAssertNotNil(ssid_token)
//
//        let operation = CheckPromoOperation(promocode: promocode)
//
//        //        operation.start()
//
//        operation.success = { (response) in
//            print("check promo is \(response)")
//            XCTAssertTrue(response)
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of get ssid is \(error)")
////            XCTAssert(false, "fail request get ssid")
//            expectedResult.fulfill()
//        }
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test4Registration() {
        let expectedResult = expectation(description: "Async request")

//        let ssid_token = Session.shared.ssid
//
//        XCTAssertNotNil(ssid_token)
        let password = "Qwerty1!"
        XCTAssert(false, "fail request registration")
        expectedResult.fulfill()
//        let operation = RegistrationOperation(email: email, password: password, promocode: nil, check_ip: nil, news_subscription: nil)
//////        operation.start()
//
//        operation.success = { [weak self] (registrationResponse) in
//            print(registrationResponse)
//            UserDefaults.standard.set(self?.email, forKey: "username")
//            UserDefaults.standard.set(password, forKey: "password")
//            let access_token = registrationResponse.access_token
//            let refresh_token = registrationResponse.refresh_token
//            Session.shared.access_token = access_token
//            Session.shared.refresh_token = refresh_token
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of registration \(error.localizedDescription)")
//            XCTAssert(false, "fail request registration")
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    
    func test5SSIDAUTH() {
        XCTAssert(false, "fail request get ssid")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//
//        let operation = SSIDOperation()
//
//        //        operation.start()
//
//        operation.success = { () in
//            let ssid_token = Session.shared.ssid
//            print("ssid_token is \(ssid_token)")
////            Session.shared.ssid = ssid_token
//            XCTAssertNotNil(ssid_token)
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of get ssid is \(error)")
//            XCTAssert(false, "fail request get ssid")
//            expectedResult.fulfill()
//        }
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    
    func test6Auth() {
        let expectedResult = expectation(description: "Async request")
        UserDefaults.standard.set("Test.ios@bk.ru", forKey: "username")
        UserDefaults.standard.set("Qwerty123!", forKey: "password")
        
        XCTAssert(false, "fail request auth")
        expectedResult.fulfill()
        
//        let username = UserDefaults.standard.string(forKey: "username")
//        XCTAssertNotNil(username)
//        let password = UserDefaults.standard.string(forKey: "password")
//        XCTAssertNotNil(password)
        
//        let username = "Test.ios@bk.ru"
//        let password = "Qwerty123!"
        
//        let operation = AuthOperation(username: username, password: password, check_ip: nil)
////        operation.start()
//
//        operation.success = { (authResponse) in
//            print(authResponse)
//            let access_token = authResponse.access_token
//            let refresh_token = authResponse.refresh_token
//            Session.shared.access_token = access_token
//            Session.shared.refresh_token = refresh_token
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of auth \(error)")
//            XCTAssert(false, "fail request auth")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test7AuthVk() {
        XCTAssert(false, "fail request auth")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//        let operation = SocialAuthOperation(token: tokenVk, socialType: SocialType.vk.rawValue , email: nil, promocode: nil, check_ip: nil)
//
//        //        operation.start()
//
//        operation.success = { (authResponse) in
//            print(authResponse)
//            let access_token = authResponse.access_token
//            let refresh_token = authResponse.refresh_token
//            Session.shared.access_token = access_token
//            Session.shared.refresh_token = refresh_token
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of auth \(error)")
//            XCTAssert(false, "fail request auth")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test8AuthFacebook() {
        XCTAssert(false, "fail request auth")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//        let operation = SocialAuthOperation(token: tokenFacebook, socialType: SocialType.fb.rawValue , email: nil, promocode: nil, check_ip: nil)
//        //        operation.start()
//
//        operation.success = { (authResponse) in
//            print(authResponse)
//            let access_token = authResponse.access_token
//            let refresh_token = authResponse.refresh_token
//            Session.shared.access_token = access_token
//            Session.shared.refresh_token = refresh_token
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of auth \(error)")
//            XCTAssert(false, "fail request auth")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test9AuthGoogle() {
        XCTAssert(false, "fail request auth")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//        let operation = SocialAuthOperation(token: tokenGoogle, socialType: SocialType.google.rawValue , email: nil, promocode: nil, check_ip: nil)
//        //        operation.start()
//
//        operation.success = { (authResponse) in
//            print(authResponse)
//            let access_token = authResponse.access_token
//            let refresh_token = authResponse.refresh_token
//            Session.shared.access_token = access_token
//            Session.shared.refresh_token = refresh_token
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of auth \(error)")
//            XCTAssert(false, "fail request auth")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test9GetOffers() {
        let expectedResult = expectation(description: "Async request")
        XCTAssert(false, "fail request OffersOperation")
        expectedResult.fulfill()
//        let operation = OffersOperation(labelIds: "4", search: nil, limit: 20, offset: nil, categoryIds: nil, order: nil)
//        //        operation.start()
//
//        operation.success = { (recoveryResponse) in
//            print("OffersOperation is \(recoveryResponse)")
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of OffersOperation \(error)")
//            XCTAssert(false, "fail request OffersOperation")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test9GetOffersByOrders() {
        let expectedResult = expectation(description: "Async request")
        
        
        let operation = OffersWithMyOrdersOperation()
        //        operation.start()
        
        operation.success = { (recoveryResponse) in
            print("OffersOperation is \(recoveryResponse)")
            
            expectedResult.fulfill()
        }
        
        operation.failure = { (response, error) in
            print("Error of OffersOperation \(error)")
            XCTAssert(false, "fail request OffersOperation")
            
            expectedResult.fulfill()
        }
        
        
        NetworkQueue.shared.addOperation(operation)
        
        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test91RefreshToken() {
        XCTFail("fail request auth")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//        let access_token = Session.shared.access_token
//        let refresh_token = Session.shared.refresh_token
//        XCTAssertNotNil(refresh_token)
//        print("previous access_token: \(access_token)\n")
//        print("previous refresh_token: \(refresh_token)\n")
//        let operation = RefreshTokenOperation()
////        operation.start()
//
//        operation.success = { (refreshTokenResponse) in
//            let access_token = refreshTokenResponse.access_token
//            print("access_token: \(access_token)\n")
//            let refresh_token = refreshTokenResponse.refresh_token
//            print("refresh_token: \(refresh_token)\n")
//            Session.shared.access_token = access_token
//            Session.shared.refresh_token = refresh_token
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of auth \(error)")
//            XCTFail("fail request auth")
//
//            expectedResult.fulfill()
//        }
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    func test92RestorePassword() {
        XCTAssert(false, "fail request auth")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//
//
//        let operation = RecoveryEmailOperation(email: email)
//        //        operation.start()
//
//        operation.success = { (recoveryResponse) in
//            print("Recovery email send \(recoveryResponse)")
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of auth \(error)")
//            XCTAssert(false, "fail request auth")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func test93RecreatePassword() {
        XCTAssert(false, "fail request recreate password")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//
//
//        let operation = NewPasswordOperation(hash: hashes, password: new_password)
//        //        operation.start()
//
//        operation.success = { (recoveryResponse) in
//            print("recreate password is \(recoveryResponse)")
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of recreate password \(error)")
//            XCTAssert(false, "fail request recreate password")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
