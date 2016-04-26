//
//  Queryable.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Queryable is anything that can be provided a query with a return
/// of either true or false
///
protocol Queryable {
    ///
    /// Asking a queryable object to check if the propositional symbol
    /// exists in its knowledge base
    ///
    func query(query: PropositionalSymbol) -> Bool
}
