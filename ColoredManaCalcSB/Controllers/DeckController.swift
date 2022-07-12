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
    
    enum cardGetError: Error {
        case couldNotFindCardError([String])
    }
    
    enum cardProcessError: Error {
        case noNumber
    }
    
    static var shared = DeckController()
    
    var sectionTitles: [String] = ["60 Card Constructed", "Commander", "Limited"]
    var decksInSection : [String : [Deck]] = [:]
    var fortyCardDeckList = [Deck]()
    var sixtyCardDeckList = [Deck]()
    var hundredCardDeckList = [Deck]()
    var deck = Deck()
    let okChars = "abcdefghijklmnopqrstuvwxyz1234567890"
    var sharedDeckSection:Int = -1
    var sharedDeckRow:Int = -1

    //populates deck text dicts with lowercased card name and num in deck for main and side
    func buildDeckDicts(with textDeckList:String) throws {
        //start in main deck
        var main = true
        //regexs to remove set info (if present)
        let setRegex = try! NSRegularExpression(pattern: "[(][A-Z0-9]{3}[)]")
        let numRegex = try! NSRegularExpression(pattern: "[0-9]{1,3}")
        
        //var testCount = 0
        
        let skipWords = ["Companion", "Commander", "Deck"]
        
        //skip compainion, deck lines, empty lines, move to sideboard if sideboard line is present
        for line in textDeckList.split(separator: "\n", omittingEmptySubsequences: false) {
            
            if line == "Sideboard" || (line.count == 0 && sharedDeckSection != 1) {
                main = false
                continue
            }
            if skipWords.contains(String(line)) || line.count == 0 {continue}
            
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
            
            guard let numCards = Int(lineSplit[0]) else {
                throw cardProcessError.noNumber
            }
            
            //add name & count to dict
            if main {
                //print(lineSplit[1...].joined(separator: " "))
                deck.mainTextCountDict[lineSplit[1...].joined(separator: " ")] = numCards
                deck.numCardsMain += numCards
                //testCount += Int(lineSplit[0])!
            } else {
                deck.sideTextCountDict[lineSplit[1...].joined(separator: " ")] = numCards
                deck.numCardsSide += numCards
            }
        }
    }
    
    //processes array of cards fetched from scryfall API to add to deck if the match names in main card array
    func process (_ cards: [Card]) throws {
        print(deck.mainTextCountDict)
        var matchingName: String
        //add card faces as cards
        for card in cards {
            if let faces = card.cardFaces {
                if card.layout != "split" {
                    matchingName = faces[0].name//.lowercased().filter {okChars.contains($0)}
                } else {
                    matchingName = card.name//.lowercased().filter {okChars.contains($0)}
                }
            } else {
                matchingName = card.name//.lowercased().filter {okChars.contains($0)}
            }
            
            if deck.mainTextCountDict.keys.contains(matchingName.lowercased().filter {okChars.contains($0)}) {
                deck.mainTextCountDict[matchingName] = deck.mainTextCountDict[matchingName.lowercased().filter {okChars.contains($0)}]
                deck.mainTextCountDict.removeValue(forKey: matchingName.lowercased().filter {okChars.contains($0)})
            }
            
            if deck.sideTextCountDict.keys.contains(matchingName.lowercased().filter {okChars.contains($0)}) {
                deck.sideTextCountDict[matchingName] = deck.sideTextCountDict[matchingName.lowercased().filter {okChars.contains($0)}]
                deck.sideTextCountDict.removeValue(forKey: matchingName.lowercased().filter {okChars.contains($0)})
            }
            
            if deck.mainTextCountDict.keys.contains(matchingName){
                if card.cardFaces != nil {
                    processFaces(card, isMainDeck: true)
                } else {
                    deck.mainCardArray.append(card)
                    deck.mainCardArray[deck.mainCardArray.count - 1].numInDeck = deck.mainTextCountDict[matchingName]!
                }
            }
            
            if deck.sideTextCountDict.keys.contains(matchingName){
                if card.cardFaces != nil {
                    processFaces(card, isMainDeck: false)
                } else {
                    deck.sideCardArray.append(card)
                    deck.sideCardArray[deck.sideCardArray.count - 1].numInDeck = deck.sideTextCountDict[matchingName]!
                }
            } else if deck.sideTextCountDict.keys.contains(matchingName.lowercased().filter {okChars.contains($0)}) {
                
            }
        }
        
        var cardNames = [String]()
        var cardsNotFound = [String]()
        
        for card in deck.mainCardArray {
            cardNames.append(card.name)
        }
        
        for card in deck.sideCardArray {
            cardNames.append(card.name)
        }
        
        for plainTextName in deck.mainTextCountDict.keys {
            //finish this check!!!
            if plainTextName.contains("/") {
                var splitName = plainTextName.split(separator: "/", omittingEmptySubsequences: true)
                splitName[0].removeLast()
                splitName[1].removeFirst()
                for namePiece in splitName {
                    let testName = String(namePiece)
                    if !cardNames.contains(testName) {
                        cardsNotFound.append(testName)
                    }
                }
            } else {
                if !cardNames.contains(plainTextName) {
                    cardsNotFound.append(plainTextName)
                }
            }
        }
        
        for plainTextName in deck.sideTextCountDict.keys {
            //finish this check!!!
            if plainTextName.contains("/") {
                var splitName = plainTextName.split(separator: "/", omittingEmptySubsequences: true)
                splitName[0].removeLast()
                splitName[1].removeFirst()
                for namePiece in splitName {
                    let testName = String(namePiece)
                    if !cardNames.contains(testName) {
                        cardsNotFound.append(testName)
                    }
                }
            } else {
                if !cardNames.contains(plainTextName) {
                    cardsNotFound.append(plainTextName)
                }
            }
        }
        
        if cardsNotFound.count > 0 {
            DeckController.shared.deck = Deck()
            throw cardGetError.couldNotFindCardError(cardsNotFound)
        }
    }

    func setDropAndColors () {
        for index in 0..<deck.mainCardArray.count {
            deck.mainCardArray[index].setDrop()

            for color in deck.mainCardArray[index].colors {
                if !deck.colors.contains(color) {deck.colors.append(color)}
            }
        }
        deck.sortColors()
    }
    
    func processFaces (_ card:Card, isMainDeck main:Bool) {
        var faces = card.cardFaces!
        
        for index in 0...1 {
            faces[index].colorIdentity = card.colorIdentity
            if let disturbTextRange = faces[index].oracleText.range(of:"Disturb ([{][WUBRG0-9][}])*", options: .regularExpression) {
                let disturbCost = String(String(faces[0].oracleText[disturbTextRange]).dropFirst(8))
                faces[1].manaCost = disturbCost
            }
            
            if main {
                if card.layout == "split" {
                    faces[index].numInDeck = deck.mainTextCountDict[card.name]!
                } else {
                    faces[index].numInDeck = deck.mainTextCountDict[faces[0].name]!
                }
                deck.mainCardArray.append(faces[index])
            } else {
                if card.layout == "split" {
                    faces[index].numInDeck = deck.sideTextCountDict[card.name]!
                } else {
                    faces[index].numInDeck = deck.sideTextCountDict[faces[0].name]!
                }
                deck.sideCardArray.append(faces[index])
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
                if getNumSources(from: cost, format: sharedDeckSection) > getNumSources(from: mostExpensiveCard.colorClassDict()[color]!, format: sharedDeckSection) {
                    deck.mostExpensiveCardForColor[color] = deck.mainCardArray[index]
                }
            }
        }
    }
    
    //"https://api.scryfall.com/cards/search?q=Hydroid+Krasis+or+Massacre+Girl"


    let baseURL = URL(string: "https://api.scryfall.com/cards/search")!

    func buildQueryStrings (with names: [String]) -> [String] {
        
        var stringList = [String]()
        var queryString = ""
        for name in names {
            //check to see if current querystring + new name > 950 chars (base url = 40 chars & max lenght of URL = 1000 chars
            if queryString.count + name.count + 4 > 950 {
                queryString.removeLast(4)
                stringList.append(queryString)
                queryString = ""
            }
            queryString = queryString + name.replacingOccurrences(of: " ", with: "+") + "+or+"
        }
        queryString.removeLast(4)
        stringList.append(queryString)
        return stringList
    }


    func fetchCards(completion: @escaping ([Card]) -> Void) {
        var names = [String]()
        for name in deck.mainTextCountDict.keys {
            names.append(name.lowercased().filter {okChars.contains($0)})
        }
        for name in deck.sideTextCountDict.keys {
            names.append(name.lowercased().filter {okChars.contains($0)})
        }
        
        let queryStrings = self.buildQueryStrings(with: names)
        
        var fetchedCards = [Card]()
        
        let fetchGroup = DispatchGroup()
        
        for queryString in queryStrings {
            let query: [String: String] = [
                "q": queryString,
            ]
            let url = baseURL.withQueries(query)!
            print(url.absoluteString)
            fetchGroup.enter()
            
            let task = URLSession.shared.dataTask(with: url) {data, response, error in
                let jsonDecoder = JSONDecoder()
                if let data = data,
                    let cards = try? jsonDecoder.decode(Cards.self, from: data) {
                        //print(cards.cards)
                        fetchedCards.append(contentsOf: cards.cards)
                        fetchGroup.leave()
                } else {
                    fetchGroup.leave()
                }
            }
            task.resume()
            
        }
        fetchGroup.notify(queue: DispatchQueue.main) {
            completion(fetchedCards)
        }
    }
        
            
        
        /*let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    let jsonDecoder = JSONDecoder()
                    if let data = data,
                        let cards = try? jsonDecoder.decode(Cards.self, from: data) {
                        self.process(cards.cards)
                        self.setDropAndColors()
                        completion()
                    }
                }
         task.resume()*/
    
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
