//
//  BackwardChaining.swift
//  inference-engine
//
//  Created by Alex on 4/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct BackwardChaining: EntailmentMethod {
    // MARK: Implement EntailmentMethod
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
        // Initialise our agenda and clauses
        let clauses: [ComplexSentence] = kb.clauses
        // Add facts in (i.e., atomic sentences)
        let facts: [AtomicSentence] =
            kb.sentences.filter({$0 is AtomicSentence}).map({$0 as! AtomicSentence})
        // Agenda starts with the query first; query must be atomic
        guard let query = query as? AtomicSentence else {
            return 0 // cannot be entailed
        }
        // Agenda - starts off with the query
        var agenda: [AtomicSentence] = [query]
        // Result of the entailment - how many sentences that were entailed
        var entailed: [AtomicSentence] = []
        
        while !agenda.isEmpty {
            let conclusion = agenda.removeLast()
            entailed.insert(conclusion, atIndex: 0)
            // Facts do not contain the query?
            if facts.contains({$0 != query}) {
                let symbols: [AtomicSentence] = clauses
                    // Filter out clauses that don't contain the conclusion
                    .filter({ clause in
                        clause.containsConclusion(conclusion)
                    })
                    // mapped to their premise symbols as atomic sentences
                    .map({ clause in
                        clause.sentences.left!.symbols.map { AtomicSentence($0) }
                    })
                    // flattened
                    .flatMap({$0})
                // No more symbols? Break the loop
                if symbols.isEmpty {
                    break
                } else {
                    // Get all the symbols we are yet to entail and add them
                    // to our agenda
                    let symbolsNotInEntailed = symbols.filter({ symbol in
                        !entailed.contains(symbol)
                    })
                    agenda.appendContentsOf(symbolsNotInEntailed)
                }
            }
        }
        
        return entailed
    }
}