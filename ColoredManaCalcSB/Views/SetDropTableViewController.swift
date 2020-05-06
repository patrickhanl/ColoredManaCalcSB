//
//  SetDropTableViewController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/21/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class SetDropTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DeckController.shared.fetchCards(completion: self.updateUI)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var count = 0
        
        for card in DeckController.shared.deck.mainCardArray {
            if !card.typeLine.contains("Land") {
                count += 1
            }
        }
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setDropCell", for: indexPath) as! SetDropTableViewCell
        
        var nonLandCards: [Card] = []
        
        for index in 0..<DeckController.shared.deck.mainCardArray.count {
            if !DeckController.shared.deck.mainCardArray[index].typeLine.contains("Land") {
                DeckController.shared.deck.mainCardArray[index].setDrop()
                nonLandCards.append(DeckController.shared.deck.mainCardArray[index])
            }
        }
        
        let card = nonLandCards[indexPath.row]
        
        cell.update(with: card)

        return cell
    }
    
    func updateUI () {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func manaButton(_ sender: UIButton) {
        print(DeckController.shared.deck.numLandsForColor)
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
