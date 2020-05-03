//
//  Deck.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import Foundation

struct Deck: Codable {
    var mainCardArray: [Card]
    var sideCardArray: [Card]
    var mainText: [String:Int]
    var sideText: [String:Int]
    var colors: [String]
    var mostExpensiveCardForColor: [String:Card]

    init(mainCardArray: [Card] = [], sideCardArray: [Card] = [], mainText: [String:Int] = [:], sideText: [String:Int] = [:], colors: [String] = [], mostExpensiveCardForColor: [String:Card] = [:]) {
        self.mainCardArray = mainCardArray
        self.sideCardArray = sideCardArray
        self.mainText = mainText
        self.sideText = sideText
        self.colors = []
        self.mostExpensiveCardForColor = mostExpensiveCardForColor
        
    }
    
}

/*struct DeckList: Codable {
    var decks: [Deck]
    
    init(decks: [Deck] = []) {
        self.decks = decks
    }
}*/
