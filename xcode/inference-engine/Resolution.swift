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
        let clauses = (kb.sentence & ~query).inConjunctiveNormalForm.
        let new = Set<PropositionalSymbol>()
        while true {
            let size = clauses
        }
    }
}
