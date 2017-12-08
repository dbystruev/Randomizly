//
//  Model.swift
//  Randomizly2
//
//  Created by Denis Bystruev on 01/12/2017.
//  Copyright © 2017 Denis Bystruev. All rights reserved.
//

import Foundation

enum guessResult {
    case tooLow
    case correct
    case tooHigh
}

class Model {
    private(set) var minNumber = 1000
    private(set) var maxNumber = 2000
    
    private var number = 0
    private(set) var tries = 0
    
    init() {
        randomize()
    }
    
    func guess(_ number: Int) -> guessResult {
        tries += 1
        if number < self.number {
            minNumber = number + 1
            return .tooLow
        } else if number == self.number {
            return .correct
        } else {
            maxNumber = number - 1
            return .tooHigh
        }
    }
    
    func randomize() {
        minNumber = Int(arc4random_uniform(100) + 1)
        maxNumber = Int(arc4random_uniform(900) + 1) + 100
        number = Int(arc4random_uniform(UInt32(maxNumber - minNumber + 1))) + minNumber
        tries = 0
    }
}
