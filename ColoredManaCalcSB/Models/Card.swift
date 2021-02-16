//
//  Card.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import Foundation

struct Card: Hashable, Codable, Comparable, Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.name < rhs.name
    }
    
    //need to evaluate best solution for colors for faces if face is to be card, which i think it does
    
    let name: String
    let typeLine: String
    let manaCost: String
    let colorIdentity: [String]?
    var colors: [String] {
        let colorString = self.manaCost.filter({ !"{1234567890X".contains($0)})
        return colorString.split(separator: "}").map({String($0)})
    }
    var cardFaces: [Card]?
    var hybrid: Bool {return self.manaCost.contains("/")}
    var gold: Bool {return self.colors.count > 0}
    var x: Bool {return self.manaCost.contains("X")}
    var drop = 0
    var numInDeck = 0
    var colorCost: [String] {
        var mod_str = self.manaCost
        for char in "{1234567890X" {
            mod_str.removeAll(where: {char == $0})
        }
        return mod_str.components(separatedBy: "}").filter({$0 != ""})
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case typeLine = "type_line"
        case manaCost = "mana_cost"
        case colorIdentity = "color_identity"
        case cardFaces = "card_faces"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        typeLine = try container.decode(String.self, forKey: .typeLine)
        manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost) ?? ""
        colorIdentity = try container.decodeIfPresent([String].self, forKey: .colorIdentity) ?? []
        cardFaces = try container.decodeIfPresent([Card].self, forKey: .cardFaces)
        
    }
    
    mutating func setDrop() {
        var derivedCMC = 0
        var mod_str = self.manaCost
        
        for char in "{X" {
            mod_str.removeAll(where: {char == $0})
        }
        var pipList = mod_str.components(separatedBy: "}")
        pipList.removeLast()

        for pip in pipList {
            if "123456789".contains(pip) {derivedCMC += Int(pip)!} else if pip.contains("P") {derivedCMC += 0} else {derivedCMC+=1}
        }
        
        self.drop = derivedCMC
    }
    
    func colorClassDict() ->  [String:String] {
        var pipCount = [String:Int]()
        var colorDict = [String:String]()
        var classString: String
        
        for pip in self.colorCost {
            if pipCount.contains(where: { $0.key == pip}) {
                pipCount[pip]! += 1} else {pipCount[pip] = 1}
        }
        
        for color in pipCount {
            if color.value == self.drop {
                classString = String(repeating: "C", count: self.drop)
            } else {
                classString = (String)(self.drop - color.value) + String(repeating: "C", count: color.value)
            }
            colorDict[color.key] = classString
        }
        
        return colorDict
    }
    
}

struct Cards: Codable {
    
    var cards: [Card]
    
    enum CodingKeys: String, CodingKey {
        case cards = "data"
    }
    

}
