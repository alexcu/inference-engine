//
//  inference_engine_tests.swift
//  inference-engine-tests
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class ComplexSentenceTests: XCTestCase {

    func testNegate() {
        // P    ~P
        // t     f
        let p = AtomicSentence("p")
        XCTAssert((~p).isNegative)
    }
    func testConjoin() {
        // P    Q   P & Q
        // t    t     t
        // t    f     f
        // f    t     f
        // f    f     f
        let p = AtomicSentence("P")
        let q = AtomicSentence("Q")
        XCTAssert((p & q).isPositive)
        XCTAssert((~p & ~q).isNegative)
        XCTAssert((p & ~q).isNegative)
        XCTAssert((~p & q).isNegative)
    }
    func testDisjoin() {
        // P    Q   P | Q
        // t    t     t
        // t    f     t
        // f    t     t
        // f    f     f
        let p = AtomicSentence("P")
        let q = AtomicSentence("Q")
        XCTAssert((p | q).isPositive)
        XCTAssert((p | ~q).isPositive)
        XCTAssert((~p | q).isPositive)
        XCTAssert((~p | ~q).isNegative)
    }
    func testImplicates() {
        // P    Q   P => Q
        // t    t     t
        // t    f     f
        // f    t     t
        // f    f     t
        let p = AtomicSentence("P")
        let q = AtomicSentence("Q")
        XCTAssert((p => q).isPositive)
        XCTAssert((~p => q).isPositive)
        XCTAssert((~p => ~q).isPositive)
        XCTAssert((p => ~q).isNegative)
    }
    func testBidirectionalImplicate() {
        // P    Q   P <=> Q
        // t    t      t
        // t    f      f
        // f    t      f
        // f    f      t
        let p = AtomicSentence("P")
        let q = AtomicSentence("Q")
        XCTAssert((p <=> q).isPositive)
        XCTAssert((~p <=> ~q).isPositive)
        XCTAssert((~p <=> q).isNegative)
        XCTAssert((p <=> ~q).isNegative)
    }
    
    func test3Predicates() {
        let p = AtomicSentence("P")
        let q = AtomicSentence("Q")
        let r = AtomicSentence("R", false)
        
        // P    Q   R    P & Q | R
        // t    t   f   (t & t)| f = t
        let try1a = p & q | r
        XCTAssert(try1a.isPositive)
        
        // P    Q   R    P & Q | R
        // f    t   f   (f & t)| f = f
        let try2a = ~p & q | r
        XCTAssert(try2a.isNegative)
        
        // P    Q   R    P & Q | R
        // f    t   t   (f & t)| t = t
        let try3a = p & q | ~r
        XCTAssert(try3a.isPositive)
        
        // P    Q   R   P & Q | P & R
        // t    t   f   t     | f     = t
        let try1b = p & q | p & r
        XCTAssert(try1b.isPositive)
        
        // P    Q   R   P & Q | P & R
        // f    t   f   f     | f     = f
        let try2b = ~p & q | ~p & r
        XCTAssert(try2b.isNegative)
        
        // P    Q   R   P & Q | P & R
        // f    t   t   f     | f     = f
        let try3b = ~p & q | ~p & ~r
        XCTAssert(try3b.isNegative)
        
        // P    Q   R   P & Q | R | P & Q | P & R
        // t    t   f   t         | t     = t
        XCTAssert((try1a | try1b).isPositive)
        XCTAssert((p & q | r | p & q | p & r).isPositive)
        
        // P    Q   R   P & Q | R | P & Q | P & R
        // f    t   f   f         | f     = f
        XCTAssert((try2a | try2b).isNegative)
        XCTAssert((~p & q | r | ~p & q | ~p & r).isNegative)
        
        // P    Q   R   P & Q | R | P & Q | P & R
        // t    t   t   t         | f     = t
        XCTAssert((try3a | try3b).isPositive)
        XCTAssert((p & q | ~r | p & q | p & ~r).isPositive)
    }
    
    func testSymbols() {
        let actual = try! SentenceParser.sharedParser.parse("p1 => p2 & (p3 & p6) & p7 \\/ ~p4 <=> p5").symbols
        let expected = Set<PropositionalSymbol>([
            PropositionalSymbol(symbol: "p1"),
            PropositionalSymbol(symbol: "p2"),
            PropositionalSymbol(symbol: "p3"),
            PropositionalSymbol(symbol: "p6"),
            PropositionalSymbol(symbol: "p7"),
            PropositionalSymbol(symbol: "p4"),
            PropositionalSymbol(symbol: "p5")
        ])
        XCTAssertEqual(expected, actual)
    }
    
    func testModelApplication() {
        var model = [
            PropositionalSymbol(symbol: "B"): false
        ]
        
        var sentence = try! SentenceParser.sharedParser.parse("A & B")
        XCTAssert(sentence.applyModel(model).isNegative) // A & ~B
        
        sentence = try! SentenceParser.sharedParser.parse("A \\/ B")
        XCTAssert(sentence.applyModel(model).isPositive) // A \/s ~B
        
        sentence = try! SentenceParser.sharedParser.parse("A & ~B")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~~B
        
        sentence = try! SentenceParser.sharedParser.parse("A & B => C")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~B => C
        
        sentence = try! SentenceParser.sharedParser.parse("A & B => C")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~B => C
        
        model = [
            PropositionalSymbol(symbol: "C"): false
        ]
        
        sentence = try! SentenceParser.sharedParser.parse("A & B => C")
        XCTAssert(sentence.applyModel(model).isNegative) // A & B => ~C
        
        model = [
            PropositionalSymbol(symbol: "B"): false,
            PropositionalSymbol(symbol: "C"): false
        ]
        
        sentence = try! SentenceParser.sharedParser.parse("A & B <=> C")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~B => ~C
    }
    
    func testNNF() {
        let sentence = try! SentenceParser.sharedParser.parse("A <=> B \\/ C \\/ D \\/ E")
        sentence.inNegationNormalForm
    }
}
