//
//  TruthTable.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

// Represents logical entailment (does entail and does NOT entail)
infix operator |=   { }

func |=(sentence: Sentence, model: Model) -> Bool {
    return sentence.applyModel(model).isPositive
}
func |=(knowledgeBase: KnowledgeBase, model: Model) -> Bool {
    return knowledgeBase.sentence.applyModel(model).isPositive
}

///
/// TruthTable entails query
///
struct TruthTable {
    ///
    /// Symbols is a set of propositional symbols
    ///
    private typealias Symbols = Set<PropositionalSymbol>
    
    ///
    /// Use the truth table method to see if the provided `query` can be entailed
    /// from the given knowledge base, `kb`
    ///
    func entailCount(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> Int {
        let model  = Model()
        let symbols = kb.symbols

        return self.entailCount(kb, query: query, symbols: symbols, model: model, count: 0)
    }
    
    ///
    /// Recursive entailment function
    ///
    private func entailCount(kb: KnowledgeBase, query: Sentence, symbols: Symbols, model: Model, count: Int) -> Int {
        var symbols = symbols
        if symbols.isEmpty {
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
        let truthyBranch = self.entailCount(kb,
                                            query: query,
                                            symbols: symbols,
                                            model: model.extend(proposition, true),
                                            count: count)
        let falsyBranch = self.entailCount(kb,
                                           query: query,
                                           symbols: symbols,
                                           model: model.extend(proposition, false),
                                           count: count)
        return count + truthyBranch + falsyBranch
    }
}