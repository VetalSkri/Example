//
//  ShopApiTest.swift
//  CashBackEPNTests
//
//  Created by Александр Кузьмин on 19/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import XCTest
@testable import ePN_Cashback

class ShopApiTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testShopInfo() {
        let expectedResult = expectation(description: "Async request")
        
        ShopApiClient.shopInfo(forShopId: 1) { (result) in
            switch result{
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
