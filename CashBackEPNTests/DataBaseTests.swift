//
//  DataBaseTests.swift
//  CashBackEPNTests
//
//  Created by Ivan Nikitin on 12/12/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import XCTest
@testable import ePN_Cashback

class DataBaseTests: XCTestCase {

    let username = "Test.ios@bk.ru"
    let password = "Qwerty123!"
    private var storage: StorableContext = CoreDataStorageContext()
    
    override func setUp() {
        continueAfterFailure = false
        NetworkQueue.shared = NetworkQueue()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testA_A_SSID() {
        XCTAssert(false, "fail request get ssid")
        expectedResult.fulfill()
//        let expectedResult = expectation(description: "Async request")
//
//        let operation = SSIDOperation()
//        operation.success = { () in
//            let ssid_token = Session.shared.ssid
//            print("ssid_token is \(String(describing: ssid_token))")
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
    
    
    func testA_B_Auth() {
        let expectedResult = expectation(description: "Async request")
        XCTAssert(false, "fail request auth")
        expectedResult.fulfill()
//        UserDefaults.standard.set("Test.ios@bk.ru", forKey: "username")
//        UserDefaults.standard.set("Qwerty123!", forKey: "password")
        
//        let operation = AuthOperation(username: username, password: password, check_ip: nil)
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
    
    func testA_C_Labels() {
        let expectedResult = expectation(description: "Async request")
        XCTAssert(false, "fail request labels")
        expectedResult.fulfill()
        //        UserDefaults.standard.set("Test.ios@bk.ru", forKey: "username")
        //        UserDefaults.standard.set("Qwerty123!", forKey: "password")
//        let operation = LabelsOperation()
//
//        operation.success = {[unowned self] (labelsFromServer) in
//            let currentLabels = labelsFromServer.map { Labels(id: $0.id, $0.attributes) }
//
//            self.storage.addAllLabels(objects: currentLabels)
//
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of labels \(error)")
//            XCTAssert(false, "fail request labels")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testA_D_Offers() {
        let expectedResult = expectation(description: "Async request")
        XCTAssert(false, "fail request offers")
        expectedResult.fulfill()
//        let operation = OffersOperation(labelIds: nil, search: nil, limit: 1000, offset: nil, categoryIds: nil, order: nil)
//
//        operation.success = { (offers) in
//            if let offers = offers {
//
//                let currentStores = offers.map { Store(id: $0.id, offer: $0.attributes) }
//                currentStores.forEach {
//                    print("id of store \($0.id) - name: \($0.store.name) - title: \($0.store.title) - tag: \($0.store.tag)")
//                }
//                print("*************************************************************************************")
//
//                //TODO: - Remember use in main queue
//                OperationQueue.main.addOperation {
//                    self.storage.addAllShops(objects: currentStores)
//                }
//            }
//            expectedResult.fulfill()
//        }
//
//        operation.failure = { (response, error) in
//            print("Error of get offers \(error)")
//            XCTAssert(false, "fail request offers")
//
//            expectedResult.fulfill()
//        }
//
//
//        NetworkQueue.shared.addOperation(operation)
//
//        waitForExpectations(timeout: 20, handler:nil)
    }
    
    func testB_A_FetchLabels() {
        guard let labels = storage.fetchLabels() else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(labels)
        XCTAssertNotEqual(labels.count, 0)
        labels.forEach{
            print("id of labels \($0.id) - name: \($0.name) - priority: \($0.priority)")
        }
        
    }

    func testB_B_FetchOffers() {
        guard let offers = storage.fetchOffers() else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(offers)
        offers.forEach {
            print("id of store \($0.id) - name: \($0.store.name) - title: \($0.store.title) - tag: \($0.store.tag)")
            print("labels is \(String(describing: $0.store.labelIds))")
        }
    }
    
    func testB_B_FetchOffersByLabel() {
//        guard var labels = storage.fetchLabels() else {
//            XCTAssertNotNil(nil)
//            return
//        }
//        labels.sort{ $0.id < $1.id }
//        let label = labels.last!
//        print("id of label \(label.id) - name: \(label.name) - priority: \(label.priority)")
        guard let offersByLabel = storage.fetchAllShopsByLabel(3) else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(offersByLabel)
        offersByLabel.forEach {
            print("id of store \($0.id) - name: \($0.store.name) - title: \($0.store.title) - tag: \($0.store.tag)")
        }

    }

    
    func testB_C_PreviewOffers() {
        guard let offersByLabel = storage.fetchShopsToPreview(byLabelId: 3, limit: 5) else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(offersByLabel)
        print("************************************")
        print("count \(offersByLabel.count)")
        offersByLabel.forEach {
            print("id of store \($0.id) - name: \($0.store.name) - title: \($0.store.title) - tag: \($0.store.tag)")
        }
        
    }

    
    func testB_D_PageOffers() {

        let sortAlpha = [NSSortDescriptor(key: "title", ascending: true)]
        let sortNew = [NSSortDescriptor(key: "id", ascending: true)]
        let sortPopular = [NSSortDescriptor(key: "priority", ascending: true)]
        guard let offersByLabel = storage.fetchPageShopsBy(labelId: 3, offSet: 0, sort: sortPopular, limit: 2) else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(offersByLabel)
        print("************************************")
        print("count \(offersByLabel.count)")
        offersByLabel.forEach {
            print("id of store \($0.id) - name: \($0.store.name) - title: \($0.store.title) - tag: \($0.store.tag)")
        }
        
    }
    
    func testB_E_SearchOffers() {
        
        guard let offersByLabel = storage.fetchShopsFromSearch(typeId: .ref, searchText: "Be") else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(offersByLabel)
        print("************************************")
        print("count \(offersByLabel.count)")
        
        offersByLabel.forEach {
            print("id of store \($0.id) - name: \($0.store.name) - title: \($0.store.title) - tag: \($0.store.tag)")
        }
        
    }

    func testB_E_FetchNotEmptyLabels() {
        
        guard let labels = storage.fetchNotEmptyLabels() else {
            XCTAssertNotNil(nil)
            return
        }
        XCTAssertNotNil(labels)
        XCTAssertNotEqual(labels.count, 0)
        labels.forEach{
            print("id of labels \($0.id) - name: \($0.name) - priority: \($0.priority)")
        }
        
    }
    
    func testPerformanceLabels() {
        // This is an example of a performance test case.
        self.measure {
            let _ = storage.fetchLabels()
        }
    }

    func testPerformanceOffers() {
        // This is an example of a performance test case.
        self.measure {
//            let shops = storage.fetchOffers()
            let _ = storage.fetchShopsFromSearch(typeId: .ref, searchText: "Be")
            
        }
    }
}
