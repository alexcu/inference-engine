//
//  BackwardChainingTests.swift
//  inference-engine
//
//  Created by Alex on 12/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class BackwardChainingTests: XCTestCase {
    func testRainWet() {
        entailmentTest(usingMethod: BackwardChaining(),
                       tell: XCTestCase.rainWetKB,
                       ask: "w",
                       expected: "YES: r")
    }
    func testComplex() {
        entailmentTest(usingMethod: BackwardChaining(),
                       tell: XCTestCase.exampleKB,
                       ask: "d",
                       expected: "YES: p2, p3, p1, d")
    }
}
