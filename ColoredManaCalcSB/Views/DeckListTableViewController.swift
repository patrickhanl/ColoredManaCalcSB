//
//  DeckListTableViewController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class DeckListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DeckController.shared.deck = Deck()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DeckController.shared.deckList.count
    }
    
    func updateUI () {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func unwindToDecks(unwindSegue: UIStoryboardSegue) {
        DeckController.shared.deckList.append(DeckController.shared.deck)
        DeckController.shared.saveDecks()
        self.updateUI()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckListCell", for: indexPath)

        cell.textLabel?.text = DeckController.shared.deckList[indexPath.row].name
        
        cell.detailTextLabel?.text = DeckController.shared.deckList[indexPath.row].colors.joined()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DeckController.shared.deck = DeckController.shared.deckList[indexPath.row]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DeckController.shared.deckList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DeckController.shared.saveDecks()
            
        }
        /*} else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
    }*/

}
