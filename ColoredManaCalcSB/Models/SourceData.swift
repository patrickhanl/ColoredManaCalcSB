//
//  SourceData.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import Foundation

let sourceTable = ["0":0, "C":14, "1C":13, "CC":20, "2C":11, "1CC":18, "CCC":23, "3C":10, "2CC":16, "1CCC":20, "4C":9, "3CC":14, "2CCC":18, "5C":8, "4CC":13, "3CCC":16]

func getNumSources (from colorCosts: String) -> Int {
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

/*enum colorCosts: String {
    case Zero = "0", C = "C", oneC = "1C", CC = "CC", twoC = "2C", oneCC = "1CC", CCC = "CCC", threeC = "3C", twoCC = "2CC", oneCCC = "1CCC", fourC = "4C", threeCC = "3CC", twoCCC = "2CCC", fiveC = "5C", fourCC = "4CC", threeCCC = "3CCC"
    
    
}*/
