//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           25/04/2016
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
