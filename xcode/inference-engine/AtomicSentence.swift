//
//  AtomicSentence.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A truthy atomic sentence (a positive literal) or a negated
/// atomic sentence (a negative literal).
///
struct AtomicSentence: Sentence {
    // MARK: Implement Custom[Debug]StringConvertible
    var description: String {
        return self.atom.symbol
    }
    var debugDescription: String {
        return self.description
    }

    // MARK: Implement Sentence
    let isPositive: Bool
    var isNegative: Bool {
        return !isPositive
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
}

