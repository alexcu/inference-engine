//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           25/04/2016
//

import XCTest

class PropositionalSymbolTests: XCTestCase {
    func testPropositionalSymbol() {
        let symbol = PropositionalSymbol(symbol: "p")
        XCTAssertEqual(symbol.symbol, "p")
        XCTAssertFalse(symbol.isFalse)
        XCTAssertFalse(symbol.isTrue)
    }
    
    func testTruePropositionalSymbol() {
        let symbol = PropositionalSymbol.True
        XCTAssertEqual(symbol.symbol, "true")
        XCTAssertFalse(symbol.isFalse)
        XCTAssertTrue(symbol.isTrue)
    }
    
    func testFalsePropositionalSymbol() {
        let symbol = PropositionalSymbol.False
        XCTAssertEqual(symbol.symbol, "false")
        XCTAssertTrue(symbol.isFalse)
        XCTAssertFalse(symbol.isTrue)
    }
}
