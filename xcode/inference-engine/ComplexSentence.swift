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
                    return "\(sen.connective)\(sen.sentences.right)"
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
            return "\(lhsDescription) \(self.connective.rawValue) \(rhsDescription)"
        } else {
            return "\(self.connective.rawValue)\(rhsDescription)"
        }
    }
    
    // MARK: Implement Sentence
    func isEqual(other: Sentence) -> Bool {
        guard let other = (other as? ComplexSentence) else {
            return false
        }
        let sameConnective = self.connective == other.connective
        let sameRight      = self.sentences.right == other.sentences.right
        if let leftSentence = self.sentences.left {
            if let otherLeftSentence = other.sentences.left {
                let sameLeft = leftSentence == otherLeftSentence
                return sameLeft && sameRight && sameConnective
            } else {
                return false
            }
        } else {
            return sameRight && sameConnective
        }
    }
    
    func isSentenceKind(connective: Connective) -> Bool {
        return connective == self.connective
    }
    
    func applyModel(model: Model) -> Sentence {
        let newRhsSentence = self.sentences.right.applyModel(model)
        if self.isBinary {
            let newLhsSentence = self.sentences.left!.applyModel(model)
            return ComplexSentence(leftSentence: newLhsSentence,
                                   connective: self.connective,
                                   rightSentence: newRhsSentence)
        } else {
            return ComplexSentence(connective: self.connective, sentences: newRhsSentence)
        }
    }
    
    var isNegative: Bool {
        return !self.isPositive
    }
    
    var isPositive: Bool {
        switch self.connective {
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
    
    
    var inNegationNormalForm: Sentence {
        var result: Sentence = self
        // Convert P  => Q to ~P & Q
        if result.isSentenceKind(.Implicate) {
            let lhs = sentences.left!.inNegationNormalForm
            let rhs = sentences.right.inNegationNormalForm
            result = ~lhs & rhs
        }
        // Convert P <=> Q to (P | ~Q) & (~P & Q)
        else if result.isSentenceKind(.Biconditional) {
            let lhs = sentences.left!.inNegationNormalForm
            let rhs = sentences.right.inNegationNormalForm
            result = (lhs | ~rhs) & (~lhs & rhs)
        }
        // Apply DeMorgan's Law to ~(A) to move .Negate inwards
        if result.isSentenceKind(.Negate) {
            let resultAsComplex = (result as! ComplexSentence)
            // Assume A is not atomic, else result is assigned
            if let negated = resultAsComplex.sentences.right as? ComplexSentence {
                // A == (~P)
                let rhsIsNegated =
                    negated.isSentenceKind(.Negate)
                // A == (P & Q) or (P | Q)
                let rhsIsConjoinOrDisjoin =
                    negated.isSentenceKind(.Conjoin) ||
                    negated.isSentenceKind(.Disjoin)
                // ~A = ~(~P) = P
                if rhsIsNegated {
                    // Hence result is just P
                    result = (negated.sentences.right).inNegationNormalForm
                }
                // ~(P & Q) or ~(P | Q)
                else if rhsIsConjoinOrDisjoin {
                    // Convert P & Q in NNF and support double negation (hence why
                    // we negate at the start)
                    let lhs = (~(negated.sentences.left!)).inNegationNormalForm
                    let rhs = (~(negated.sentences.right)).inNegationNormalForm
                    if negated.isSentenceKind(.Conjoin) {
                        // ~(P & Q) == ~P | ~Q
                        result = lhs | rhs
                    } else {
                        // ~(P | Q) == ~P & ~Q
                        result = lhs & rhs
                    }
                }
            } else {
                // Else cannot perform any changes
                result = resultAsComplex
            }
        }
        return result
    }
    
    var inConjunctiveNormalForm: Sentence {
        // First convert to NNF
        var result = self.inNegationNormalForm
        // (P | (Q & R)) == (P | Q) & (P & R)
        if result.isSentenceKind(.Disjoin) {
            let lhs = ((result as! ComplexSentence).sentences.left!).inConjunctiveNormalForm
            let rhs = ((result as! ComplexSentence).sentences.right).inConjunctiveNormalForm
            // Either side is an Conjoin
            if lhs.isSentenceKind(.Conjoin) || rhs.isSentenceKind(.Conjoin) {
                // if rhs is conjoin then P | (Q & R) == p  | qr
                // if lhs is conjoin then (Q & R) | P == qr | p
                let p  =  rhs.isSentenceKind(.Conjoin) ? lhs : rhs
                let qr = (rhs.isSentenceKind(.Conjoin) ? rhs : lhs) as! ComplexSentence
                let q  = qr.sentences.left!
                let r  = qr.sentences.right
                
                // (p | q) & (p | r)
                if rhs.isSentenceKind(.Conjoin) {
                    result =
                        (p | q).inConjunctiveNormalForm &
                        (p | r).inConjunctiveNormalForm
                // (q | p) & (r | p)
                } else {
                    result =
                        (q | p).inConjunctiveNormalForm &
                        (r | p).inConjunctiveNormalForm
                }
            } else {
                result = lhs.inConjunctiveNormalForm | rhs.inConjunctiveNormalForm
            }
        }
        return result
    }

    func split(connective: Connective) -> [Sentence] {
        if self.isSentenceKind(connective) {
            let lhs = self.sentences.left!
            let rhs = self.sentences.right
            let lhsSplit = lhs.split(connective)
            let rhsSplit = rhs.split(connective)
            return [lhsSplit, rhsSplit].flatMap({$0})
        } else {
            // Doesn't have the connective, so return the sentence
            return [self]
        }
    }
    
    ///
    /// The logical connective that connects this sentence
    ///
    let connective: Connective
    
    ///
    /// The set of other sentences that comprise this sentence
    ///
    let sentences: (left: Sentence?, right: Sentence)
    
    ///
    /// Returns `true` iff the sentence has two sentences and is binary
    ///
    var isBinary: Bool {
        return self.connective.isBinary
    }
    
    ///
    /// Returns `true` iff the sentence has one sentence is and unary
    ///
    var isUnary: Bool {
        return self.connective.isUnary
    }
    
    ///
    /// Constructor for a set of sentences
    /// - Paramater connective: The connective of these sentences
    /// - Paramater sentences: The other sentences that make up this sentence
    ///
    init(connective: Connective, sentences: Sentence...) {
        // Check validity
        if sentences.isEmpty {
            fatalError("A complex sentence needs at least one sentence")
        } else if connective.isUnary && sentences.count != 1 {
            fatalError("Can only provide an unary connective to a sentence with one sentence")
        } else if connective.isBinary && sentences.count != 2 {
            fatalError("Can only provide a binary connective to two sentences only")
        } else if sentences.count > 2 {
            fatalError("Complex sentences only consist of two sentences")
        }
        self.connective = connective
        let isBinary = sentences.count == 2
        self.sentences.left  = isBinary ? sentences.first! : nil
        self.sentences.right = isBinary ?  sentences.last! : sentences.first!
    }
    
    ///
    /// Constructs a binary sentence
    /// - Paramater leftSentence: The sentence on the left-hand side of the connective
    /// - Paramater connective: The connective in between these two sentence
    /// - Paramater rightSentence: The sentence on the right-hand side of the connective
    ///
    init(leftSentence: Sentence, connective: Connective, rightSentence: Sentence) {
        // Construct using the other constructor
        self = ComplexSentence.init(connective: connective, sentences: leftSentence, rightSentence)
    }
    
    ///
    /// Returns the count of the connective provided in the complex sentence
    /// - Paramater connective: The connective to get count of
    ///
    func countOfConnective(connective: Connective) -> Int {
        var count = 0
        
        if self.isSentenceKind(connective) {
            count += 1
        }
        if let lhs = sentences.left as? ComplexSentence {
            count += lhs.countOfConnective(connective)
        }
        if let rhs = sentences.right as? ComplexSentence {
            count += rhs.countOfConnective(connective)
        }
        
        return count
    }
    
    ///
    /// Returns `true` iff the premise is contained in this complex sentence
    ///
    func containsPremise(premise: AtomicSentence) -> Bool {
        // Only applicable to implication sentences
        if !self.isSentenceKind(.Implicate) {
            return false
        }
        return sentences.left!.symbols.contains(premise.atom)
    }
    
    ///
    /// Returns `true` iff the conclusion is contained in this complex sentence
    ///
    func containsConclusion(conclusion: AtomicSentence) -> Bool {
        // Only applicable to implication sentences
        if !self.isSentenceKind(.Implicate) {
            return false
        }
        return sentences.right.symbols.contains(conclusion.atom)
    }
}

// MARK: Implement Equatable
func ==(lhs: ComplexSentence, rhs: ComplexSentence) -> Bool {
    return lhs.isEqual(rhs)
}
