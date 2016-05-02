//
//  Queryable.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// An empty protocol that represents an answer that can be deduced from an
/// entailment method
///
protocol EntailmentResponse: CustomStringConvertible {}
// An integer and atomic sentence can be responses for TT, BC and FC, respectively
extension Int: EntailmentResponse {}
extension AtomicSentence: EntailmentResponse {}

///
/// An entailment method s
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
