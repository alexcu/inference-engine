////
////  TruthTable.swift
////  inference-engine
////
////  Created by Alex on 25/04/2016.
////  Copyright © 2016 Alex. All rights reserved.
////
//
//enum TokeniserParserError: ErrorType {
//    case UnknownOperator
//    case UnknownToken
//}
//
//func tokenise(expression: String) throws -> (operators: [LogicalOperator], symbols: [Symbol]){
//    typealias Token = String
//    
//    // Remove all whitespace from expression
//    let expression = String(expression.lowercaseString.characters.filter({$0 != " "}))
//    
//    var stacks = (
//        operators: [LogicalOperator](),
//        symbols:   [Symbol]()
//    )
//    
//    let characters: (alpha: [Character], numeric: [Character], operators: [Character])  = (
//        alpha: (97...97+25).map({ Character(UnicodeScalar($0)) }),
//        numeric: (0...9).map { Character(String($0)) },
//        operators: Array(Set(LogicalOperator.all.map({$0.rawValue.characters}).flatMap({$0})))
//    )
//    
//    // Decompose the string and parse operators
//    var chars = expression.characters
//    
//    func isSymbol(char: Character) -> Bool {
//        return characters.alpha.contains(char) || characters.numeric.contains(char)
//    }
//    func isOperator(char: Character) -> Bool {
//        return characters.operators.contains(char) && !LogicalOperator.isOperator(char)
//    }
//    func parseToken(token: Character, until checkFunc: (Character) -> Bool) -> Token {
//        // Keep peeking at the next characters thereafter; until we don't
//        // get an alpha or numerical char (i.e., not a symbol)
//        var token = Token(token)
//        while let nextChar = chars.first {
//            if checkFunc(nextChar) {
//                token += Token(chars.removeFirst())
//            } else {
//                return token
//            }
//        }
//        return token
//    }
//    
//    while !chars.isEmpty {
//        let nextChar = chars.removeFirst()
//        // This is an alpha char?
//        if isSymbol(nextChar) {
//            let symbol = parseToken(nextChar, until: isSymbol)
//            // Keep peeking at the next characters thereafter; until we don't
//            // get an alpha or numerical char (i.e., not a symbol)
//            stacks.symbols.append(symbol)
//        } else if isOperator(nextChar) || LogicalOperator.isOperator(nextChar) {
//            let oper = parseToken(nextChar, until: isOperator)
//            if let oper = LogicalOperator(rawValue: oper) {
//                stacks.operators.append(oper)
//            } else {
//                throw TokeniserParserError.UnknownOperator
//            }
//        } else {
//            throw TokeniserParserError.UnknownToken
//        }
//    }
//    
//    return stacks
//}