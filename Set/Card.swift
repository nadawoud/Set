//
//  Card.swift
//  Set
//
//  Created by Nada Yehia Dawoud on 6/10/18.
//  Copyright © 2018 Mobile Apps Kitchen. All rights reserved.

import Foundation

enum Color {
    case firstColor, secondColor, thirdColor
}

enum Symbol {
    case firstSymbol, secondSymbol, thirdSymbol
}

enum Shading {
    case firstShading, secondShading, thirdShading
}

enum NumberOfSymbols: Int {
    case One = 1, Two = 2, Three = 3
}


struct Card: Hashable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.cardID == rhs.cardID
    }
    
    var cardID: Int
    let symbol: Symbol
    let color: Color
    let shading: Shading
    let numberOfSymbols: NumberOfSymbols
}
