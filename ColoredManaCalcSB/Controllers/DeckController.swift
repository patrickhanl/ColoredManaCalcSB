//
//  DeckController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

// need to figure out adventures
// split cards

import Foundation

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        return components?.url
    }
}

class DeckController {
    
    static var shared = DeckController()
    
    var sectionTitles: [String] = ["60 Card Constructed", "Commander", "Limited"]
    var decksInSection : [String : [Deck]] = [:]
    var fortyCardDeckList = [Deck]()
    var sixtyCardDeckList = [Deck]()
    var hundredCardDeckList = [Deck]()
    var deck = Deck()
    let okChars = "abcdefghijklmnopqrstuvwxyz1234567890"

    //populates deck text dicts with lowercased card name and num in deck for main and side
    func buildDeckDicts(with textDeckList:String) throws {

        //start in main deck
        var main = true
        //regexs to remove set info (if present)
        let setRegex = try! NSRegularExpression(pattern: "[(][A-Z0-9]{3}[)]")
        let numRegex = try! NSRegularExpression(pattern: "[0-9]{1,3}")
        
        let skipWords = ["Companion", "Commander", "Deck"]
        
        //skip compainion, deck lines, empty lines, move to sideboard if sideboard line is present
        for line in textDeckList.split(separator: "\n", omittingEmptySubsequences: false) {
            if skipWords.contains(String(line)) {continue}
            if line == "Sideboard" || line.count == 0 {
                main = false
                continue
            }
            
            //separate num in deck and set info from name
            var lineSplit = line.split(separator: " ")
            var range = NSRange(location: 0, length: lineSplit.last!.count)
            if numRegex.firstMatch(in: String(lineSplit.last!), options: [], range: range) != nil {
                lineSplit.removeLast()
            }
        
            range = NSRange(location: 0, length: lineSplit.last!.count)
            if setRegex.firstMatch(in: String(lineSplit.last!), options: [], range: range) != nil {
                lineSplit.removeLast()
            }
            
            //add name lowercased with no spaces to main or sideboard text dict
            if main {
                deck.mainTextCountDict[String(lineSplit[1...].joined(separator: " ")).lowercased().filter {okChars.contains($0)}] = Int(lineSplit[0])
                deck.numCardsMain += Int(lineSplit[0])!
            } else {
                    deck.sideTextCountDict[String(lineSplit[1...].joined(separator: " ")).lowercased().filter {okChars.contains($0)}] = Int(lineSplit[0])
                deck.numCardsSide += Int(lineSplit[0])!
            }
        }
    }
    
    //processes array of cards fetched from scryfall API to add to deck if the match names in main card array
    func process (_ cards: [Card]) {
        var processedName :String
        //add card faces as cards
        for card in cards {
            if let faces = card.cardFaces {
                processedName = faces[0].name.lowercased().filter {okChars.contains($0)}
                
            } else {
                processedName = card.name.lowercased().filter {okChars.contains($0)}
            }
            
            if deck.mainTextCountDict.keys.contains(processedName){
                if var faces = card.cardFaces {
                    for index in 0...1 {
                        //it may be best to first add the deck with faces not being their own card? maybe come back to this IDK
                        //nvm this is stored in the text-count dict really
                        
                        faces[index].colorIdentity = card.colorIdentity
                        faces[index].numInDeck = deck.mainTextCountDict[processedName]!
                        if let disturbTextRange = faces[index].oracleText.range(of:"Disturb ([{][WUBRG0-9][}])*", options: .regularExpression) {
                            let disturbCost = String(String(faces[0].oracleText[disturbTextRange]).dropFirst(8))
                            faces[1].manaCost = disturbCost
                        }
                        deck.mainCardArray.append(faces[index])
                    }
                } else {
                    deck.mainCardArray.append(card)
                    deck.mainCardArray[deck.mainCardArray.count - 1].numInDeck = deck.mainTextCountDict[processedName]!
                }
            }
            
            if deck.sideTextCountDict.keys.contains(processedName){
                if var faces = card.cardFaces {
                    for index in 0...1 {
                        //it may be best to first add the deck with faces not being their own card? maybe come back to this IDK
                        //nvm this is stored in the text-count dict really
                        
                        faces[index].colorIdentity = card.colorIdentity
                        faces[index].numInDeck = deck.sideTextCountDict[processedName]!
                        if let disturbTextRange = faces[index].oracleText.range(of:"Disturb ([{][WUBRG0-9][}])*", options: .regularExpression) {
                            let disturbCost = String(String(faces[0].oracleText[disturbTextRange]).dropFirst(8))
                            faces[1].manaCost = disturbCost
                        }
                        deck.sideCardArray.append(faces[index])

                    }
                } else {
                    deck.sideCardArray.append(card)
                    deck.sideCardArray[deck.sideCardArray.count - 1].numInDeck = deck.sideTextCountDict[processedName]!
                }
            }
        }
        
        
    }

