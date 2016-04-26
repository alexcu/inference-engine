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
        // P    !P
        // t     f
        let p = AtomicSentence("p")
        XCTAssert(!p.isNegative)
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
        XCTAssert((!p & !q).isNegative)
        XCTAssert((p & !q).isNegative)
        XCTAssert((!p & q).isNegative)
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
        XCTAssert((p | !q).isPositive)
        XCTAssert((!p | q).isPositive)
        XCTAssert((!p | !q).isNegative)
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
        XCTAssert((!p => q).isPositive)
        XCTAssert((!p => !q).isPositive)
        XCTAssert((p => !q).isNegative)
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
        XCTAssert((!p <=> !q).isPositive)
        XCTAssert((!p <=> q).isNegative)
        XCTAssert((p <=> !q).isNegative)
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
        let try2a = !p & q | r
        XCTAssert(try2a.isNegative)
        
        // P    Q   R    P & Q | R
        // f    t   t   (f & t)| t = t
        let try3a = p & q | !r
        XCTAssert(try3a.isPositive)
        
        // P    Q   R   P & Q | P & R
        // t    t   f   t     | f     = t
        let try1b = p & q | p & r
        XCTAssert(try1b.isPositive)
        
        // P    Q   R   P & Q | P & R
        // f    t   f   f     | f     = f
        let try2b = !p & q | !p & r
        XCTAssert(try2b.isNegative)
        
        // P    Q   R   P & Q | P & R
        // f    t   t   f     | f     = f
        let try3b = !p & q | !p & !r
        XCTAssert(try3b.isNegative)
        
        // P    Q   R   P & Q | R | P & Q | P & R
        // t    t   f   t         | t     = t
        XCTAssert((try1a | try1b).isPositive)
        XCTAssert((p & q | r | p & q | p & r).isPositive)
        
        // P    Q   R   P & Q | R | P & Q | P & R
        // f    t   f   f         | f     = f
        XCTAssert((try2a | try2b).isNegative)
        XCTAssert((!p & q | r | !p & q | !p & r).isNegative)
        
        // P    Q   R   P & Q | R | P & Q | P & R
        // t    t   t   t         | f     = t
        XCTAssert((try3a | try3b).isPositive)
        XCTAssert((p & q | !r | p & q | p & !r).isPositive)
    }
}
