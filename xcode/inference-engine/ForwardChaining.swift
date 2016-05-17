//
//  ForwardChaining.swift
//  inference-engine
//
//  Created by Alex on 4/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Implements the forward chaining algorithm for entailing information. Refer to
/// p.257 of AIMA for more.
///
struct ForwardChaining: EntailmentMethod {
    // MARK: Implement EntailmentMethod
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
        // Initialise our agenda and clauses
        let clauses: [ComplexSentence] = kb.clauses
        // Count is map of each clause sentence mapped to the conjoined count
        var count = clauses.reduce([String:Int]()) { (dict, clause) in
            var dict = dict
            dict[clause.description] = clause.countOfConnective(.Conjoin) + 1
            return dict
        }
        
        // Reduces the count for a clause
        func reduceCount(clause: ComplexSentence) {
            count[clause.description]! -= 1
        }
        // Checks if all elements are now known in the count
        func isKnown(clause: ComplexSentence) -> Bool {
            return count[clause.description]! == 0
        }
        
        // Add facts to our agenda (i.e., those not in clauses)
        var agenda: [AtomicSentence] = kb.facts
        // Result of the entailment - how many sentences that were entailed
        var entailed: [Sentence] = []
        // Keep processing while the agenda is not empty or if the loop is break'ed
        while !agenda.isEmpty {
            // Grab the next premise out of the agenda
            let premise = agenda.removeFirst()
            // Add this premise to the entailed result - we will process it
            entailed.append(premise)
            // Filter out all clauses that don't contain this premise
            let clausesWithPremise = clauses.filter({ $0.containsPremise(premise) })
            // For all clauses that contain this premise
            for clause in clausesWithPremise {
                // Reduce the count of this clause as we will process it
                reduceCount(clause)
                // All elements are now known?
                if isKnown(clause) {
                    // Grab out the conclusion as an atomic sentence
                    if let rhs = clause.sentences.right as? AtomicSentence {
                        // Can the conclusion of the clause can be entailed?
                        if rhs == query {
                            // We're done! Add rhs to entailed and break
                            entailed.append(rhs)
                            break
                        } else {
                            // Keep processing with the atomic sentence
                            agenda.append(rhs)
                        }
                    }
                }
            }
        }
        
        return entailed
    }
}