//
//  TruthTableTests.swift
//  inference-engine
//
//  Created by Alex on 1/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class TruthTableTests: XCTestCase {
    func testRainWet() {
        let sentences = [
            "r",
            "!u",
            "r&!u=>w"
        ].map({try! SentenceParser.sharedParser.parse($0)})
        
        let kb = KnowledgeBase.init(percepts: sentences)
        let query = try! SentenceParser.sharedParser.parse("w")
        XCTAssertEqual(TruthTable().entailCount(query: query, fromKnowledgeBase: kb), 1)
    }
    func testComplex() {
        let sentences = [
            "p2=> p3",
            "p3 => p1",
            "c => e",
            "b&e => f",
            "f&g => h",
            "p1=>d",
            "p1&p3 => c",
            "a",
            "b",
            "p2"
        ].map({try! SentenceParser.sharedParser.parse($0)})
        
        let kb = KnowledgeBase.init(percepts: sentences)
        let query = try! SentenceParser.sharedParser.parse("d")
        XCTAssertEqual(TruthTable().entailCount(query: query, fromKnowledgeBase: kb), 3)
    }
}

