//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           25/04/2016
//

enum Connective: String, CustomStringConvertible, Comparable {
    // MARK: Implement CustomStringConvertible
    var description: String {
        return self.rawValue
    }
    
    ///
    /// Associativity of a Logical Connective
    ///
    enum Associativity {
        case Left, Right
    }
    ///
    /// A conjoin connective, representing a logical AND
    ///
    case Conjoin = "&"
    
    ///
    /// A disjoin connective, representing a logical OR
    ///
    case Disjoin = "|"
    
    ///
    /// A negate connective, representing a logical NOT
    ///
    case Negate = "~"
    
    ///
    /// A implication connective, represetning a logical implication
    ///
    case Implicate = "=>"
    
    ///
    /// A biconditional connective, representing if and only if (`iff`)
    ///
    case Biconditional = "<=>"
    
    ///
    /// Returns the characters that are acceptable for connectives
    ///
    static let characters: Set<Character> = {
        var chars = Connective.all.map({$0.rawValue.characters})
                                  .flatMap({$0})
        chars.appendContentsOf(["\\", "/"])
        return Set(chars)
    }()
    
    ///
    /// Checks if the string provided represents a case of a `Connective`
    /// - Returns: `true` iff `string` is a `Connective`
    ///
    static func isConnective(string: String) -> Bool {
        return Connective(rawString: string) != nil
    }
    
    ///
    /// Checks if the character provided represents a case of a `Connective`
    /// - Returns: `true` iff `char` is a `Connective`
    ///
    static func isConnective(char: Character) -> Bool {
        return self.isConnective(String(char))
    }
    
    ///
    /// Returns all logical connectives sorted by their `precedence` value
    ///
    static var all: [Connective] {
        return [
            Connective.Biconditional,
            Connective.Implicate,
            Connective.Conjoin,
            Connective.Disjoin,
            Connective.Negate
        ].sort({$0.precedence < $1.precedence})
    }
    
    ///
    /// Returns the precedence of this connective
    /// - Remarks: See [Order Of Precdence](https://en.wikipedia.org/wiki/Logical_connective#Order_of_precedence)
    ///
    var precedence: Int {
        return [
            Connective.Negate:         1,
            Connective.Conjoin:        2,
            Connective.Disjoin:        3,
            Connective.Implicate:      4,
            Connective.Biconditional:  5
        ][self]!
    }
    
    ///
    /// Associativity of the connective
    ///
    var associativity: Associativity {
        return self == .Negate ? .Right : .Left
    }
    
    ///
    /// Returns `true` iff the connective is an unary connective (i.e., is `Negate`)
    ///
    var isUnary: Bool {
        // Only prefix is a negate connective
        return self == .Negate
    }
    
    ///
    /// Returns `true` iff the connective is a binary connective (i.e., is not `Negate`)
    ///
    var isBinary: Bool {
        return !self.isUnary
    }
    
    init?(rawString: String) {
        // Convert \/ to |
        if rawString == "\\/" {
            self.init(rawValue: "|")
        } else {
            self.init(rawValue: rawString)
        }
    }
}

// MARK: Implement Comparable
func <(lhs: Connective, rhs: Connective) -> Bool {
    return (lhs.associativity == .Left && lhs.precedence == rhs.precedence) ||
            lhs.precedence < rhs.precedence
}