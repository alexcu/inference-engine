//
//  ForwardChaining.swift
//  inference-engine
//
//  Created by Alex on 4/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct ForwardChaining: EntailmentMethod {
    // MARK: Implement EntailmentMethod
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
        // Initialise our agenda and clauses
        let complexSentences: [ComplexSentence] =
            kb.sentences.filter({$0 is ComplexSentence}).map({$0 as! ComplexSentence})
        // Clauses are all those that are implication complex sentences
        let clauses = complexSentences.filter({$0.isSentenceKind(.Implicate)})
        // Support only horn clauses (i.e., strip AND for count)
        var count = clauses.map { clause in
            clause.countOfConnective(.Conjoin) + 1
        }
        // Add facts to our agenda (i.e., those not in clauses)
        var agenda: [AtomicSentence] =
            kb.sentences.filter({$0 is AtomicSentence}).map({$0 as! AtomicSentence})
        var entailed: [Sentence] = []

        while !agenda.isEmpty {
            let premise = agenda.removeFirst()
            entailed.append(premise)
            // For all clauses that contain this premise
            for (index, clause) in clauses.enumerate() {
                if clause.containsPremise(premise) {
                    // Reduce the count
                    count[index] -= 1
                    // All elements in premise are known?
                    if count[index] == 0 {
                        // RHS of clause can be concluded?
                        if let rhs = clause.sentences.right as? AtomicSentence {
                            if rhs == query {
                                // We're done! Add rhs to entailed and break
                                entailed.append(rhs)
                                break
                            } else {
                                agenda.append(rhs)
                            }
                        }
                    }
                }
            }
        }
        
        return entailed
    }
}