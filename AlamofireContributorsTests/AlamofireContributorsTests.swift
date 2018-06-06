//
//  AlamofireContributorsTests.swift
//  AlamofireContributorsTests
//
//  Created by Dmytro Skorokhod on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import XCTest
@testable import AlamofireContributors

class AlamofireContributorsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPIClient() {
        let exp = expectation(description: "ContributorsHaveBeenReceived")
        APIClient.shared.requestContributors { contributors in
            XCTAssert(contributors.count > 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
