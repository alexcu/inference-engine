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
    
    ///
    /// Returns the facts from the knowledge base - essentially all atomic sentences
    /// that comprimise the knowledge base's sentences
    ///
    var facts: [AtomicSentence] {
        return self.sentences
            // Filter out all complex sentences
            .filter({ $0 is AtomicSentence })
            // Map them as Atomic Sentences
            .map({ $0 as! AtomicSentence })
    }
    
    ///
    /// Returns the clauses from the knowledge base - essentially all complex sentences
    /// that comprimise the knowledge base's sentences
    ///
    var clauses: [ComplexSentence] {
        return self.sentences
            // Filter out all atomic sentences
            .filter({ $0 is ComplexSentence })
            // Map them as ComplexSentences
            .map({ $0 as! ComplexSentence })
            // Filter only those complex sentences that are implication sentences
            .filter({$0.isSentenceKind(.Implicate)})
    }
}
