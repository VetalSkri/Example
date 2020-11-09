//
//  GoodsApiTest.swift
//  CashBackEPNTests
//
//  Created by Александр Кузьмин on 12/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCTest
@testable import ePN_Cashback

class GoodsApiTest: XCTestCase {

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

    func testGoodsByImage() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.findGoodsByImage(image: "data:image/gif;base64,R0lGODlhEAAOALMAAOazToeHh0tLS/7LZv/0jvb29t/f3//Ub//ge8WSLf/rhf/3kdbW1mxsbP//mf///yH5BAAAAAAALAAAAAAQAA4AAARe8L1Ekyky67QZ1hLnjM5UUde0ECwLJoExKcppV0aCcGCmTIHEIUEqjgaORCMxIC6e0CcguWw6aFjsVMkkIr7g77ZKPJjPZqIyd7sJAgVGoEGv2xsBxqNgYPj/gAwXEQA7") { (result) in
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
    
    func testGoodsByEmptyFilter() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsByFilter(filter: nil, limit: nil, offset: nil, sort: nil) { (result) in
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
    
    func testGoodsByFilter() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsByFilter(filter: GoodsSearchFilter(name: "good", offers: nil, price: nil, cashback: nil, rate: nil, categories:  nil), limit: nil, offset: nil, sort: nil) { (result) in
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
    
    func testGoodsByFilterWithPaging() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsByFilter(filter: nil, limit: 40, offset: 1, sort: nil) { (result) in
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
    
    func testGoodsByFilterWithSort() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsByFilter(filter: nil, limit: nil, offset: nil, sort: "cashback,-date") { (result) in
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
    
    func testGoodsWishlist() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsWishlist(categories: nil, limit: nil, offset: nil, sort: nil) { (result) in
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
    
    func testGoodsWishlistWithFilter() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsWishlist(categories: 10, limit: nil, offset: nil, sort: nil) { (result) in
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
    
    func testGoodsWishlistWithPaging() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsWishlist(categories: nil, limit: 40, offset: 1, sort: nil) { (result) in
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
    
    func testGoodsWishlistWithSorting() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.goodsWishlist(categories: nil, limit: nil, offset: nil, sort: "cashback,-date") { (result) in
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
    
    func testGoodsAddToWishlist() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.addGoodsToWishlist(offerId: 1, productId: 32976011330) { (result) in
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
    
    func testGoodsRemoveFromWishlist() {
        let expectedResult = expectation(description: "Async request")
        
        GoodsApiClient.removeGoodsFromWishlist(offerId: 1, productId: 32976011330) { (result) in
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
