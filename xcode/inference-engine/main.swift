//
//  main.swift
//  inference-engine
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//


///
/// Launcher for the solver
///
struct Launcher {
    // MARK: Singleton
    static let sharedLauncher = Launcher()

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

    // MARK: GUI Type

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
        ]
        return str.joinWithSeparator("\n")
    }

    // MARK: Parsers

    ///
    /// Parse the provided file to return the `KnowledgeBase` and query
    /// - Parameter path: The path of the file to parse
    /// - Returns: A tuple containing the knowledge base and query to ask
    ///
    private func parseFile(path: String) throws -> (kb: KnowledgeBase, query: Sentence) {
        // Read the file
        guard let contents = FileParser.readFile(path) else {
            throw LaunchError.FileUnreadable
        }
        // Support Windows carriage–returns
        let splitBy = Character(contents.characters.contains("\r\n") ? "\r\n" : "\n")
        let lines = contents.characters .split(splitBy)
                                        .filter({!$0.isEmpty})
                                        .map({String($0)})
        // Count of lines must be 4
        let correctFormat = lines.count == 4 && lines[0] == "ASK" && lines[2] == "TELL"
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
}