//
//  inference_engine_tests.swift
//  inference-engine-tests
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class SentenceTests: XCTestCase {

    func testNegate() {
        // P    !P
        // t     f
        let p = Sentence(symbol: "P")
        XCTAssertFalse(!p.truth)
    }
    func testConjoin() {
        // P    Q   P & Q
        // t    t     t
        // t    f     f
        // f    t     f
        // f    f     f
        let p = Sentence(symbol: "P")
        let q = Sentence(symbol: "Q")
        XCTAssertTrue((p & q).truth)
        XCTAssertFalse((!p & !q).truth)
        XCTAssertFalse((p & !q).truth)
        XCTAssertFalse((!p & q).truth)
    }
    func testDisjoin() {
        // P    Q   P | Q
        // t    t     t
        // t    f     t
        // f    t     t
        // f    f     f
        let p = Sentence(symbol: "P")
        let q = Sentence(symbol: "Q")
        XCTAssertTrue((p | q).truth)
        XCTAssertTrue((p | !q).truth)
        XCTAssertTrue((!p | q).truth)
        XCTAssertFalse((!p | !q).truth)
    }
    func testImplicates() {
        // P    Q   P => Q
        // t    t     t
        // t    f     f
        // f    t     t
        // f    f     t
        let p = Sentence(symbol: "P")
        let q = Sentence(symbol: "Q")
        XCTAssertTrue((p => q).truth)
        XCTAssertTrue((!p => q).truth)
        XCTAssertTrue((!p => !q).truth)
        XCTAssertFalse((p => !q).truth)
    }
    func testBidirectionalImplicate() {
        // P    Q   P <=> Q
        // t    t      t
        // t    f      f
        // f    t      f
        // f    f      t
        let p = Sentence(symbol: "P")
        let q = Sentence(symbol: "Q")
        XCTAssertTrue((p <=> q).truth)
        XCTAssertTrue((!p <=> !q).truth)
        XCTAssertFalse((!p <=> q).truth)
        XCTAssertFalse((p <=> !q).truth)
    }

}
