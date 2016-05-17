//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           1/05/2016
//

///
/// Default type for a model
///
typealias ModelLiteralType = [PropositionalSymbol:Bool]

///
/// A model is a set of atomic sentences associated to their boolean assignments
///
struct Model {
    ///
    /// Binding of each propositional symbol to their boolean assignments
    ///
    private var elements: ModelLiteralType
    
    ///
    /// Initialises the model with no assignments
    ///
    init() {
        self = Model.init(elements: [:])
    }
    
    ///
    /// Initialises the model with the predetermined assignments
    ///
    init(elements: ModelLiteralType) {
        self.elements = elements
    }
    
    ///
    /// Extends the model with the given sentence
    /// - Paramater proposition: The propositional symbol to add
    /// - Paramater value: The boolean value representing its truth assignment
    /// - Returns: A new model representing the updated model
    ///
    func extend(proposition: PropositionalSymbol, _ value: Bool) -> Model {
        var newModel = self
        newModel.elements[proposition] = value
        return newModel
    }
    
    ///
    /// Subscript accessor for model
    ///
    subscript(symbol: PropositionalSymbol) -> Bool? {
        return self.elements[symbol]
    }
}