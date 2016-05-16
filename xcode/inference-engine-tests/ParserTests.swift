//
//  ParserTests.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class ParserTests: XCTestCase {
    func testExpectedDescription() {
        let sentenceDict: [String: String] = [
            "p => q": "p => q",
            "p & q => r": "(p & q) => r",
            "p \\/ q & r => s": "(p \\/ (q & r)) => s",
            "p <=> q & r & ~s \\/ ~t": "p <=> (((q & r) & ~s) \\/ ~t)",
            "~p \\/ ~s & r <=> q & t & ~p => ~t": "(~p \\/ (~s & r)) <=> (((q & t) & ~p) => ~t)",
            "(p \\/ q) & (~s => r & t \\/ v)": "(p \\/ q) & (~s => ((r & t) \\/ v))"
        ]

        for (sentence, desc) in sentenceDict {
            let sentence = sentenceFrom(sentence)
            XCTAssertEqual(sentence.description, desc.stringByReplacingOccurrencesOfString("\\/", withString: "|"))
        }

    }
}
