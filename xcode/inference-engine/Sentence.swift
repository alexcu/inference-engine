//
//  Sentence.swift
//  inference-engine
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

// Represents logical negation (NOT)
infix operator ! { precedence 1 }
prefix func !(lhs: Sentence) -> ComplexSentence {
    return lhs.negate()
}
// Represents logical conjunction (AND)
infix operator & { precedence 2 }
func &(lhs: Sentence, rhs: Sentence) -> ComplexSentence {
    return lhs.conjunctWith(rhs)
}
// Represents logical disjunction (OR)
infix operator | { precedence 3 }
func |(lhs: Sentence, rhs: Sentence) -> ComplexSentence {
    return lhs.disjoinWith(rhs)
}
// Represents logical implication
infix operator  => { precedence 4 }
func =>(lhs: Sentence, rhs: Sentence) -> ComplexSentence {
    return lhs.implicateWith(rhs)
}
// Represents logical biconditional
infix operator <=> { precedence 5 }
func <=>(lhs: Sentence, rhs: Sentence) -> ComplexSentence {
    return lhs.biconditionallyImplicateWith(rhs)
}

///
/// A sentence is the basic unit of logical expression. It is either a
/// complex sentence, consisting of operators and other sentences, or a 
/// single atomic sentence consisting of just a propoistional symbol.
/// - Remarks: Refer to the BNF defined in <i>AIMA</i>, p293
///
protocol Sentence: CustomStringConvertible {
    ///
    /// Bidirectionally implicates this sentence with another sentence
    ///
    func biconditionallyImplicateWith(other: Sentence) -> ComplexSentence
    ///
    /// Implicates this sentence with another sentence
    ///
    func implicateWith(other: Sentence) -> ComplexSentence
    ///
    /// Disjoins this sentence with another sentence
    ///
    func disjoinWith(other: Sentence) -> ComplexSentence
    ///
    /// Conjuncts this sentence with another sentence
    ///
    func conjunctWith(other: Sentence) -> ComplexSentence
    ///
    /// Negates this sentence
    ///
    func negate() -> ComplexSentence
    ///
    /// Returns `true` iff the sentence is negative
    ///
    var isNegative: Bool { get }
    ///
    /// Returns `true` iff the sentence is positive
    ///
    var isPositive: Bool { get }
    ///
    /// Returns the propositional symbols in this sentence
    ///
    var symbols: Set<PropositionalSymbol> { get }
    ///
    /// Comparator
    ///
    func isEqual(other: Sentence) -> Bool
    ///
    /// Applies the model provided to the sentence
    /// - Paramater model: The model to apply
    /// - Returns: A new sentence that has the model applied to it
    ///
    func applyModel(model: Model) -> Sentence
    ///
    /// Applies the model provided to the sentence
    /// - Paramater model: The model to apply
    /// - Returns: A new sentence that has the model applied to it
    ///
    func applyModel(model: ModelLiteralType) -> Sentence
    ///
    /// Description of truth
    ///
    var truthDescription: String { get }
}

extension Sentence {
    var isNegative: Bool {
        return !self.isPositive
    }

    var truthDescription: String {
        return String(self.description.characters.map({ char in
            if let sym = self.symbols.filter({ symbol in
                symbol.symbol == String(char)
            }).first {
                return sym.isTrue ? "t" : "f"
            } else {
                return char
            }
        }))
    }

    func biconditionallyImplicateWith(other: Sentence) -> ComplexSentence {
        // Bidirectional eliminiation equivalence
        return (self => other) & (other => self)
    }

    func implicateWith(other: Sentence) -> ComplexSentence {
        // Implication elimination equivalence
        return !self | other
    }

    func disjoinWith(other: Sentence) -> ComplexSentence {
        return ComplexSentence(leftSentence: self,
                               operator: .Disjoin,
                               rightSentence: other)
    }

    func conjunctWith(other: Sentence) -> ComplexSentence {
        return ComplexSentence(leftSentence: self,
                               operator: .Conjoin,
                               rightSentence: other)
    }

    func negate() -> ComplexSentence {
        return ComplexSentence(operator: .Negate, sentences: self)
    }
    
    func applyModel(model: ModelLiteralType) -> Sentence {
        let model = Model(elements: model)
        return self.applyModel(model)
    }
}


// MARK: Implement Equatable
func ==(lhs: Sentence, rhs: Sentence) -> Bool {
    return lhs.isEqual(rhs)
}
func !=(lhs: Sentence, rhs: Sentence) -> Bool {
    return !(lhs == rhs)
}