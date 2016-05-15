//
//  TruthTableTests.swift
//  inference-engine
//
//  Created by Alex on 1/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class TruthTableTests: XCTestCase {
    func testRainWet() {
        entailmentTest(usingMethod: TruthTable(),
                       tell: XCTestCase.rainWetKB,
                       ask: "w",
                       expected: "YES: 1")
    }
    func testComplex() {
        entailmentTest(usingMethod: TruthTable(),
                       tell: XCTestCase.testFileKB,
                       ask: "d",
                       expected: "YES: 3")
    }
    func testParens() {
        entailmentTest(usingMethod: TruthTable(),
                       tell: XCTestCase.smokeHeatFireKB,
                       ask: "smoke",
                       expected: "YES: 4")
    }
}

