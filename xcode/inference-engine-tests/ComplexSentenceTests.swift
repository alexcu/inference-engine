//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           20/04/2016
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
        let actual = sentenceFrom("p1 => p2 & (p3 & p6) & p7 | ~p4 <=> p5").symbols
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
        
        var sentence = sentenceFrom("A & B")
        XCTAssert(sentence.applyModel(model).isNegative) // A & ~B
        
        sentence = sentenceFrom("A | B")
        XCTAssert(sentence.applyModel(model).isPositive) // A \/s ~B
        
        sentence = sentenceFrom("A & ~B")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~~B
        
        sentence = sentenceFrom("A & B => C")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~B => C
        
        sentence = sentenceFrom("A & B => C")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~B => C
        
        model = [
            PropositionalSymbol(symbol: "C"): false
        ]
        
        sentence = sentenceFrom("A & B => C")
        XCTAssert(sentence.applyModel(model).isNegative) // A & B => ~C
        
        model = [
            PropositionalSymbol(symbol: "B"): false,
            PropositionalSymbol(symbol: "C"): false
        ]
        
        sentence = sentenceFrom("A & B <=> C")
        XCTAssert(sentence.applyModel(model).isPositive) // A & ~B => ~C
    }
    
    func testNNF_Implication() {
        // P <=> Q to ~P & Q
        let sentence = sentenceFrom("P => Q")
        let expected = sentenceFrom("~P | Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Bidirectional() {
        // P <=> Q to (P | ~Q) & (~P | Q)
        let sentence = sentenceFrom("P <=> Q")
        let expected = sentenceFrom("(~P | Q) & (~Q | P)")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_DoubleNegation() {
        // Double negation
        let sentence = sentenceFrom("~(~P)")
        let expected = sentenceFrom("P")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_DoubleNegation2() {
        // Double negation
        let sentence = sentenceFrom("~~~P")
        let expected = sentenceFrom("~P")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_Disjoin() {
        // ~(A) where A = (P & Q)
        let sentence = sentenceFrom("~(P & Q)")
        let expected = sentenceFrom("~P | ~Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_Disjoin2() {
        // ~(A) where A = (~(P & R) | Q)
        let sentence = sentenceFrom("~(~(P & R) | Q)")
        let expected = sentenceFrom("P & R & ~Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_Disjoin3() {
        // ~(A) where A = (~(P | R) | Q)
        let sentence = sentenceFrom("~(~(P | R) | Q)")
        let expected = sentenceFrom("(P | R) & ~Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_Conjoin() {
        // ~(A) where A = (P | Q)
        let sentence = sentenceFrom("~(P | Q)")
        let expected = sentenceFrom("~P & ~Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_Conjoin2() {
        // ~(A) where A = (~(P | R) & Q)
        let sentence = sentenceFrom("~(~(P | R) & Q)")
        let expected = sentenceFrom("P | R | ~Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testNNF_Demorgan_Conjoin3() {
        // ~(A) where A = (~(P & R) & Q)
        let sentence = sentenceFrom("~(~(P & R) & Q)")
        let expected = sentenceFrom("(P & R) | ~Q")
        XCTAssert(sentence.inNegationNormalForm == expected)
    }
    
    func testWithoutImplications() {
        let sentence = sentenceFrom("A => (~B <=> C)")
        let expected = sentenceFrom("~A | ((~B | ~C) & (~~B | C))")
        XCTAssert(sentence.withoutImplications == expected)
    }
    
    func testCNF() {
        let sentence = sentenceFrom("(P | (Q & R))")
        let expected = sentenceFrom("(P | Q) & (P | R)")
        XCTAssert(sentence.inConjunctiveNormalForm == expected)
    }

    func testCNF2() {
        let sentence = sentenceFrom("(p & q) | (p & ~q)")
        let expected = sentenceFrom("((p | p) & (q | p)) & ((p | ~q) & (q | ~q))")
        XCTAssert(sentence.inConjunctiveNormalForm == expected)
    }
    
    func testCNF3() {
        let firstHalf =  [
            "(((p | r) | ~q) & ((q | r) | ~q))",
            "(((p | s) | ~q) & ((q | s) | ~q))",
        ].joinWithSeparator(" & ")
        
        let secondHalf = [
            "(((p | r) | (p | t)) & ((q | r) | (p | t)))",
            "(((p | s) | (p | t)) & ((q | s) | (p | t)))"
        ].joinWithSeparator(" & ")
        
        let expectedSentence = "(\(firstHalf)) & (\(secondHalf))"
        
        let sentence = sentenceFrom("((p & q) | (r & s)) | (~q & (p | t))")
        let expected = sentenceFrom(expectedSentence)
        XCTAssert(sentence.inConjunctiveNormalForm == expected)
    }

    func testSplit() {
        let actual = sentenceFrom("a & (b | c) & (d => e) & g").split(.Conjoin).map({$0.description})
        let expected  = [
            "a",
            "b | c",
            "d => e",
            "g"
        ]
        XCTAssertEqual(actual, expected)
    }

    func testSetOps() {
        let s1 = [
            sentenceFrom("a"),
            sentenceFrom("b"),
            sentenceFrom("c"),
            sentenceFrom("d"),
            sentenceFrom("e")
        ]
        let s2 = [
            sentenceFrom("d"),
            sentenceFrom("e")
        ]
        let s3 = [
            sentenceFrom("a"),
            sentenceFrom("b"),
            sentenceFrom("c")
        ]
        
        let union = s3.union(s2)
        XCTAssertEqual(union.description, s1.description)
        
        let difference = s2.difference(s1)
        XCTAssertEqual(difference.description, s3.description)
    }

}
