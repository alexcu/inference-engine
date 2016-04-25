//
//  TokeniserTests.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class TokeniserTests: XCTestCase {

    func testTokeniserLarge() {
        let stacks = try! tokenise("p1 => p2 & p3 & p6 & p7 | !p4 <=> p5")
        XCTAssertEqual(stacks.operators, [
            LogicalOperator.Implicate,
            LogicalOperator.Conjoin,
            LogicalOperator.Conjoin,
            LogicalOperator.Conjoin,
            LogicalOperator.Disjoin,
            LogicalOperator.Negate,
            LogicalOperator.Biconditional,
        ])
        XCTAssertEqual(stacks.symbols, [
            "p1",
            "p2",
            "p3",
            "p6",
            "p7",
            "p4",
            "p5"
        ])
    }
    
    func testTokeniserSmall() {
        let stacks = try! tokenise("p")
        XCTAssertEqual(stacks.operators, [])
        XCTAssertEqual(stacks.symbols, ["p"])
    }
}
