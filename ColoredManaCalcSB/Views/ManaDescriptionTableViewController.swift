//
//  ManaDescriptionTableViewController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/22/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class ManaDescriptionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ManaDescriptionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        self.updateData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    var colorArray: [String] = []
    var landArray: [Card] = []
    var spellArray: [Card] = []
    
    func updateData() {
        self.colorArray = Array(DeckController.shared.deck.mostExpensiveCardForColor.keys)
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
        case 1:
            return DeckController.shared.deck.colors.count
        case 2:
            return spellArray.count
        case 0:
            return DeckController.shared.deck.mostExpensiveCardForColor.count
            
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! ManaDescriptionHeader
        
        switch section {
        case 0:
            headerView.leftLabel.text = "Most Expensive Card for Each Color"
            headerView.rightLabel.text = ""
            headerView.backgroundView = UIView()
        case 1:
            headerView.leftLabel.text = "Color"
            headerView.rightLabel.text = "Number of Sources"
            headerView.backgroundView = UIView()
        case 2:
            headerView.leftLabel.text = "Card / Drop"
            headerView.rightLabel.text = "Sources to Cast on Curve"
            headerView.backgroundView = UIView()
        default:
            headerView.leftLabel.text = "Header"
            
        }
        headerView.backgroundView?.backgroundColor = UIColor.opaqueSeparator
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "colorCostCell", for: indexPath) as! ColorCostTableViewCell

            // Configure the cell...
            
            let color = colorArray[indexPath.row]
            cell.update(with: color)

        return cell
        
        case 2:
            let card = spellArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCostCell", for: indexPath) as! CardCostTableViewCell
            
            cell.update(with: card)
            
            return cell
        
        case 0:
            //MostExpensive Card Color and cell
            let color = colorArray[indexPath.row]
            
            let mostExpensiveCardDict = DeckController.shared.deck.mostExpensiveCardForColor
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "costCell", for: indexPath) as! MostExpensiveCardColorCell
            
            cell.update(with: color, card: mostExpensiveCardDict[color]!, num: String(DeckController.shared.deck.numLandsForColor[color]!))
            
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
