//
//  XCTestCase+EntailmentTest.swift
//  inference-engine
//
//  Created by Alex on 12/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

extension XCTestCase {
    static let rainWetKB: KnowledgeBase = {
        let percepts = [
            "r",
            "~u",
            "r&~u=>w"
        ].map({try! SentenceParser.sharedParser.parse($0)})

        return KnowledgeBase.init(percepts: percepts)
    }()

    static let exampleKB: KnowledgeBase = {
        let percepts = [
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

        return KnowledgeBase.init(percepts: percepts)
    }()

    func entailmentTest(usingMethod entailmentMethod: EntailmentMethod, tell knowledgeBase: KnowledgeBase, ask query: String, expected: String) {
        let query = try! SentenceParser.sharedParser.parse(query)
        let entail = entailmentMethod.entail(query: query, fromKnowledgeBase: knowledgeBase)
        XCTAssertEqual(entail.description, expected)
    }
}
