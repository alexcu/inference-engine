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
        let sentence = self.sentences.first!
        // Reduce the rest
        return sentences.dropFirst().reduce(sentence) { (memo: Sentence, sentence: Sentence) in
            ComplexSentence(leftSentence: memo,
                            connective: .Conjoin,
                            rightSentence: sentence)
        }
    }
    
    ///
    /// Initialises a KB with a set of percepts
    ///
    init(percepts: [Sentence]) {
        if percepts.isEmpty {
            fatalError("Must initialise knowledge base with at least one percept")
        }
        self.sentences = percepts
        self.symbols = Set(percepts.flatMap { $0.symbols })
    }
}
