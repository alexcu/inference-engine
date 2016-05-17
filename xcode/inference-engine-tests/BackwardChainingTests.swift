//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           12/05/2016
//

import XCTest

class BackwardChainingTests: XCTestCase {
    func testRainWet() {
        entailmentTest(usingMethod: BackwardChaining(),
                       tell: XCTestCase.rainWetKB,
                       ask: "w",
                       expected: "YES: u; w")
    }
    func testComplex() {
        entailmentTest(usingMethod: BackwardChaining(),
                       tell: XCTestCase.testFileKB,
                       ask: "d",
                       expected: "YES: p2; p3; p1; d")
    }
}
