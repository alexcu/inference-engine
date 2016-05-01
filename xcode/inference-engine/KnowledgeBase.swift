//
//  KnowledgeBase.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A knowledge base for retaining state information
///
struct KnowledgeBase {   
    ///
    /// Set of sentences in the knowledge base
    ///
    let sentences: [Sentence]
    
    ///
    /// Propositional symbols in the KB
    ///
    let symbols: Set<PropositionalSymbol>
    
    ///
    /// Returns the knowledge base as a single sentence by conjoining all sentences
    /// within the knowledge base
    ///
    var sentence: Sentence {
        // Always at least two sentences
        let sentence = ComplexSentence(leftSentence: self.sentences.first!,
                                       operator: .Conjoin,
                                       rightSentence: self.sentences.last!)
        // Reduce the rest
        return sentences.reduce(sentence) { (memo: ComplexSentence, sentence: Sentence) in
            ComplexSentence(leftSentence: memo,
                            operator: .Conjoin,
                            rightSentence: sentence)
        }
    }
    
    ///
    /// Initialises a KB with a set of percepts
    ///
    init(percepts: [Sentence]) {
        if percepts.count < 2 {
            fatalError("Must initialise knowledge base with at least two percepts")
        }
        self.sentences = percepts
        self.symbols = Set(percepts.flatMap { $0.symbols })
    }
    
    ///
    /// Ask the knowledge base a query
    /// - Paramater query: The query to ask
    /// - Returns: `true` iff the knowledge base entails the query
    ///
//    func ask(query: Sentence) -> Bool {
//        
//    }
}
