//
//  TruthTable.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct TruthTable {
    typealias Model = [Symbol:Bool]
    let symbols: Set<Symbol>
    init(symbols: [Symbol]) {
        self.init(symbols: Set(symbols))
    }
    init(symbols: Set<Symbol>) {
        self.symbols = symbols
    }
    func query(query: Symbol) -> Bool {
        let symbols = Array(self.symbols)
        let model  = Model()
        
        return self.query(query, symbols: symbols, model: model)
    }
    private func query(query: Symbol, symbols: [Symbol], model: Model) -> Bool {
        var symbols = symbols
        let model = model
        func extendModel(proposition: Symbol, _ value: Bool) -> Model {
            var newModel = model
            newModel[proposition] = value
            return newModel
        }
        if !symbols.isEmpty {
            let proposition = symbols.removeFirst()
            let truthyBranch = self.query(query,
                                          symbols: symbols,
                                          model: extendModel(proposition, true))
            let falsyBranch = self.query(query,
                                         symbols: symbols,
                                         model: extendModel(proposition, true))
            return truthyBranch && falsyBranch
        } else {
//            if KnowledgeBase.sharedKnowledgeBase() |= query {
//                return query |= model
//            } else {
//                return true
//            }
            print(model)
            return true
        }
    }
}