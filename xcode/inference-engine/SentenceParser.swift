//
//  Tokeniser.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Expressional is a private protocol representing anything which can
/// be expressed in parsing, that is, a `PropositionalSymbol` and a
/// `LogicalOperator`, as well as `Parentheses`s
///
private protocol Expressionable: CustomStringConvertible {}
extension PropositionalSymbol   : Expressionable {}
extension LogicalOperator       : Expressionable {
    ///
    /// Provide an isOperator function for expressionable value types
    ///
    private static func isOperator(expression: Expressionable) -> Bool {
        return LogicalOperator.isOperator(expression.description)
    }
}

///
/// Private enum for parsing-purposes only
///
private enum Parenthesis: String, Expressionable {
    case Left  = "("
    case Right = ")"
    // MARK: Implement CustomStringConvertible
    var description: String {
        return self.rawValue
    }
}

///
/// Strings can be called `Tokens` when parsing
///
private typealias Token = String

///
/// A sentence parser
///
struct SentenceParser {
    ///
    /// Parser errors when parsing a sentence
    ///
    enum ParserError: ErrorType {
        case UnknownOperator
        case UnknownToken
        case InvalidSyntax
        case NeedOneSymbol
        case MismatchedParentheses
    }

    ///
    /// Singleton shared instance of the parser
    ///
    static let sharedParser = SentenceParser()
   
    ///
    /// The characters which are parsable by the parser
    ///
    static private let parserCharacters:
        (alpha: [Character], numeric: [Character], operators: [Character]) = (
        alpha: (97...97+25).map({ Character(UnicodeScalar($0)) }),
        numeric: (0...9).map { Character(String($0)) },
        operators: Array(Set(LogicalOperator.all.map({$0.rawValue.characters}).flatMap({$0})))
    )
    
    ///
    /// Returns `true` iff the token specified is an symbolic character
    ///
    private func isSymbol(token: Token) -> Bool {
        guard let char = token.characters.first else {
            return false
        }
        return  SentenceParser.parserCharacters.alpha.contains(char) ||
                SentenceParser.parserCharacters.numeric.contains(char)
    }
    
    ///
    /// Returns `true` iff the token specified is a logical operator character
    ///
    private func isOperator(token: Token) -> Bool {
        guard let char = token.characters.first else {
            return false
        }
        return SentenceParser.parserCharacters.operators.contains(char)
            // not a operator iteself... parsing part of a token!
            && !LogicalOperator.isOperator(char)
    }
    
    ///
    /// Parse a specific token until the `checkFunc` returns true
    /// - Paramater remaindingChars: The remainding characters left to parse
    /// - Paramater token: The token to parse
    /// - Paramater checkFunc: The function that keeps parsing until the
    ///                        the function returns `true`
    ///
    private func parseToken(inout remaindingChars: String.CharacterView, token: Token, until checkFunc: (Token) -> Bool) -> Token {
        // Keep peeking at the next characters thereafter; until our
        // check function is true
        var token = token
        while let nextChar = remaindingChars.first {
            if checkFunc(Token(nextChar)) {
                token += Token(remaindingChars.removeFirst())
            } else {
                return token
            }
        }
        return token
    }
    
    ///
    /// Returns the top of the stack as a `LogicalOperator` if possible, else
    /// returns `nil`
    ///
    private func topAsOperator(stack: Stack<Expressionable>) -> LogicalOperator? {
        if stack.isEmpty {
            return nil
        } else {
            let topOfStack = stack.top()!
            // Is the top of the stack an operator?
            if LogicalOperator.isOperator(topOfStack) {
                return topOfStack as? LogicalOperator
            } else {
                return nil
            }
        }
    }
    
    ///
    /// Returns the top of the stack as a `LogicalOperator` if possible, else
    /// returns `nil`
    ///
    private func topAsParenthesis(stack: Stack<Expressionable>) -> Parenthesis? {
        if stack.isEmpty {
            return nil
        } else {
            let topOfStack = stack.top()!
            // Is the top of the stack an operator?
            if let paren = Parenthesis.init(rawValue: topOfStack.description) {
                return paren
            } else {
                return nil
            }
        }
    }
    
