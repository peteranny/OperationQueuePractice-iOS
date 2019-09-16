//
//  WebServiceAPIPracticeTests.swift
//  WebServiceAPIPracticeTests
//
//  Created by peter.shih on 2019/9/16.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

import XCTest
@testable import WebServiceAPIPractice

class WebServiceAPIPracticeTests: XCTestCase {
    func testGetResponse() {
        let expection = XCTestExpectation()
        WebServiceAPI.shared.fetchGetResponse { data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            expection.fulfill()
        }
        wait(for: [expection], timeout: 3)
    }
    
    func testPostCustomerName() {
        let expection = XCTestExpectation()
        WebServiceAPI.shared.postCustomerName("Peter Shih") { data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.form?["custname"], "Peter Shih")
            expection.fulfill()
        }
        wait(for: [expection], timeout: 3)
    }

    func testFetchImage() {
        let expection = XCTestExpectation()
        WebServiceAPI.shared.fetchImage { image, error in
            XCTAssertNil(error)
            XCTAssertNotNil(image)
            expection.fulfill()
        }
        wait(for: [expection], timeout: 3)
    }
}
