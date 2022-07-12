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
    var mainTextCountDict: [String:Int] = [:]
    var sideTextCountDict: [String:Int] = [:]
    var numCardsMain: Int
    var numCardsSide: Int
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
    
    mutating func sortColors() {
        colors.sort {lhs, rhs in
            return orderedColorsDict[lhs]! < orderedColorsDict[rhs]!
        }
    }
    
    func exportDecklist() -> String {
        //let okChars = "abcdefghijklmnopqrstuvwxyz1234567890"
        var returnString = "Deck\n"
        var mainCount:Int = 0
        var sideCount:Int = 0
        
        /*for card in mainCardArray {
            if let count = mainTextCountDict[card.name.lowercased().replacingOccurrences(of: " ", with: "").filter {okChars.contains($0)}] {
                mainCount += count
                returnString.append(String(count) + " " + card.name + "\n")
            }
            else {
                //print(card.name + " not found!")
            }
        }
        returnString.append("\nSideboard\n")
        
        for card in sideCardArray {
            if let count = sideTextCountDict[card.name.lowercased().replacingOccurrences(of: " ", with: "").filter {okChars.contains($0)}] {
                returnString.append(String(count) + " " + card.name + "\n")
                sideCount += count
            }
            else {
                //print(card.name + " not found!")
            }
        }
        
         */
        for (name, number) in mainTextCountDict {
            returnString.append("\(number) \(name)\n")
            mainCount += number
        }
        returnString.append("\nSideboard\n")
        for (name, number) in sideTextCountDict {
            returnString.append("\(number) \(name)\n")
            sideCount += number
        }
        
        returnString.removeLast()
        print("Main Count = " + String(mainCount))
        print("Side Count = " + String(sideCount))
        
        return returnString
    }

    init(name: String = "", mainCardArray: [Card] = [], sideCardArray: [Card] = [], numCardsMain: Int = 0, numCardsSide: Int = 0, colors: [String] = [], mostExpensiveCardForColor: [String:Card] = [:]) {
        
        self.name = "New Deck"
        self.mainCardArray = mainCardArray
        self.sideCardArray = sideCardArray
        self.numCardsMain = numCardsMain
        self.numCardsSide = numCardsSide
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
