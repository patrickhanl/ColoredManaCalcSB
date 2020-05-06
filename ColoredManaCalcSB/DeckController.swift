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

    func buildDeckDicts(with textDeckList:String) throws {

        var main = true
        let setRegex = try! NSRegularExpression(pattern: "[(][A-Z0-9]{3}[)]")
        let numRegex = try! NSRegularExpression(pattern: "[0-9]{1,3}")
        
        for line in textDeckList.split(separator: "\n", omittingEmptySubsequences: false) {
            if line == "Deck" {continue}
            if line == "Sideboard" || line.count == 0 {
                main = false
                continue
            }
            
            var lineSplit = line.split(separator: " ")
            var range = NSRange(location: 0, length: lineSplit.last!.count)
            if numRegex.firstMatch(in: String(lineSplit.last!), options: [], range: range) != nil {
                lineSplit.popLast()
            }
        
            range = NSRange(location: 0, length: lineSplit.last!.count)
            if setRegex.firstMatch(in: String(lineSplit.last!), options: [], range: range) != nil {
                lineSplit.popLast()
            }
            
            if main {
                    deck.mainText[String(lineSplit[1...].joined(separator: " ")).lowercased().filter {okChars.contains($0)}] = Int(lineSplit[0])
            } else {
                    deck.sideText[String(lineSplit[1...].joined(separator: " ")).lowercased().filter {okChars.contains($0)}] = Int(lineSplit[0])
            }
        }
    }
    
    func process (_ cards: [Card]) {
        for card in cards {
            let processedName = card.name.lowercased().filter {okChars.contains($0)}
            
            if deck.mainText.keys.contains(processedName){
                if let faces = card.cardFaces {
                    for face in faces {
                        deck.mainCardArray.append(face)
                    }
                } else {
                    deck.mainCardArray.append(card)
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
            deck.mainCardArray[index].numInDeck = deck.mainText[deck.mainCardArray[index].name.lowercased().filter {okChars.contains($0)}] ?? -1
            
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
