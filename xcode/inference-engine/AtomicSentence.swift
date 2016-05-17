//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           26/04/2016
//

///
/// A truthy atomic sentence (a positive literal) or a negated
/// atomic sentence (a negative literal).
///
struct AtomicSentence: Sentence, Equatable {
    // MARK: Implement Custom[Debug]StringConvertible
    var description: String {
        return self.atom.symbol
    }
    
    // MARK: Implement Sentence
    let isPositive: Bool
    var isNegative: Bool {
        return !isPositive
    }
    
    func isEqual(other: Sentence) -> Bool {
        guard let other = (other as? AtomicSentence) else {
            return false
        }
        return self.atom.symbol == other.atom.symbol && (self.isPositive == other.isPositive)
    }
    
    func applyModel(model: Model) -> Sentence {
        // Truth exists in this model for this atom?
        if let truth = model[self.atom] {
            // Return a new atomic sentence with this atom with the truth found
            return AtomicSentence(self.atom, truth)
        } else {
            return self
        }
    }
    
    var symbols: Set<PropositionalSymbol> {
        return Set(arrayLiteral: self.atom)
    }
    
    var inConjunctiveNormalForm: Sentence {
        // Atomic in CNF is just itself
        return self
    }
    
    var inNegationNormalForm: Sentence {
        // Atomic in NNF is just itself
        return self
    }
    
    var withoutImplications: Sentence {
        // Atomic is just itself
        return self
    }
    
    func isSentenceKind(connective: Connective) -> Bool {
        // It has no connectives! So it can't be that kind of sentence
        return false
    }

    func split(connective: Connective) -> [Sentence] {
        // Cannot split an atomic sentence
        return [self]
    }
    
    ///
    /// The underlying Propositional Symbol is an atom.
    ///
    let atom: PropositionalSymbol
    
    ///
    /// Initialiser for a literal
    /// - Parameter atom: The atomic sentence comprising the literal
    /// - Paramater isPositive: The truth of the symbol; defaults to `true`
    /// - Remarks: if atom is `true` or `false` literals, then `isPositive`
    ///            is ignored
    ///
    init(_ atom: PropositionalSymbol, _ isPositive: Bool = true) {
        self.atom = atom
        // if the atom is `true` or `false`, we need to override the value
        // of isPositive here
        self.isPositive = atom.isTrue || (!atom.isFalse && isPositive)
    }
    
    ///
    /// Initialiser for a literal, using a string constructor
    /// - Parameter atom: The atomic sentence comprising the literal
    /// - Paramater isPositive: The truth of the symbol; defaults to `true`
    ///
    init(_ atom: String, _ isPositive: Bool = true) {
        self.atom = PropositionalSymbol(symbol: atom)
        self.isPositive = isPositive
    }
    
    ///
    /// A false atomic sentence representing `FALSE` primitive
    ///
    static let FalseAtomicSentence = AtomicSentence(PropositionalSymbol.False)
    
    ///
    /// A true atomic sentence representing `TRUE` primitive
    ///
    static let TrueAtomicSentence = AtomicSentence(PropositionalSymbol.True)
    
    ///
    /// Returns `true` iff the sentence is the False atomic sentence
    ///
    var isFalseAtom: Bool {
        return self == AtomicSentence.FalseAtomicSentence
    }
    
    ///
    /// Returns `true` iff the sentence is the True atomic sentence
    ///
    var isTrueAtom: Bool {
        return self == AtomicSentence.TrueAtomicSentence
    }
}

// MARK: Implement Equatable
func ==(lhs: AtomicSentence, rhs: AtomicSentence) -> Bool {
    return lhs.isEqual(rhs)
}