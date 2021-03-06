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
    
    var deckList = [Deck]()
    var deck = Deck()
    let okChars = "abcdefghijklmnopqrstuvwxyz1234567890"

    //build dictionary of card names as lowercased, no space text strings and number of cards in deck
    func buildDeckDicts(with textDeckList:String) throws {

        //start in main deck
        var main = true
        //regexs to remove set info (if present)
        let setRegex = try! NSRegularExpression(pattern: "[(][A-Z0-9]{3}[)]")
        let numRegex = try! NSRegularExpression(pattern: "[0-9]{1,3}")
        
        //skip compainion, deck lines, empty lines, move to sideboard if sideboard line is present
        for line in textDeckList.split(separator: "\n", omittingEmptySubsequences: false) {
            if line == "Companion" || line == "Deck" || line.count == 0 {continue}
            if line == "Sideboard" {
                main = false
                continue
            }
            
            //separate num in deck and set info from name
            var lineSplit = line.split(separator: " ")
            var range = NSRange(location: 0, length: lineSplit.last!.count)
            if numRegex.firstMatch(in: String(lineSplit.last!), options: [], range: range) != nil {
                lineSplit.popLast()
            }
        
            range = NSRange(location: 0, length: lineSplit.last!.count)
            if setRegex.firstMatch(in: String(lineSplit.last!), options: [], range: range) != nil {
                lineSplit.popLast()
            }
            
            //add name lowercased with no spaces to main or sideboard text array
            if main {
                    deck.mainText[String(lineSplit[1...].joined(separator: " ")).lowercased().filter {okChars.contains($0)}] = Int(lineSplit[0])
            } else {
                    deck.sideText[String(lineSplit[1...].joined(separator: " ")).lowercased().filter {okChars.contains($0)}] = Int(lineSplit[0])
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
            
            if deck.mainText.keys.contains(processedName){
                if let faces = card.cardFaces {
                    for face in faces {
                        deck.mainCardArray.append(face)
                        deck.mainCardArray[deck.mainCardArray.count - 1].colorIdentity = card.colorIdentity
                        deck.mainCardArray[deck.mainCardArray.count - 1].numInDeck = deck.mainText[card.cardFaces![0].name.lowercased().filter {okChars.contains($0)}]! //if adding numindeck here, do we need it later?? I think so as we need main card for reference
                    }
                } else {
                    deck.mainCardArray.append(card)
                    deck.mainCardArray[deck.mainCardArray.count - 1].numInDeck = deck.mainText[card.name.lowercased().filter {okChars.contains($0)}]!
                }
            }
            
            if deck.sideText.keys.contains(processedName){
                if let faces = card.cardFaces {
                    for face in faces {
                        deck.sideCardArray.append(face)
                    }
                } else {
                    deck.sideCardArray.append(card)
                }
            }
        }
    }

    func setAttributes () {
        for index in 0..<deck.mainCardArray.count {
            deck.mainCardArray[index].setDrop()
            //is below necessary if i can add in process??
            if (deck.mainCardArray[index].numInDeck < 0) {
                deck.mainCardArray[index].numInDeck = deck.mainText[deck.mainCardArray[index].name.lowercased().filter {okChars.contains($0)}] ?? -1
            }
            
            for color in deck.mainCardArray[index].colors {
                if !deck.colors.contains(color) {deck.colors.append(color)}
            }
            for (color, cost) in deck.mainCardArray[index].colorClassDict() {
                //is guard best here?
                guard let mostExpensiveCard = deck.mostExpensiveCardForColor[color] else {
                    deck.mostExpensiveCardForColor[color] = deck.mainCardArray[index]
                    continue
                }
                if getNumSources(from: cost) > getNumSources(from: mostExpensiveCard.colorClassDict()[color]!) {
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
        for name in deck.mainText.keys {
            names.append(name)
        }
        for name in deck.sideText.keys {
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
                self.setAttributes()
                completion()
            }
        }
        task.resume()
    }
    
    func loadDecks() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let deckListFileURL = documentsDirectoryURL.appendingPathComponent("deckList").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: deckListFileURL) else {return}
        let decks = (try? JSONDecoder().decode([Deck].self, from: data)) ?? []
            self.deckList = decks
        
    }
    
    func saveDecks() {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let deckListFileURL = documentsDirectoryURL.appendingPathComponent("deckList").appendingPathExtension("json")
        
        let decks = deckList
        if let data = try? JSONEncoder().encode(decks) {
            try? data.write(to: deckListFileURL)
        }
    }
    
}
