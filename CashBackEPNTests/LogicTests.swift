//
//  CashBackEPNLogicTests.swift
//  CashBackEPNTests
//
//  Created by Ivan Nikitin on 07/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import XCTest
@testable import ePN_Cashback

class LogicTests: XCTestCase {
    
    private var emailsList: [String] = ["","","",""]
    private var passwordList: [String] = ["","","",""]
    private var passwordValid: [String] = []
    override func setUp() {
        super.setUp()
         continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func emailValidatorTest() {
        
        for index in 0..<emailsList.count {
            let email = emailsList[index]
            if !EmailValidator(text: email).isCorrect {
                XCTAssert(false, "fail Email validator for email \(email)")
            }
        }
    }
    
    func emailValidator2Test() {
        
        for index in 0..<emailsList.count {
            let email = emailsList[index]
            let validator = EmailValidator(text: email)
            if !validator.isValidEmail(testStr: email) {
                XCTAssert(false, "fail Email validator2 for email \(email)")
            }
        }
    }
    
    func emailValidator3Test() {
        
        for index in 0..<emailsList.count {
            let email = emailsList[index]
            let validator = EmailValidator(text: email)
            if !validator.isValid(email) {
                XCTAssert(false, "fail Email validator3 for email \(email)")
            }
        }
    }
    
    func passwordValidatorTest() {
        for index in 0..<passwordList.count {
            var message: String?
            let password = passwordList[index]
            let passwordValidator = PasswordValidator.init(text: password).reliability
            if !passwordValidator.contains(.atLeastEightCharacters) {
                message = NSLocalizedString("The password is too short", comment: "")
            } else {
                if passwordValidator.contains(.latinLettersOnly){
                    message = NSLocalizedString("Excellent password", comment: "")
                } else if passwordValidator.contains(.goodPassword) {
                    message = NSLocalizedString("Good password", comment: "")
                } else if passwordValidator.contains(.normalPassword) {
                    message = NSLocalizedString("Normal password", comment: "")
                } else {
                    message = "Something went wrong"
                }
            }
            XCTAssertEqual(message, passwordValid[index])
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
