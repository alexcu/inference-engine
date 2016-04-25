//
//  Int+nthBit.swift
//  inference-engine
//
//  Created by Alex on 25/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

extension Int {
    func nthBit(n: Int) -> Int {
        return (self >> n) & 1
    }
}