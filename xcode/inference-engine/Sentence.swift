//
//  Sentence.swift
//  inference-engine
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

// Represents logical entailment (does entail and does NOT entail)
infix operator |=   { }
infix operator |/=  { }

// Represents logical biconditional
infix operator <=> { }
func <=>(lhs: Sentence, rhs: Sentence) -> Sentence {
    return lhs.biconditionallyImplicateWith(rhs)
}

// Represents logical implication
infix operator  => { }
func =>(lhs: Sentence, rhs: Sentence) -> Sentence {
    return lhs.implicateWith(rhs)
}

// Represents logical disjunction (OR)
func |(lhs: Sentence, rhs: Sentence) -> Sentence {
    return lhs.disjoinWith(rhs)
}

// Represents logical conjunction (AND)
func &(lhs: Sentence, rhs: Sentence) -> Sentence {
    return lhs.conjunctWith(rhs)
}
// Represents logical negation (NOT)
prefix func !(lhs: Sentence) -> Sentence {
    return lhs.negate()
}

struct Sentence {
    let symbol: String
    let truth: Bool

    init(symbol: String, truth: Bool = true) {
        self.symbol = symbol
        self.truth = truth
    }

    func biconditionallyImplicateWith(other: Sentence) -> Sentence {
        // Bidirectional eliminiation equivalence
        return (self => other) & (other => self)
    }

    func implicateWith(other: Sentence) -> Sentence {
        // Implication elimination equivalence
        return !self | other
    }

    func disjoinWith(other: Sentence) -> Sentence {
        let symbol = "\(self.symbol)|\(other.symbol)"
        let truth = self.truth || other.truth
        return Sentence(symbol: symbol, truth: truth)
    }

    func conjunctWith(other: Sentence) -> Sentence {
        let symbol = "\(self.symbol)&\(other.symbol)"
        let truth = self.truth && other.truth
        return Sentence(symbol: symbol, truth: truth)
    }

    func negate() -> Sentence {
        return Sentence(symbol: "!\(self.symbol)", truth: !self.truth)
    }
}