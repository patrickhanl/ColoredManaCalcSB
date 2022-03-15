//
//  ManaDescriptionTableViewController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/22/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class ManaDescriptionTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DeckController.shared.setMostExpensiveCard()
        self.updateData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ManaDescriptionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    var colorArray: [String] = []
    var landArray: [Card] = []
    var spellArray: [Card] = []
    var spellArrayAZ = true
    var spellArrayLowHi = false
    
    struct headerData {
        var leftLabelText: String?
        var rightLabelText: String?
        var leftButtonText: String?
        var rightButtonText: String?
        
    }
    
    var header0: headerData = headerData(leftLabelText: "Most Expensive Card for Each Color")
    var header1: headerData = headerData(leftLabelText: "Color", rightLabelText: "Number of Sources")
    var header2: headerData = headerData(leftButtonText: "Card / Drop ", rightButtonText: "Sources to Cast on Curve ")
    
    
    func updateData() {
        for mtgColor in orderedColors {
            if (DeckController.shared.deck.mostExpensiveCardForColor.keys.contains(mtgColor)) {
                colorArray.append(mtgColor)
            }
        }
        self.landArray = DeckController.shared.deck.mainCardArray.filter({$0.typeLine.contains("Land")})
        self.spellArray = DeckController.shared.deck.mainCardArray.filter({!$0.typeLine.contains("Land")})
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return DeckController.shared.deck.mostExpensiveCardForColor.count
        case 1:
            return DeckController.shared.deck.colors.count
        case 2:
            return spellArray.count

        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! ManaDescriptionHeader
        
        switch section {
        case 0:
            headerView.update(with: header0)
            headerView.backgroundView = UIView()
        case 1:
            headerView.update(with: header1)
            headerView.backgroundView = UIView()
        case 2:
            headerView.update(with: header2)
            
            headerView.leftButton.addTarget(self, action: #selector(CDButtonSort), for: .touchUpInside)
            headerView.rightButton.addTarget(self, action: #selector(sourcesToCastButtonSort), for: .touchUpInside)
            headerView.backgroundView = UIView()
        default:
            headerView.rightLabel.text = "Header"
            
        }
        headerView.backgroundView?.backgroundColor = UIColor.opaqueSeparator
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            //MostExpensive Card Color and cell
            let color = colorArray[indexPath.row]
            
            let mostExpensiveCardDict = DeckController.shared.deck.mostExpensiveCardForColor
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "costCell", for: indexPath) as! MostExpensiveCardColorCell
            
            cell.update(with: color, card: mostExpensiveCardDict[color]!, num: String(DeckController.shared.deck.numLandsForColor[color]!))
            
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "colorCostCell", for: indexPath) as! ColorCostTableViewCell
            
            let color = colorArray[indexPath.row]
            cell.update(with: color)

        return cell
        
        case 2:
            let card = spellArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCostCell", for: indexPath) as! CardCostTableViewCell
            
            cell.update(with: card, spellArrayLowHi)
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        default:
            return 88.0
        }
    }
    
    @objc func CDButtonSort() {
        if (spellArrayAZ) {
            spellArray.sort(by: >)
            spellArrayAZ = false
            //header2.leftButtonText = "Card / Drop"
        } else {
            spellArray.sort(by: <)
            spellArrayAZ = true
            //header2.leftButtonText = "Card / Drop"
        }
        tableView.reloadData()
    }
    
    @objc func sourcesToCastButtonSort () {
        if (spellArrayLowHi) {
            spellArray.sort { lhs, rhs in
                let lhsSeparated = lhs.numSourcesPerColor(spellArrayLowHi).split(separator: " ")
                let rhsSeparated = rhs.numSourcesPerColor(spellArrayLowHi).split(separator: " ")
                
                guard let lhsInt = Int(lhsSeparated.first!) else {
                    return false
                }
                guard let rhsInt = Int(rhsSeparated.first!) else {
                    return true
                }
                if lhsInt == rhsInt {
                    return orderedColorsDict[String(lhsSeparated[1])]! < orderedColorsDict[String(rhsSeparated[1])]!
                }
                return lhsInt > rhsInt
            }
            //header2.rightButtonText = "Sources to Cast on Curve ^"
            spellArrayLowHi = false
        } else {
            spellArray.sort { lhs, rhs in
                let lhsSeparated = lhs.numSourcesPerColor(spellArrayLowHi).split(separator: " ")
                let rhsSeparated = rhs.numSourcesPerColor(spellArrayLowHi).split(separator: " ")
                
                guard let lhsInt = Int(lhs.numSourcesPerColor(spellArrayLowHi).split(separator: " ").first!) else {
                    return false
                }
                guard let rhsInt = Int(rhs.numSourcesPerColor(spellArrayLowHi).split(separator: " ").first!) else {
                    return true
                }
                if lhsInt == rhsInt {
                    return orderedColorsDict[String(lhsSeparated[1])]! < orderedColorsDict[String(rhsSeparated[1])]!
                }
                return lhsInt < rhsInt
            }
            //header2.rightButtonText = "Sources to Cast on Curve v"
            spellArrayLowHi = true
        }
        tableView.reloadData()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
