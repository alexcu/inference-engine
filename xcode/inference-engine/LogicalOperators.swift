//
//  LogicalOperators.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

enum LogicalOperator: String {
    case Conjoin        = "&"
    case Disjoin        = "|"
    case Negate         = "!"
    case Implicate      = "=>"
    case Biconditional  = "<=>"
    
    static func isOperator(string: String) -> Bool {
        return LogicalOperator(rawValue: string) != nil
    }
    
    static func isOperator(char: Character) -> Bool {
        return self.isOperator(String(char))
    }
    
    static var all: [LogicalOperator] {
        return [
            LogicalOperator.Biconditional,
            LogicalOperator.Implicate,
            LogicalOperator.Conjoin,
            LogicalOperator.Disjoin,
            LogicalOperator.Negate
        ].sort({$0.precedence < $1.precedence})
    }
    
    var precedence: Int {
        // See https://en.wikipedia.org/wiki/Logical_connective#Order_of_precedence
        return [
            LogicalOperator.Negate:         1,
            LogicalOperator.Conjoin:        2,
            LogicalOperator.Disjoin:        3,
            LogicalOperator.Implicate:      4,
            LogicalOperator.Biconditional:  5
        ][self]!
    }
    
    var isPrefix: Bool {
        // Only prefix is a negate operator
        return self == .Negate
    }
}
