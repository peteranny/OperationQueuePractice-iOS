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

    func testCancellableAPI() {
        let expection1 = XCTestExpectation()
        WebServiceAPI.shared.fetchGetResponse { data, error in
            XCTAssertEqual(error?.localizedDescription, "cancelled")
            expection1.fulfill()
        }
        let expection2 = XCTestExpectation()
        WebServiceAPI.shared.fetchGetResponse { data, error in
            XCTAssertNil(error)
            expection2.fulfill()
        }
        wait(for: [expection1, expection2], timeout: 3)
    }
    
    var expection31: XCTestExpectation!
    var expection32: XCTestExpectation!
    var expection33: XCTestExpectation!
    var expectionSuccess: XCTestExpectation!

    func testHTTPBinDataManager() {
        self.expection31 = XCTestExpectation()
        self.expection32 = XCTestExpectation()
        self.expection33 = XCTestExpectation()
        self.expectionSuccess = XCTestExpectation()
        HTTPBinDataManager.shared.delegate = self
        HTTPBinDataManager.shared.executeOperation()
        wait(for: [expection31, expection32, expection33, expectionSuccess], timeout: 3)
    }
}

extension WebServiceAPIPracticeTests: HTTPBinDataManagerDelegate {
    func manager(_ manager: HTTPBinDataManager, withProgress progress: Float) {
        if progress == 1.0/3 {
            expection31.fulfill()
        } else if progress == 2.0/3 {
            expection32.fulfill()
        } else if progress == 1 {
            expection33.fulfill()
        }
    }
    
    func manager(_ manager: HTTPBinDataManager, didFailWith error: Error) {
        
    }
    
    func manager(_ manager: HTTPBinDataManager, didSucceedWithGetResponse getResponse: Any, postResponse: Any, image: UIImage) {
        expectionSuccess.fulfill()
    }
}
