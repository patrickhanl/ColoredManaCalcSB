//
//  Deck.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import Foundation

struct Deck: Codable {
    //var companion: Card?
    var name: String
    var mainCardArray: [Card]
    var sideCardArray: [Card]
    var mainText: [String:Int]
    var sideText: [String:Int]
    var colors: [String]
    var mostExpensiveCardForColor: [String:Card]
    var landCount: Int {
        var count = 0
        for card in self.mainCardArray.filter({$0.typeLine.contains("Land")}){
            count += card.numInDeck
        }
        return count
    }
    var numLandsForColor: [String:Int] {
        var colorSourcesDict = [String:Int]()
        for item in self.colors {
            colorSourcesDict[item] = 0
        }
        for card in self.mainCardArray.filter({$0.typeLine.contains("Land")}){
            for color in card.colorIdentity! {
                for pair in colorSourcesDict.filter({$0.key.contains(color)}) {
                    colorSourcesDict[pair.key]! += card.numInDeck
                    }
                }
            }
        return colorSourcesDict
        }

    init(name: String = "", mainCardArray: [Card] = [], sideCardArray: [Card] = [], mainText: [String:Int] = [:], sideText: [String:Int] = [:], colors: [String] = [], mostExpensiveCardForColor: [String:Card] = [:]) {
        
        self.name = "New Deck"
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
