//
//  ComplexSentence.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// The representation language for propositional logic is made up of a number
/// of sentences.
///
struct ComplexSentence: Sentence, Equatable {
    // MARK: Implement Custom[Debug]StringConvertible
    var description: String {
        /// Make a description based off of the sentence
        func makeDescription(sen: Sentence) -> String {
            if let sen = sen as? ComplexSentence {
                // For unary sentences with an atomic right sentence, ignore
                // wrapping parentheses around the sentence
                if sen.isUnary && sen.sentences.right is AtomicSentence {
                    return "\(sen.`operator`)\(sen.sentences.right)"
                } else {
                    return "(\(sen.description))"
                }
            } else {
                return sen.description
            }
        }
        let rhs = self.sentences.right
        let rhsDescription = makeDescription(rhs)
        if self.isBinary {
            let lhs = self.sentences.left!
            let lhsDescription = makeDescription(lhs)
            return "\(lhsDescription) \(self.`operator`.rawValue) \(rhsDescription)"
        } else {
            return "\(self.`operator`.rawValue)\(rhsDescription)"
        }
    }
    
    // MARK: Implement Sentence
    func isEqual(other: Sentence) -> Bool {
        guard let other = (other as? ComplexSentence) else {
            return false
        }
        let sameOperator = self.`operator` == other.`operator`
        let sameRight    = self.sentences.right == other.sentences.right
        if let leftSentence = self.sentences.left {
            if let otherLeftSentence = other.sentences.left {
                let sameLeft = leftSentence == otherLeftSentence
                return sameLeft && sameRight && sameOperator
            } else {
                return false
            }
        } else {
            return sameRight && sameOperator
        }
    }
    
    func applyModel(model: Model) -> Sentence {
        let newRhsSentence = self.sentences.right.applyModel(model)
        if self.isBinary {
            let newLhsSentence = self.sentences.left!.applyModel(model)
            return ComplexSentence(leftSentence: newLhsSentence,
                                   operator: self.`operator`,
                                   rightSentence: newRhsSentence)
        } else {
            return ComplexSentence(operator: self.`operator`, sentences: newRhsSentence)
        }
    }
    
    var isNegative: Bool {
        return !self.isPositive
    }
    
    var isPositive: Bool {
        switch self.`operator` {
        case .Negate:
            return !sentences.right.isPositive
        case .Conjoin:
            return sentences.left!.isPositive && sentences.right.isPositive
        case .Disjoin:
            return sentences.left!.isPositive || sentences.right.isPositive
        case .Implicate:
            // Implication elimination equivalence
            return !sentences.left!.isPositive || sentences.right.isPositive
        case .Biconditional:
            return  (sentences.left!.isPositive && sentences.right.isPositive) ||
                    (sentences.left!.isNegative && sentences.right.isNegative)
        }
    }
    
    var symbols: Set<PropositionalSymbol> {
        var set = Set<PropositionalSymbol>()
        let rhsSymbols = self.sentences.right.symbols
        set.unionInPlace(rhsSymbols)
        if let lhsSymbols = self.sentences.left?.symbols {
            set.unionInPlace(lhsSymbols)
        }
        return set
    }
    
    ///
    /// The logical operator that connects this sentence
    ///
    let `operator`: LogicalOperator
    
    ///
    /// The set of other sentences that comprise this sentence
    ///
    let sentences: (left: Sentence?, right: Sentence)
    
    ///
    /// Returns `true` iff the sentence has two sentences and is binary
    ///
    var isBinary: Bool {
        return self.`operator`.isBinary
    }
    
    ///
    /// Returns `true` iff the sentence has one sentence is and unary
    ///
    var isUnary: Bool {
        return self.`operator`.isUnary
    }
    
    ///
    /// Constructor for a set of sentences
    /// - Paramater operator: The operator of these sentences
    /// - Paramater sentences: The other sentences that make up this sentence
    ///
    init(`operator`: LogicalOperator, sentences: Sentence...) {
        // Check validity
        if sentences.isEmpty {
            fatalError("A complex sentence needs at least one sentence")
        } else if `operator`.isUnary && sentences.count != 1 {
            fatalError("Can only provide an unary operator to a sentence with one sentence")
        } else if `operator`.isBinary && sentences.count != 2 {
            fatalError("Can only provide a binary operator to two sentences only")
        } else if sentences.count > 2 {
            fatalError("Complex sentences only consist of two sentences")
        }
        self.`operator` = `operator`
        let isBinary = sentences.count == 2
        self.sentences.left  = isBinary ? sentences.first! : nil
        self.sentences.right = isBinary ?  sentences.last! : sentences.first!
    }
    
    ///
    /// Constructs a binary sentence
    /// - Paramater leftSentence: The sentence on the left-hand side of the operator
    /// - Paramater operator: The operator in between these two sentence
    /// - Paramater rightSentence: The sentence on the right-hand side of the operator
    ///
    init(leftSentence: Sentence, `operator`: LogicalOperator, rightSentence: Sentence) {
        // Construct using the other constructor
        self = ComplexSentence.init(operator: `operator`, sentences: leftSentence, rightSentence)
    }
    
    ///
    /// Returns `true` iff the `operator` specified is this part of this sentence
    ///
    func isSentenceKind(`operator`: LogicalOperator) -> Bool {
        return `operator` == self.`operator`
    }
}

// MARK: Implement Equatable
func ==(lhs: ComplexSentence, rhs: ComplexSentence) -> Bool {
    return lhs.isEqual(rhs)
}
