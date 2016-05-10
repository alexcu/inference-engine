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
/// `Connective`, as well as `Parentheses`s
///
private protocol Expressionable: CustomStringConvertible {}
extension PropositionalSymbol   : Expressionable {}
extension Connective       : Expressionable {
    ///
    /// Provide an isConnective function for expressionable value types
    ///
    private static func isConnective(expression: Expressionable) -> Bool {
        return Connective.isConnective(expression.description)
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
        case UnknownConnective
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
        (alpha: [Character], numeric: [Character], connectives: [Character]) = (
        alpha: (97...97+25).map({ Character(UnicodeScalar($0)) }),
        numeric: (0...9).map { Character(String($0)) },
        connectives: Array(Set(Connective.all.map({$0.rawValue.characters}).flatMap({$0})))
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
    /// Returns `true` iff the token specified is a logical connective character
    ///
    private func isConnective(token: Token) -> Bool {
        guard let char = token.characters.first else {
            return false
        }
        return SentenceParser.parserCharacters.connectives.contains(char)
            // not a connective iteself... parsing part of a token!
            && !Connective.isConnective(char)
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
    /// Returns the top of the stack as a `Connective` if possible, else
    /// returns `nil`
    ///
    private func topAsConnective(stack: Stack<Expressionable>) -> Connective? {
    if let topOfStack = stack.top {
            // Is the top of the stack an connective?
            if Connective.isConnective(topOfStack) {
                return topOfStack as? Connective
            }
        }
        return nil
    }

    ///
    /// Tries to form a sentence with the stacks provided
    /// - Paramater symbols: The symbols parsed
    /// - Paramater connectives: The connectives parsed
    ///
    private func formSentence(queue: Queue<Expressionable>) throws -> Sentence {
        var queue = queue
        var sentenceStack = Stack<Sentence>()
        if queue.isEmpty {
            throw ParserError.NeedOneSymbol
        }
        if !(queue.first is PropositionalSymbol) {
            fatalError("Cannot have connective at start... something went wrong")
        }
        while !queue.isEmpty {
            let next = queue.dequeue()
            // Unwrap the next propoisitonal symbol
            if let symbol = next as? PropositionalSymbol {
                sentenceStack.push(AtomicSentence(symbol))
            }
            // Unwrap the next connective
            else if let oper = next as? Connective {
                // If connective is binary, then we apply the connective and pop the
                // next symbol to apply it to the sentence
                // (i.e., P & Q)
                if oper.isBinary {
                    // Can't pop?
                    // (i.e., P &)
                    let rhsSentence = sentenceStack.pop()
                    let lhsSentence = sentenceStack.pop()
                    let complexSentence = ComplexSentence(leftSentence: lhsSentence,
                                                          connective: oper,
                                                          rightSentence: rhsSentence)
                    sentenceStack.push(complexSentence)
                } else {
                    // Unary connective? Expect next symbol to be .Negate
                    if oper != .Negate {
                        throw ParserError.InvalidSyntax
                    } else {
                        sentenceStack.push(~sentenceStack.pop())
                    }
                }
            } else if !(queue.isEmpty) || sentenceStack.elements.count != 1 {
                // Still have more symbols and no more connectives?
                // (i.e., P Q R)
                throw ParserError.InvalidSyntax
            }

        }
        return sentenceStack.pop()
    }

    
    ///
    /// Parses a sentence from a string expression
    /// - Remarks: Computed using the Shunting Yard algorithm
    /// - Parameter expression: The expression to parse
    /// - Throws: A `SentenceParser.ParserError` if could not be parsed
    /// - Returns: A new sentence parsed from the expression
    ///
    func parse(expression: String) throws -> Sentence {
        // Remove all whitespace from expression
        let expression = String(expression.lowercaseString.characters.filter({$0 != " "}))

        // Stacks
        var stack  = Stack<Expressionable>()
        var output = Queue<Expressionable>()
        
        // Decompose the string and parse connectives
        var tokens = expression.characters
        
        // Parse every token
        while !tokens.isEmpty {
            let nextToken = Token(tokens.removeFirst())
            // If this token is a symbol add it to the output queue
            if isSymbol(nextToken) {
                let symbol = parseToken(&tokens, token: nextToken, until: isSymbol)
                output.enqueue(PropositionalSymbol(symbol: symbol))
            }
            // Is the token an connective?
            else if isConnective(nextToken) || Connective.isConnective(nextToken) {
                // Form a token from this
                let oper = parseToken(&tokens, token: nextToken, until: isConnective)
                if let oper = Connective(rawValue: oper) {
                    // While there is a connective on the top of the stack and it
                    // has a lower precedence than oper?
                    while let topOfStack = topAsConnective(stack) where oper > topOfStack {
                        output.enqueue(stack.pop())
                    }
                    stack.push(oper)
                } else {
                    throw ParserError.UnknownConnective
                }
            }
            // Handle parentheses
            else if let paren = Parenthesis(rawValue: nextToken) {
                if paren == .Left {
                    stack.push(Parenthesis.Left)
                } else {
                    // Until the token at the top of the stack is a left parenthesis
                    while !stack.isEmpty && stack.top!.description != Parenthesis.Left.rawValue {
                        // pop connectives off the stack onto the output queue
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
        
        // While there are still connective tokens in the stack:
        while let topOfStack = stack.top where Connective.isConnective(topOfStack) {
            output.enqueue(stack.pop())
        }
        
        // Expect the stack to be empty
        if !stack.isEmpty {
            throw ParserError.MismatchedParentheses
        }
        
        return try formSentence(output)
    }
}