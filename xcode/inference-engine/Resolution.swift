//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           16/05/2016
//

///
/// Uses the resolution method to make a general entailment for general PL. Refer to
/// p.254 of AIMA for more.
///
struct Resolution: EntailmentMethod {
    // MARK: Implement EntailmentMethod
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
        // the set of clauses in the CNF representation of KB ∧ ¬α
        var clauses = (kb.sentence & ~query).inConjunctiveNormalForm.split(.Conjoin)
        var newClauses = [Sentence]()
        while true {
            // Construct a pair for each clause in clauses that maps every unique
            // pair to a lhs and rhs
            var pairs = [(left: Sentence, right: Sentence)]()
            for i in 0.stride(to: clauses.endIndex, by: 1) {
                for j in 1.stride(to: clauses.endIndex, by: 1) {
                    let lhs = clauses[i]
                    let rhs = clauses[j]
                    // Don't want to double-insert with a swapped pair!
                    let alreadyContainsThisPair = pairs.contains({ (left, right) in
                        left == rhs && right == lhs
                    })
                    // Also ensure that lhs isnt the same as rhs
                    if lhs != rhs && !alreadyContainsThisPair {
                        pairs.append((left: lhs, right: rhs))
                    }
                }
            }
            // Iterate through every pair
            for (left, right) in pairs {
                let resolvents = self.resolve(left, right)
                // If resolvents contains the empty clause (a false atom) 
                // then return true
                if resolvents.contains({$0 == AtomicSentence.FalseAtomicSentence}) {
                    // Resolution successful!
                    return true
                }
                // Union resolvents to newClauses
                newClauses = newClauses.union(resolvents)
            }
            // if new is a subset of clauses (no difference) then return false
            if clauses.difference(newClauses).isEmpty {
                return false
            }
            // Union newClauses to newClauses
            clauses = clauses.union(newClauses)
        }
    }

    ///
    /// Returns all possible clauses obtained by resolving the left and right
    /// sentences provided
    ///
    func resolve(left: Sentence, _ right: Sentence) -> [Sentence] {
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
                    let all: [Sentence] = [without.left, without.right].flatMap({$0})
                    // Get only the unique elements in all
                    var unique = [Sentence]()
                    for el in all {
                        if !unique.contains({el == $0}) {
                            unique.append(el)
                        }
                    }
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
