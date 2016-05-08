//
//  Queryable.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A protocol that represents an answer that can be deduced from an
/// entailment method
///
protocol EntailmentResponse: CustomStringConvertible {
    ///
    /// Whether or not the response does actually entail the result
    ///
    var doesEntail: Bool { get }
    
    var description: String { get }
}
// An integer and atomic sentence can be responses for TT, BC and FC, respectively
extension Int: EntailmentResponse {
    var doesEntail: Bool {
        return self > 0
    }
    
    var description: String {
        if self.doesEntail {
            return "YES: \(self)"
        } else {
            return "NO"
        }
    }
}
extension Array: EntailmentResponse {
    var doesEntail: Bool {
        return !self.isEmpty
    }
    
    var description: String {
        if self.doesEntail {
            let elements = self.map({"\($0); "})
            return "YES: \(elements)"
        } else {
            return "NO"
        }
    }
}

///
/// An entailment method
///
protocol EntailmentMethod {
    ///
    /// Checks if the provided `query` can be entailed from the given
    /// knowledge base, `kb`. If so, an entailment response will be given, or else
    /// `nil` is returned if not.
    /// - Paramater query: The query to entail
    /// - Paramater kb: The knowledge base to entail from
    ///
    func entail(query query: Sentence, fromKnowledgeBase kb: KnowledgeBase) -> EntailmentResponse
}
