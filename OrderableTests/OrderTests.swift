//
//  OrderableTests.swift
//  OrderableTests
//
//  Created by kensuke-hoshikawa on 2018/01/28.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import XCTest
import Orderable
import FirebaseCore
import Pring

class OrderableTests: XCTestCase {
    var disposer: Disposer<Order>?

    var order: Order?

    override func setUp() {
        super.setUp()
        _ = FirebaseTest.shared
        let expectation: XCTestExpectation = XCTestExpectation(description: "order test")

        Model.setup { order in
            self.order = order
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    override func tearDown() {
        super.tearDown()
        order = nil
    }

    func testPayOrder() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "pay order")

        order?.paymentStatus = .paymentRequested
        order?.status = .paymentRequested
        order?.update()
        disposer = Order.listen(order!.id) { o, e in
            if o?.stripeChargeID != nil {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 20)
    }
}

