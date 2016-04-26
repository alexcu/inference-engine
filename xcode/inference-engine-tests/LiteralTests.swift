//
//  LiteralTests.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class LiteralTests: XCTestCase {
    func testLiteralAsTrue() {
        let symbol = Literal(atom: "p")
        XCTAssertEqual(symbol.atom, PropositionalSymbol(symbol: "p"))
        XCTAssertTrue(symbol.isPositive)
        XCTAssertFalse(symbol.isNegative)
    }
    
    func testLiteralAsFalse() {
        let symbol = Literal(atom: "p", isPositive: false)
        XCTAssertEqual(symbol.atom, PropositionalSymbol(symbol: "p"))
        XCTAssertFalse(symbol.isPositive)
        XCTAssertTrue(symbol.isNegative)
    }
    
    func testLiteralAsPropositionalLiteralTrue() {
        let ps = PropositionalSymbol(symbol: "p")
        let symbol = Literal(atom: ps)
        XCTAssertEqual(symbol.atom, ps)
        XCTAssertTrue(symbol.isPositive)
        XCTAssertFalse(symbol.isNegative)
    }
    
    func testLiteralAsPropositionalLiteralFalse() {
        let ps = PropositionalSymbol(symbol: "p")
        let symbol = Literal(atom: ps, isPositive: false)
        XCTAssertEqual(symbol.atom, ps)
        XCTAssertFalse(symbol.isPositive)
        XCTAssertTrue(symbol.isNegative)
    }
    
    func testLiteralAsAlwaysTrue() {
        let symbol = Literal(atom: PropositionalSymbol.True)
        XCTAssertEqual(symbol.atom, PropositionalSymbol.True)
        XCTAssertTrue(symbol.isPositive)
        XCTAssertFalse(symbol.isNegative)
    }
    
    func testLiteralAsAlwaysFalse() {
        let symbol = Literal(atom: PropositionalSymbol.False)
        XCTAssertEqual(symbol.atom, PropositionalSymbol.False)
        XCTAssertFalse(symbol.isPositive)
        XCTAssertTrue(symbol.isNegative)
    }
}
