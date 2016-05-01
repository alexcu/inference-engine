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
    func entails(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> Bool {
        let model  = Model()
        let symbols = kb.symbols

        return self.entails(kb, query: query, symbols: symbols, model: model)
    }
    
    ///
    /// Recursive entailment function
    ///
    private func entails(kb: KnowledgeBase, query: Sentence, symbols: Symbols, model: Model) -> Bool {
        var symbols = symbols        
        if symbols.isEmpty {
            // Knowledge base is positive when model applied?
            if kb.sentence.applyModel(model).isPositive {
                // Query is positive when model applied?
                return query.applyModel(model).isPositive
            } else {
                // when KB does not entail model always return true
                return true
            }
        } else {
            let proposition = symbols.removeFirst()
            let truthyBranch = self.entails(kb,
                                            query: query,
                                            symbols: symbols,
                                            model: model.extend(proposition, true))
            let falsyBranch = self.entails(kb,
                                           query: query,
                                           symbols: symbols,
                                           model: model.extend(proposition, true))
            return truthyBranch && falsyBranch
        }
    }
}