    func setDropAndColors () {
        for index in 0..<deck.mainCardArray.count {
            deck.mainCardArray[index].setDrop()
            
            for color in deck.mainCardArray[index].colors {
                if !deck.colors.contains(color) {deck.colors.append(color)}
            }
        }
    }
    
    func setMostExpensiveCard () {
        deck.mostExpensiveCardForColor = [String:Card]()
        for index in 0..<deck.mainCardArray.count {
            for (color, cost) in deck.mainCardArray[index].colorClassDict() {
                //is guard best here?
                guard let mostExpensiveCard = deck.mostExpensiveCardForColor[color] else {
                    deck.mostExpensiveCardForColor[color] = deck.mainCardArray[index]
                    continue
                }
                if getNumSources(from: cost, numCardsInDeck: deck.numCardsMain) > getNumSources(from: mostExpensiveCard.colorClassDict()[color]!, numCardsInDeck: deck.numCardsMain) {
                    deck.mostExpensiveCardForColor[color] = deck.mainCardArray[index]
                }
            }
        }
    }
    
    //"https://api.scryfall.com/cards/search?q=Hydroid+Krasis+or+Massacre+Girl"


    let baseURL = URL(string: "https://api.scryfall.com/cards/search")!

    func buildQueryString(with names: [String]) -> String{
        
        var queryString = ""
        for name in names {
            queryString = queryString + name.replacingOccurrences(of: " ", with: "+") + "+or+"
        }
        queryString.removeLast(4)
        return queryString
    }


    func fetchCards(completion: @escaping () -> Void) {
        var names = [String]()
        for name in deck.mainTextCountDict.keys {
            names.append(name)
        }
        for name in deck.sideTextCountDict.keys {
            names.append(name)
        }
        
        let queryString = self.buildQueryString(with: names)
        let query: [String: String] = [
                
                "q": queryString,
        ]
            
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let cards = try? jsonDecoder.decode(Cards.self, from: data) {
                self.process(cards.cards)
                self.setDropAndColors()
                completion()
            }
        }
        task.resume()
    }
    
    func loadDecks() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fortyCardDeckListFileURL = documentsDirectoryURL.appendingPathComponent("fortyCardDeckList").appendingPathExtension("json")
        let sixtyCardDeckListFileURL = documentsDirectoryURL.appendingPathComponent("sixtyCardDeckList").appendingPathExtension("json")
        let hundredCardDeckListFileURL = documentsDirectoryURL.appendingPathComponent("hundredCardDeckList").appendingPathExtension("json")
        
        guard let fortyCardData = try? Data(contentsOf: fortyCardDeckListFileURL) else {return}
        let fortyCardDecks = (try? JSONDecoder().decode([Deck].self, from: fortyCardData)) ?? []
            self.fortyCardDeckList = fortyCardDecks
        
        guard let sixtyCardData = try? Data(contentsOf: sixtyCardDeckListFileURL) else {return}
        let sixtyCardDecks = (try? JSONDecoder().decode([Deck].self, from: sixtyCardData)) ?? []
            self.sixtyCardDeckList = sixtyCardDecks
        
        guard let hundredCardData = try? Data(contentsOf: hundredCardDeckListFileURL) else {return}
        let hundredCardDecks = (try? JSONDecoder().decode([Deck].self, from: hundredCardData)) ?? []
            self.hundredCardDeckList = hundredCardDecks
    }
    
    func saveDecks() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fortyCardDeckListFileURL = documentsDirectoryURL.appendingPathComponent("fortyCardDeckList").appendingPathExtension("json")
        let sixtyCardDeckListFileURL = documentsDirectoryURL.appendingPathComponent("sixtyCardDeckList").appendingPathExtension("json")
        let hundredCardDeckListFileURL = documentsDirectoryURL.appendingPathComponent("hundredCardDeckList").appendingPathExtension("json")
        
        let fortyCardDecks = fortyCardDeckList
        if let data = try? JSONEncoder().encode(fortyCardDecks) {
            try? data.write(to: fortyCardDeckListFileURL)
        }
        
        let sixtyCardDecks = sixtyCardDeckList
        if let data = try? JSONEncoder().encode(sixtyCardDecks) {
            try? data.write(to: sixtyCardDeckListFileURL)
        }
        
        let hundredCardDecks = hundredCardDeckList
        if let data = try? JSONEncoder().encode(hundredCardDecks) {
            try? data.write(to: hundredCardDeckListFileURL)
        }
    }
    
}
