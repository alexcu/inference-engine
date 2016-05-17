//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           12/05/2016
//

import XCTest

extension XCTestCase {
    func sentenceFrom(sentence: String) -> Sentence {
        return try! SentenceParser.sharedParser.parse(sentence)
    }

    static let rainWetKB: KnowledgeBase = {
        let percepts = [
            "r",
            "~u",
            "r&~u=>w"
        ].map({try! SentenceParser.sharedParser.parse($0)})

        return KnowledgeBase.init(percepts: percepts)
    }()

    static let testFileKB: KnowledgeBase = {
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
    
    static let resolutionKB: KnowledgeBase = {
        let percepts = [
            "(b <=> (p1 | p2)) & ~b"
        ].map({try! SentenceParser.sharedParser.parse($0)})
        
        return KnowledgeBase.init(percepts: percepts)
    }()

    static let smokeHeatFireKB: KnowledgeBase = {
        let percepts = [
            "((Smoke & Heat) => Fire) <=> ((Smoke => Fire) | (Heat => Fire))"
        ].map({try! SentenceParser.sharedParser.parse($0)})

        return KnowledgeBase.init(percepts: percepts)
    }()

    func entailmentTest(usingMethod entailmentMethod: EntailmentMethod, tell knowledgeBase: KnowledgeBase, ask query: String, expected: String) {
        let query = sentenceFrom(query)
        let entail = entailmentMethod.entail(query: query, fromKnowledgeBase: knowledgeBase)
        XCTAssertEqual(entail.description, expected)
    }
}
