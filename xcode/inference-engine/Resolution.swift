//
//  Resolution.swift
//  inference-engine
//
//  Created by Alex on 16/05/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Uses the resolution method to make a general entailment for general PL
///
struct Resolution: EntailmentMethod {
    // MARK: Implement EntailmentMethod
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
        // the set of clauses in the CNF representation of KB ∧ ¬α
        let clauses = (kb.sentence & ~query).inConjunctiveNormalForm.split(.Conjoin)
        var newClauses = [Sentence]()
        while true {
            // for each pair of clauses Ci, Cj in clauses do
            let pairs = clauses[1...clauses.count-1].enumerate().map { index, element in
                (left: clauses[index - 1], right: element)
            }
            for (left, right) in pairs {
                let resolvents = self.resolve(left, right)
                // Contains the False propositional
                if resolvents.contains({$0.}) {
                    return newClauses
                }
                let clausesNotInNew = resolvents.filter({})
                newClauses.appendContentsOf(clausesNotInNew)
            }
            if newClauses.filter({clauses.contains($0.symbols.isEmpty)}).count {

            }
        }
    }

    ///
    /// Returns all possible clauses obtained by resolving left and right
    ///
    private func resolve(left: Sentence, _ right: Sentence) -> [Sentence] {
        let leftDisjuncts = left.split(.Disjoin)
        let rightDisjuncts = right.split(.Disjoin)
        var clauses = [Sentence]()
        for lhs in leftDisjuncts {
            for rhs in rightDisjuncts {
                if lhs == ~rhs || rhs == ~lhs {
                    // Left and right disjuncts without lhs and rhs
                    let without = (
                        left:   leftDisjuncts.filter({$0 != lhs}),
                        right:  rightDisjuncts.filter({$0 != rhs})
                    )
                    // Unique to both left and right
                    let unique = without.left.filter({ (el: Sentence) in
                        without.right.contains({el == $0})
                    })
                    // Disjoin all clauses in unique
                    let clause = unique.join(.Disjoin)
                    // Add disjoined clause to clauses
                    clauses.append(clause)
                }
            }
        }
        return clauses
    }
}
