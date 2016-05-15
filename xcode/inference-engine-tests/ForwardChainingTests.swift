//
//  ForwardChainingTests.swift
//  inference-engine
//
//  Created by Alex on 12/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class ForwardChainingTests: XCTestCase {
    func testRainWet() {
        entailmentTest(usingMethod: ForwardChaining(),
                       tell: XCTestCase.rainWetKB,
                       ask: "w",
                       expected: "YES: r")
    }
    func testComplex() {
        entailmentTest(usingMethod: ForwardChaining(),
                       tell: XCTestCase.testFileKB,
                       ask: "d",
                       expected: "YES: a; b; p2; p3; p1; d")
    }
}


