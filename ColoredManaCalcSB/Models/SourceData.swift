//
//  SourceData.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import Foundation
import UIKit

let sourceTableConstructed = ["0":0, "C":14, "1C":13, "CC":20, "2C":11, "1CC":18, "CCC":23, "3C":10, "2CC":16, "1CCC":20, "4C":9, "3CC":14, "2CCC":18, "5C":8, "4CC":13, "3CCC":16]

let sourceTableLimited = ["0":0, "C":14, "1C":13, "CC":20, "2C":11, "1CC":18, "CCC":23, "3C":10, "2CC":16, "1CCC":20, "4C":9, "3CC":14, "2CCC":18, "5C":8, "4CC":13, "3CCC":16]

func getNumSources (from colorCosts: String, numCardsInDeck: Int) -> Int {
    //I think this will work but needs num spells instead of num card? IDK
    if numCardsInDeck <= 59 {
        switch colorCosts {
        case "0":
            return 0
        case "5C":
            return 6
        case "4C":
            return 6
        case "3C":
            return 7
        case "2C":
            return 8
        case "1C", "4CC":
            return 9
        case "C", "3CC":
            return 10
        case "2CC", "3CCC":
            return 11
        case "1CC":
            return 12
        case "2CCC":
            return 13
        case "CC", "1CCC":
            return 14
        case "CCC":
            return 16
            
        default:
            return -1
            }
    } else if numCardsInDeck > 59 && numCardsInDeck < 100 {
        switch colorCosts {
        case "0":
            return 0
        case "5C":
            return 8
        case "4C":
            return 9
        case "3C":
            return 10
        case "2C":
            return 11
        case "1C", "4CC":
            return 13
        case "C", "3CC":
            return 14
        case "2CC", "3CCC":
            return 16
        case "1CC", "2CCC":
            return 18
        case "CC", "1CCC":
            return 20
        case "CCC":
            return 23
            
        default:
            return -1
            }
        }
    //add in commander here maybe later?
    return -1
}

let orderedColors:[String] = [
    "W",
    "W/P",
    "U",
    "U/P",
    "B",
    "B/P",
    "R",
    "R/P",
    "G",
    "G/P",
    "",
    "W/U",
    "W/B",
    "W/R",
    "W/R/P",
    "W/G",
    "W/G/P",
    "U/B",
    "U/B/P",
    "U/R",
    "U/R/P",
    "U/G",
    "U/G/P",
    "B/R",
    "B/R/P",
    "B/G",
    "B/G/P",
    "R/G",
    "R/G/P",
    "/W",
    "/U",
    "/B",
    "/R",
    "/G"
]

//might need an enum for ordered colors

let orderedColorsDict:[String:Int] = [
    "W":1,
    "W/P":2,
    "U":3,
    "U/P":4,
    "B":5,
    "B/P":6,
    "R":7,
    "R/P":8,
    "G":9,
    "G/P":10,
    "":11,
    "W/U":12,
    "W/B":13,
    "W/R":14,
    "W/R/P":15,
    "W/G":16,
    "W/G/P":17,
    "U/B":18,
    "U/B/P":19,
    "U/R":20,
    "U/R/P":21,
    "U/G":22,
    "U/G/P":23,
    "B/R":24,
    "B/R/P":25,
    "B/G":26,
    "B/G/P":27,
    "R/G":28,
    "R/G/P":29,
    "/W":30,
    "/U":31,
    "/B":32,
    "/R":33,
    "/G":34
]

let pipTextToImageName:[String:String] = [
    "":"C",
    "S":"S",
    "W/U":"WU",
    "W/B":"WB",
    "W/R":"WR",
    "W/G":"WG",
    "U/B":"UB",
    "U/R":"UR",
    "U/G":"UG",
    "B/R":"BR",
    "B/G":"BG",
    "R/G":"RB",
    "/W":"2W",
    "/U":"2U",
    "/B":"2B",
    "/R":"2R",
    "/G":"2G",
    "2/W":"2W",
    "2/U":"2U",
    "2/B":"2B",
    "2/R":"2R",
    "2/G":"2G",
    "W/P":"WP",
    "U/P":"UP",
    "B/P":"BP",
    "R/P":"RP",
    "G/P":"GP",
]

let pipImageBounds = CGRect(x: 0, y: -3, width: 15, height: 15)

/*enum colorCosts: String {
    case Zero = "0", C = "C", oneC = "1C", CC = "CC", twoC = "2C", oneCC = "1CC", CCC = "CCC", threeC = "3C", twoCC = "2CC", oneCCC = "1CCC", fourC = "4C", threeCC = "3CC", twoCCC = "2CCC", fiveC = "5C", fourCC = "4CC", threeCCC = "3CCC"
    
    
}*/
