//
//  PropositionalSymbol.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A symbol which stands for a proposition that can `true` or `false`.
///
struct PropositionalSymbol: Hashable, CustomStringConvertible, Equatable {
    // MARK: CustomStringConvertible
    var description: String {
        return self.symbol
    }
    
    // MARK: Hashable
    var hashValue: Int {
        return self.symbol.hashValue
    }
    
    ///
    /// A true propsitional symbol that is *always* represented as `true`
    ///
    static let True = PropositionalSymbol(symbol: true)
    
    ///
    /// A true propsitional symbol that is *always* represented as `false`
    ///
    static let False = PropositionalSymbol(symbol: false)
    
    ///
    /// Returns true if the atom is a `true` literal
    ///
    var isTrue: Bool {
        return self == PropositionalSymbol.True
    }
    
    ///
    /// Returns true if the atom is a `false` literal
    ///
    var isFalse: Bool {
        return self == PropositionalSymbol.False
    }
    
    ///
    /// Underlying textual representation of the symbol
    ///
    let symbol: String
    
    ///
    /// Initialises a new symbol with the given textual representation
    ///
    init(symbol: String) {
        self.symbol = symbol
        if [PropositionalSymbol.True.symbol,
            PropositionalSymbol.False.symbol].contains(self.symbol) {
            fatalError("Cannot construct symbols with true or false. Use the singletons instead")
        }
    }
    
    ///
    /// Private initialiser for boolean propositional symbols
    ///
    private init(symbol: Bool) {
       self.symbol = symbol.description
    }
}

// MARK: Implement equatable
func ==(lhs: PropositionalSymbol, rhs: PropositionalSymbol) -> Bool {
    return lhs.symbol == rhs.symbol
}
