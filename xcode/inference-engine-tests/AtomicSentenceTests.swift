//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           26/04/2016
//

import XCTest

class AtomicSentenceTests: XCTestCase {
    func testAtomicSentenceAsTrue() {
        let symbol = AtomicSentence("p")
        XCTAssertEqual(symbol.atom, PropositionalSymbol(symbol: "p"))
        XCTAssertTrue(symbol.isPositive)
        XCTAssertFalse(symbol.isNegative)
    }
    
    func testAtomicSentenceAsFalse() {
        let symbol = AtomicSentence("p", false)
        XCTAssertEqual(symbol.atom, PropositionalSymbol(symbol: "p"))
        XCTAssertFalse(symbol.isPositive)
        XCTAssertTrue(symbol.isNegative)
    }
    
    func testAtomicSentenceAsPropositionalAtomicSentenceTrue() {
        let ps = PropositionalSymbol(symbol: "p")
        let symbol = AtomicSentence(ps)
        XCTAssertEqual(symbol.atom, ps)
        XCTAssertTrue(symbol.isPositive)
        XCTAssertFalse(symbol.isNegative)
    }
    
    func testAtomicSentenceAsPropositionalAtomicSentenceFalse() {
        let ps = PropositionalSymbol(symbol: "p")
        let symbol = AtomicSentence(ps, false)
        XCTAssertEqual(symbol.atom, ps)
        XCTAssertFalse(symbol.isPositive)
        XCTAssertTrue(symbol.isNegative)
    }
    
    func testAtomicSentenceAsAlwaysTrue() {
        let symbol = AtomicSentence(PropositionalSymbol.True)
        XCTAssertEqual(symbol.atom, PropositionalSymbol.True)
        XCTAssertTrue(symbol.isPositive)
        XCTAssertFalse(symbol.isNegative)
    }
    
    func testAtomicSentenceAsAlwaysFalse() {
        let symbol = AtomicSentence(PropositionalSymbol.False)
        XCTAssertEqual(symbol.atom, PropositionalSymbol.False)
        XCTAssertFalse(symbol.isPositive)
        XCTAssertTrue(symbol.isNegative)
    }
}