    ///
    /// Tries to form a sentence with the stacks provided
    /// - Paramater symbols: The symbols parsed
    /// - Paramater operators: The operators parsed
    ///
    private func formSentence(symbols: [PropositionalSymbol], operators: [LogicalOperator]) throws -> Sentence {
        var symbols   = Array(symbols.reverse())
        var operators = Array(operators.reverse())
        if symbols.isEmpty {
            throw ParserError.NeedOneSymbol
        }
        var sentence: Sentence = AtomicSentence(symbols.popLast()!)
        while !symbols.isEmpty {
            let next = (
                symbol: symbols.popLast()!,
                oper:   operators.popLast()
            )
            // Unwrap the next operator
            if let oper = next.oper {
                // If operator is binary, then we apply the operator and pop the
                // next symbol to apply it to the sentence
                // (i.e., P & Q)
                if oper.isBinary {
                    // Can't pop?
                    // (i.e., P &)
                    let rhsEl = AtomicSentence(next.symbol)
                    sentence = ComplexSentence(leftSentence: sentence,
                                               operator: oper,
                                               rightSentence: rhsEl)
                } else {
                    // Unary operator? Expect next symbol to be .Negate
                    if oper != .Negate {
                        throw ParserError.InvalidSyntax
                    } else {
                        sentence = !sentence
                    }
                }
            } else if !symbols.isEmpty && operators.isEmpty {
                // Still have more symbols and no more operators?
                // (i.e., P Q R)
                throw ParserError.InvalidSyntax
            }

        }
        return sentence
    }

    
    ///
    /// Parses a sentence from a string expression
    /// - Remarks: Computed using the Shunting Yard algorithm
    /// - Parameter expression: The expression to parse
    /// - Throws: A `SentenceParser.ParserError` if could not be parsed
    /// - Returns: A new sentence parsed from the expression
    ///
    func parse(expression: String) throws -> String {
        // Remove all whitespace from expression
        let expression = String(expression.lowercaseString.characters.filter({$0 != " "}))

        // Stacks
        var stack  = Stack<Expressionable>()
        var output = Queue<Expressionable>()
        
        // Decompose the string and parse operators
        var tokens = expression.characters
        
        // Parse every token
        while !tokens.isEmpty {
            let nextToken = Token(tokens.removeFirst())
            // If this token is a symbol add it to the output queue
            if isSymbol(nextToken) {
                let symbol = parseToken(&tokens, token: nextToken, until: isSymbol)
                output.enqueue(PropositionalSymbol(symbol: symbol))
            }
            // Is the token an operator?
            else if isOperator(nextToken) || LogicalOperator.isOperator(nextToken) {
                // Form a token from this
                let oper = parseToken(&tokens, token: nextToken, until: isOperator)
                if let oper = LogicalOperator(rawValue: oper) {
                    // While there is a operator on the top of the stack and it
                    // has a lower precedence than oper?
                    while let topOfStack = topAsOperator(stack) where oper > topOfStack {
                        output.enqueue(stack.pop())
                    }
                    stack.push(oper)
                } else {
                    throw ParserError.UnknownOperator
                }
            }
            // Handle parentheses
            else if let paren = Parenthesis(rawValue: nextToken) {
                if paren == .Left {
                    stack.push(Parenthesis.Left)
                } else {
                    // Until the token at the top of the stack is a left parenthesis
                    while !stack.isEmpty && stack.top()!.description != Parenthesis.Left.rawValue {
                        // pop operators off the stack onto the output queue
                        output.enqueue(stack.pop())
                    }
                    // If the stack runs out, mismatch in parens
                    if stack.isEmpty {
                        throw ParserError.MismatchedParentheses
                    }
                    
                    // Pop the left parenthesis from the stack, but not onto the output queue.
                    stack.pop()
                }
            }
            else {
                throw ParserError.UnknownToken
            }
        }
        
        // While there are still operator tokens in the stack:
        while let topOfStack = stack.top() where LogicalOperator.isOperator(topOfStack) {
            output.enqueue(stack.pop())
        }
        
        // Expect the stack to be empty
        if !stack.isEmpty {
            throw ParserError.MismatchedParentheses
        }
        
        return output.elements.description
    }
}