//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           12/05/2016
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


