//
//  AtomicSentenceTests.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
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

