//
//  TruthTable.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A truth table is an entailment method that uses truth tables to entail an
/// `EntailmentResponse` when queried
///
struct TruthTable: EntailmentMethod {
    // MARK: Implement EntailmentMethod
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse {
        // Use private entail using the kb's symbols, a fresh model, and a count of 0
        return self.entail(query: query,
                           fromKnowledgeBase: kb,
                           usingSymbols: kb.symbols,
                           usingModel: Model(),
                           previousCount: 0)
    }

    ///
    /// Symbols is a set of propositional symbols
    ///
    private typealias Symbols = Set<PropositionalSymbol>
    
    ///
    /// Recursive entailment function that returns a count of the number of models the
    /// query can be entailed from the knowledge base
    /// - Remarks: Equivalent to the `TT-CHECK-ALL` function
    /// - Parameter kb: The knowledge base to entail from
    /// - Parameter query: The query to ask
    /// - Parameter symbols: The current symbols that can be used to entail the response
    /// - Parameter model: The existing model that is being used in the entailment
    /// - Parameter count: The current count of the number of models in the truth table
    /// - Returns: The number of times the query can be entailed from the knowledge base
    ///
    private func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase, usingSymbols symbols: Symbols, usingModel model: Model, previousCount count: Int) -> Int {
        var symbols = symbols
        if symbols.isEmpty {
            //print(model)
            //print(kb.sentence.applyModel(model).truthDescription)
            // Knowledge base is positive when model applied?
            if kb.sentence.applyModel(model).isPositive {
                // Query is positive when model applied?
                if query.applyModel(model).isPositive {
                    return count + 1
                }
            } else {
                return count
            }
        }
        let proposition = symbols.popFirst()!
        // Recursively use the entail count using both truth and false branches
        // extending the model with the proposition popped above from the symbols
        // and assigning it to the current truth from the truth array below
        return [true, false].reduce(count) { reducedCount, truth in
            reducedCount + self.entail(query: query,
                                fromKnowledgeBase: kb,
                                usingSymbols: symbols,
                                usingModel: model.extend(proposition, truth),
                                previousCount: count)
        }
    }
}