//
//  LogicalOperators.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

enum LogicalOperator: String, CustomStringConvertible, Comparable {
    // MARK: Implement CustomStringConvertible
    var description: String {
        return self.rawValue
    }
    
    ///
    /// Associativity of a Logical Operator
    ///
    enum Associativity {
        case Left, Right
    }
    ///
    /// A conjoin operator, representing a logical AND
    ///
    case Conjoin = "&"
    
    ///
    /// A disjoin operator, representing a logical OR
    ///
    case Disjoin = "|"
    
    ///
    /// A negate operator, representing a logical NOT
    ///
    case Negate = "!"
    
    ///
    /// A implication operator, represetning a logical implication
    ///
    case Implicate = "=>"
    
    ///
    /// A biconditional operator, representing if and only if (`iff`)
    ///
    case Biconditional = "<=>"
    
    ///
    /// Checks if the string provided represents a case of a `LogicalOperator`
    /// - Returns: `true` iff `string` is a `LogicalOperator`
    ///
    static func isOperator(string: String) -> Bool {
        return LogicalOperator(rawValue: string) != nil
    }
    
    ///
    /// Checks if the character provided represents a case of a `LogicalOperator`
    /// - Returns: `true` iff `char` is a `LogicalOperator`
    ///
    static func isOperator(char: Character) -> Bool {
        return self.isOperator(String(char))
    }
    
    ///
    /// Returns all logical operators sorted by their `precedence` value
    ///
    static var all: [LogicalOperator] {
        return [
            LogicalOperator.Biconditional,
            LogicalOperator.Implicate,
            LogicalOperator.Conjoin,
            LogicalOperator.Disjoin,
            LogicalOperator.Negate
        ].sort({$0.precedence < $1.precedence})
    }
    
    ///
    /// Returns the precedence of this operator
    /// - Remarks: See [Order Of Precdence](https://en.wikipedia.org/wiki/Logical_connective#Order_of_precedence)
    ///
    var precedence: Int {
        return [
            LogicalOperator.Negate:         1,
            LogicalOperator.Conjoin:        2,
            LogicalOperator.Disjoin:        3,
            LogicalOperator.Implicate:      4,
            LogicalOperator.Biconditional:  5
        ][self]!
    }
    
    ///
    /// Associativity of the operator
    ///
    var associativity: Associativity {
        return self == .Negate ? .Right : .Left
    }
    
    ///
    /// Returns `true` iff the operator is an unary operator (i.e., is `Negate`)
    ///
    var isUnary: Bool {
        // Only prefix is a negate operator
        return self == .Negate
    }
    
    ///
    /// Returns `true` iff the operator is a binary operator (i.e., is not `Negate`)
    ///
    var isBinary: Bool {
        return !self.isUnary
    }
}

// MARK: Implement Comparable
func <(lhs: LogicalOperator, rhs: LogicalOperator) -> Bool {
    return (lhs.associativity == .Left && lhs.precedence == rhs.precedence) ||
            lhs.precedence < rhs.precedence
}