//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           17/05/2016
//

import XCTest

class ResolutionTests: XCTestCase {
    func testResolve() {
        let p = AtomicSentence("p")
        let q = AtomicSentence("q")
        let s = AtomicSentence("s")
        let t = AtomicSentence("t")
        // resolve (p|q|s) and (~q|~s|t) should be [(p | s | ~s | t), (p | q | ~q | t)]
        let s1 = (p | q | s).inConjunctiveNormalForm
        let s2 = (~q | ~s | t).inConjunctiveNormalForm
        let actual = Resolution().resolve(s1, s2)
        let expected = [(p | s | ~s | t), (p | q | ~q | t)]
        XCTAssert(actual.description == expected.description)
    }
    func testResolveEmpty() {
        let a = AtomicSentence("a")
        // when A is resolved with ~A, we obtain the empty clause
        let actual = Resolution().resolve(a, ~a)
        let expected = [AtomicSentence.FalseAtomicSentence]
        XCTAssert(actual.description == expected.description)
    }
    func testResolution() {
        entailmentTest(usingMethod: Resolution(),
                       tell: XCTestCase.resolutionKB,
                       ask: "~p1",
                       expected: "YES")
    }
}

