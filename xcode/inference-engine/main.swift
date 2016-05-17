//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           20/04/2016
//

///
/// Launcher for the solver
///
struct Launcher {
    // MARK: Singleton
    static let sharedLauncher = Launcher()

    // MARK: Type aliases
    private typealias KnowledgeQueryPair = (kb: KnowledgeBase, query: Sentence)

    // MARK: Launch Errors

    ///
    /// Errors that can be caused on launch
    ///
    enum LaunchError: ErrorType {
        case NotEnoughArgumentsProvided
        case InvalidMethodProvided
        case FileUnreadable
        case NoAskLine
        case NoTellLine
        case UnexpectedFileFormat

        ///
        /// Textual description of each error
        ///
        var message: String {
            switch self {
            case .NotEnoughArgumentsProvided:
                return "Invalid arguments. Use `help` for more info"
            case .InvalidMethodProvided:
                return "Invalid inference method provided. Use `help` for more info"
            case .FileUnreadable:
                return "File provided was unreadable"
            case .NoAskLine:
                return "File is missing ASK"
            case .NoTellLine:
                return "File is missing TELL"
            case .UnexpectedFileFormat:
                return "File has invalid format. Use `help` for more info."
            }
        }
    }

    // MARK: Entailment Method Codes

    ///
    /// Possible parsable methods from the command line
    ///
    private enum EntailmentMethodLiteral: String, EntailmentMethod {
        case TruthTableLiteral = "TT"
        case ForwardChainingLiteral = "FC"
        case BackwardChainingLiteral = "BC"
        case ResolutionLiteral = "RE"

        // Implement EntailmentMethod
        func entail(kbQueryPair: KnowledgeQueryPair) -> EntailmentResponse {
            return self.entail(query: kbQueryPair.query,
                               fromKnowledgeBase: kbQueryPair.kb)
        }

        func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
            switch self {
            case .TruthTableLiteral:
                return TruthTable().entail(query: query,
                                         fromKnowledgeBase: kb)
            case .ForwardChainingLiteral:
                return ForwardChaining().entail(query: query,
                                                fromKnowledgeBase: kb)
            case .BackwardChainingLiteral:
                return BackwardChaining().entail(query: query,
                                                 fromKnowledgeBase: kb)
            case .ResolutionLiteral:
                return Resolution().entail(query: query,
                                                  fromKnowledgeBase: kb)
            }
        }

    }

    // MARK: Help descriptions

    ///
    /// The help text
    ///
    var helpText: String {
        let str = [
            "Usage:",
            "  iengine file method [ OPTIONS ]",
            "  search --help",
            "",
            "Puzzle problem search solver",
            "",
            "File:",
            "  Expects a file whose first line TELL's the knowledge base of its",
            "  percepts and whose second line ASK's the knowledge base a query:",
            "",
            "    TELL",
            "    r; !u; p & !u => w",
            "    ASK",
            "    w",
            "",
            "Method:",
            self.searchMethodDescriptions,
            "",
            "Options:",
            " --help"
        ]
        return str.joinWithSeparator("\n")
    }

    ///
    /// Returns textual description of all search methods available
    ///
    var searchMethodDescriptions: String {
        let str = [
            "  [TT] infer using truth table method",
            "  [BC] infer using backward chaning method",
            "  [FC] infer using forward chaining method",
            "  [RE] infer using resolution method",
        ]
        return str.joinWithSeparator("\n")
    }

    // MARK: Parsers

    ///
    /// Parse the provided file to return the `KnowledgeBase` and query
    /// - Parameter path: The path of the file to parse
    /// - Returns: A tuple containing the knowledge base and query to ask
    ///
    private func parseFile(path: String) throws -> KnowledgeQueryPair {
        // Read the file
        guard let contents = FileParser.readFile(path) else {
            throw LaunchError.FileUnreadable
        }
        // Support Windows carriage–returns
        let splitBy = Character(contents.characters.contains("\r\n") ? "\r\n" : "\n")
        let lines = contents.characters .split(splitBy)
                                        .filter({!$0.isEmpty}) // remove empty lines
                                        .map({String($0)})
        // Count of lines must be 4
        let correctFormat = lines.count == 4 && lines[0] == "TELL" && lines[2] == "ASK"
        if !correctFormat {
            throw LaunchError.UnexpectedFileFormat
        }

        let percepts =
            try lines[1].characters
                            .split(";")
                            .map({try SentenceParser.sharedParser.parse(String($0))})
        let query = try SentenceParser.sharedParser.parse(lines[3])

        return (
            kb: KnowledgeBase(percepts: percepts),
            query: query
        )
    }

    ///
    /// Parses program argumenrts
    /// - Returns: An entailment method literal
    ///
    private func parseArgs() throws -> (EntailmentMethodLiteral, KnowledgeQueryPair) {
        // Strip the args
        var args = Process.arguments.enumerate().generate()
        var kbQueryPair: KnowledgeQueryPair?
        var entailmentMethod: EntailmentMethodLiteral?
        // Look for extra arguments
        while let arg = args.next() {
            // Default to index positions
            switch arg.index {
            // Filename
            case 1:
                let filename = arg.element
                // Try parse provided file
                kbQueryPair = try parseFile(filename)
            // Entailment method
            case 2:
                if let tryEntailmentMethod = EntailmentMethodLiteral(rawValue: arg.element) {
                    entailmentMethod = tryEntailmentMethod
                } else {
                    throw LaunchError.InvalidMethodProvided
                }
            default:
                // Don't handle
                break
            }
        }
        return (entailmentMethod!, kbQueryPair!)
    }

    // MARK: Entry point

    ///
    /// Entry point of the solver
    ///
    func run() throws {
        do {
            // Process args when argc is at least 2 else print help
            if Process.argc > 2 {
                let (entailmentMethod, kbQueryPair) = try parseArgs()
                return print(entailmentMethod.entail(kbQueryPair).description)
            }
            print(self.helpText)
        } catch let error as Launcher.LaunchError {
            throw error
        }
    }
}


do {
    try Launcher.sharedLauncher.run()
} catch let error as Launcher.LaunchError {
    print(error.message)
}
