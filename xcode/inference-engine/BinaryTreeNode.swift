//
//  BinaryTreeNode.swift
//  inference-engine
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

class BinaryTreeNode {
    let children: (left: BinaryTreeNode, right: BinaryTreeNode)

    let truth: Bool

    init(truth: Bool, leftNode: BinaryTreeNode, rightNode: BinaryTreeNode) {
        self.children = (leftNode, rightNode)
        self.truth = truth
    }
}

class SentinelBinaryTreeNode: BinaryTreeNode {
    static private let sharedInstance = SentinelBinaryTreeNode()

    init() {
        super.init(truth: false, leftNode: self, rightNode: self)
    }
}