//
//  main.swift
//  inference-engine
//
//  Created by Alex on 20/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

do {
    let sentence = try SentenceParser.sharedParser.parse("(!u => q) & b | a")    
    print(sentence)
} catch {
    print(error)
}