//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           26/04/2016
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
    /// Returns the topmost element on the top of the stack
    /// - Returns: An optional element that was at the top
    ///
    var top: T? {
        return elements.last
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
    /// Returns the firstmost element at the start of the queue
    /// - Returns: An optional element that was at the start
    ///
    var first: T? {
        return elements.first
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

    func reverse() -> Queue<T> {
        var newQueue = Queue<T>()
        for el in self.elements.reverse() {
            newQueue.enqueue(el)
        }
        return newQueue
    }

}
