//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           20/04/2016
//

// Represents logical negation (NOT)
infix operator ~ { precedence 1 }
prefix func ~(lhs: Sentence) -> ComplexSentence {
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
/// complex sentence, consisting of connectives and other sentences, or a 
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
    ///
    /// Returns the CNF representation of this sentence
    ///
    var inConjunctiveNormalForm: Sentence { get }
    ///
    /// Returns the NNF representation of this sentence
    ///
    var inNegationNormalForm: Sentence { get }
    ///
    /// Returns the sentence without any implications or biconditionals
    ///
    var withoutImplications: Sentence { get }
    ///
    /// Returns `true` iff the connective specified is this part of this sentence
    ///
    func isSentenceKind(connective: Connective) -> Bool
    ///
    /// Splits the sentence using the specified connective
    /// - Paramater connective: The connective to which to split the sentence on
    ///
    func split(connective: Connective) -> [Sentence]
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
        return ~self | other
    }

    func disjoinWith(other: Sentence) -> ComplexSentence {
        return ComplexSentence(leftSentence: other,
                               connective: .Disjoin,
                               rightSentence: self)
    }

    func conjunctWith(other: Sentence) -> ComplexSentence {
        return ComplexSentence(leftSentence: other,
                               connective: .Conjoin,
                               rightSentence: self)
    }

    func negate() -> ComplexSentence {
        return ComplexSentence(connective: .Negate, sentences: self)
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

// MARK: Extension to Array for Sentences
extension _ArrayType where Generator.Element == Sentence {    
    ///
    /// Joins an array of Sentences using the connective provided
    ///
    func join(connective: Connective) -> Sentence {
        if self.count == 1 {
            return self.first!
        } else if self.count == 0 {
            // Return the joined connective based off the specified operator
            // & -> TRUE, | -> FALSE
            switch connective {
            case .Conjoin:
                return AtomicSentence.TrueAtomicSentence
            case .Disjoin:
                return AtomicSentence.FalseAtomicSentence
            default:
                fatalError("Cannot join with no arguments using the \(connective) connective")
            }
        }
        var selff = self
        var result = selff.removeFirst()
        while !selff.isEmpty {
            let next = selff.removeFirst()
            result = ComplexSentence(leftSentence: result,
                                     connective: connective,
                                     rightSentence: next)
        }
        return result
    }
    
    ///
    /// Returns the elements of this array not in the other array
    ///
    func difference(other: Self) -> [Self.Generator.Element] {
        return other.filter({ sentence in
            !self.contains({sentence == $0})
        })
    }
    
    ///
    /// Unions the array with the other array, returning a new array
    ///
    func union(other: Self) -> Self {
        var selff = self
        selff.appendContentsOf(selff.difference(other))
        return selff
    }
}