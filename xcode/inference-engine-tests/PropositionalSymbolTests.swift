//
//  PropositionalSymbolTests.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
        let symbol = PropositionalSymbol.True
        XCTAssertEqual(symbol.symbol, "false")
        XCTAssertTrue(symbol.isFalse)
        XCTAssertFalse(symbol.isTrue)
    }
}
