//
//  ADTs.swift
//  inference-engine
//
//  Created by Alex on 26/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A stack
///
struct Stack<T> {
    ///
    /// Underlying elements
    ///
    private(set) var elements = [T]()
    
    ///
    /// Returns `true` iff the stack is empty
    ///
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    ///
    /// Push a new element onto the top of the stack
    /// - Paramater element: The element to push
    ///
    mutating func push(element: T) {
        elements.append(element)
    }
    
    ///
    /// Pop the topmost element off the top of the stack
    /// - Returns: The element that was removed
    ///
    mutating func pop() -> T {
        return elements.removeLast()
    }
    
    ///
    /// Returns the topmost element on the top of the stack
    /// - Returns: An optional element that was at the top
    ///
    func top() -> T? {
        return elements.last
    }
}

///
/// A queue
///
struct Queue<T> {
    ///
    /// Underlying elements
    ///
    private(set) var elements = [T]()
    
    ///
    /// Returns `true` iff the queue is empty
    ///
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    ///
    /// Enqueues a new element at the start of the queue
    /// - Paramater element: The element to enqueue
    ///
    mutating func enqueue(element: T) {
        elements.append(element)
    }
    
    ///
    /// Dequeues the firstmost element in the queue
    /// - Returns: The firstmost element
    ///
    mutating func dequeue() -> T {
        return elements.removeFirst()
    }
}
