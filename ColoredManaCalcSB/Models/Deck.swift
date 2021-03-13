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
        //store colors and number of soures, colors read from card "colors" attribute
        var colorSourcesDict = [String:Int]()
        //add all colors to dictionary with 0 num sources
        for item in self.colors {
            colorSourcesDict[item] = 0
        }
        //for each land card
        let pipExpression = try! NSRegularExpression(pattern: "[{][WUBRGC][}]")
        for card in self.mainCardArray.filter({$0.typeLine.contains("Land")}) {
            let range = NSRange(location: 0, length: card.oracleText.utf16.count)
            //matches "{color}" and returns array of those matches. matches method returns object representing index of matches (i think?) and map method converts back to string
            let producedColors = pipExpression.matches(in: card.oracleText, options: [], range: range).map {String(card.oracleText[Range($0.range, in: card.oracleText)!])}
            //for each color the land produces, add the land count to the color sources dict.
            for color in producedColors {
                for pair in colorSourcesDict.filter({$0.key.contains(color[color.index(after: color.startIndex)])}) {
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
