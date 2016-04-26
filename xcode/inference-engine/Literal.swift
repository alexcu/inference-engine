//
//  Literal.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A literal is either an atomic sentence (a positive literal) or a negated
/// atomic sentence (a negative literal).
///
struct Literal {
    ///
    /// The underlying Propositional Symbol is an atom.
    ///
    let atom: PropositionalSymbol
    
    ///
    /// Truth of the literal.
    ///
    let isPositive: Bool
    
    ///
    /// False of the literal.
    ///
    var isNegative: Bool {
        return !isPositive
    }
    
    ///
    /// Initialiser for a literal
    /// - Parameter atom: The atomic sentence comprising the literal
    /// - Paramater isPositive: The truth of the symbol; defaults to `true`
    /// - Remarks: if atom is `true` or `false` literals, then `isPositive`
    ///            is ignored
    ///
    init(atom: PropositionalSymbol, isPositive: Bool = true) {
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
    init(atom: String, isPositive: Bool = true) {
        self.atom = PropositionalSymbol(symbol: atom)
        self.isPositive = isPositive
    }
}
