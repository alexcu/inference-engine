//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           1/05/2016
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

