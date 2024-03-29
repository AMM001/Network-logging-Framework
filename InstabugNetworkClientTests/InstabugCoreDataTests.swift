//
//  InstabugCoreDataTests.swift
//  InstabugNetworkClientTests
//
//  Created by admin on 08/04/2022.
//

import XCTest
@testable import InstabugNetworkClient

class InstabugCoreDataTests: XCTestCase {

    func testSaveNewRecord() {
        let context = PersistentContainer.shared.newBackgroundContext()
        let request = RequestConvertible(baseURL: "https://httpbin.org/", endPoint: "get", method: .get, headers: nil, parameters: nil)
        NetworkClient.instance.request(with: request) { _result in
            NetworkClient.instance.saveRequestData(request: request, operationResult: _result)
            XCTAssertNotNil(Request.totalNumber(in:context))
        }
    }
    
    func testLoadingNetworkRequests() {
        let request = RequestConvertible(baseURL: "https://httpbin.org/", endPoint: "get", method: .get, headers: nil, parameters: nil)
        NetworkClient.instance.request(with: request) { _result in
            NetworkClient.instance.saveRequestData(request: request, operationResult: _result)
            let context = PersistentContainer.shared.newBackgroundContext()
            let requestsCount = Request.totalNumber(in: context)
            let responsesCount = Response.totalNumber(in: context)
            XCTAssertTrue(requestsCount > 0 && responsesCount > 0)
        }
    }
    
    func testRecordsLimit() {
        let context = PersistentContainer.shared.newBackgroundContext()
        for _ in 0...1000 {
            let request = RequestConvertible(baseURL: "https://httpbin.org/", endPoint: "get", method: .get, headers: nil, parameters: nil)
            NetworkClient.instance.request(with: request) { _result in
                NetworkClient.instance.saveRequestData(request: request, operationResult: _result)
            }
        }
        let expectedCount = 1000
        let requestCount = Request.totalNumber(in: context)
        let responsesCount = Response.totalNumber(in: context)
        XCTAssertTrue(requestCount <= expectedCount)
        XCTAssertTrue(responsesCount <= expectedCount)
    }

}
