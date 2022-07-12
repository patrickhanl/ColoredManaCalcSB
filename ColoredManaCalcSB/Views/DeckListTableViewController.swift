//
//  DeckListTableViewController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/16/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class DeckListTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // section for each deck size (ltd, std, cmdr)
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DeckController.shared.sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // num of rows in each section = num of decks saved for that format
        switch section {
        case 0:
            return DeckController.shared.sixtyCardDeckList.count > 0 ? DeckController.shared.sixtyCardDeckList.count : 1
        case 1:
            return DeckController.shared.hundredCardDeckList.count > 0 ? DeckController.shared.hundredCardDeckList.count : 1
        case 2:
            return DeckController.shared.fortyCardDeckList.count > 0 ? DeckController.shared.fortyCardDeckList.count : 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckListCell", for: indexPath)
        
        //each cell is a deck, if no decks tell user to add deck
        
        cell.textLabel?.text = "No decks, tap \"+\" to add a deck"
        cell.detailTextLabel?.text = ""
        
        
        switch indexPath.section {
        case 0:
            //like all the shit in these cases should be in an update class or at least a method
            if DeckController.shared.sixtyCardDeckList.count > 0 {
                cell.textLabel?.text = DeckController.shared.sixtyCardDeckList[indexPath.row].name
                let pipImages = NSMutableAttributedString()
                for color in DeckController.shared.sixtyCardDeckList[indexPath.row].colors {
                    let pipImage = UIImage(named: pipTextToImageName[color] ?? color)
                    let pipAttachment = NSTextAttachment(image: pipImage!)
                    pipAttachment.bounds = pipImageBounds
                    pipImages.append(NSAttributedString(attachment: pipAttachment))
                }
                cell.detailTextLabel?.attributedText = pipImages
            } else {
                cell.isUserInteractionEnabled = false
            }
            
        case 1:
            if DeckController.shared.hundredCardDeckList.count > 0 {
                cell.textLabel?.text = DeckController.shared.hundredCardDeckList[indexPath.row].name
                let pipImages = NSMutableAttributedString()
                for color in DeckController.shared.hundredCardDeckList[indexPath.row].colors {
                    let pipImage = UIImage(named: pipTextToImageName[color] ?? color)
                    let pipAttachment = NSTextAttachment(image: pipImage!)
                    pipAttachment.bounds = pipImageBounds
                    pipImages.append(NSAttributedString(attachment: pipAttachment))
                }
                cell.detailTextLabel?.attributedText = pipImages
            } else {
                cell.isUserInteractionEnabled = false
            }
            
        case 2:
            if DeckController.shared.fortyCardDeckList.count > 0 {
                cell.textLabel?.text = DeckController.shared.fortyCardDeckList[indexPath.row].name
                let pipImages = NSMutableAttributedString()
                for color in DeckController.shared.fortyCardDeckList[indexPath.row].colors {
                    let pipImage = UIImage(named: pipTextToImageName[color] ?? color)
                    let pipAttachment = NSTextAttachment(image: pipImage!)
                    pipAttachment.bounds = pipImageBounds
                    pipImages.append(NSAttributedString(attachment: pipAttachment))
                }
                cell.detailTextLabel?.attributedText = pipImages
            } else {
                cell.isUserInteractionEnabled = false
            }
            
        default:
            cell.textLabel?.text = "Error"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tap the cell, load the deck, go to Mana Description scene
        DeckController.shared.sharedDeckSection = indexPath.section
        DeckController.shared.sharedDeckRow = indexPath.row
        switch indexPath.section {
        case 0:
            DeckController.shared.deck = DeckController.shared.sixtyCardDeckList[indexPath.row]
        case 1:
            DeckController.shared.deck = DeckController.shared.hundredCardDeckList[indexPath.row]
        case 2:
            DeckController.shared.deck = DeckController.shared.fortyCardDeckList[indexPath.row]
        default:
            DeckController.shared.deck = Deck()
        }

    }
    
    func updateUI () {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindToDecks(unwindSegue: UIStoryboardSegue) {
        let formatNum = DeckController.shared.sharedDeckSection
        let rowNum = DeckController.shared.sharedDeckRow
        
        if formatNum >= 0 && rowNum >= 0 {
            switch formatNum {
            case 0:
                DeckController.shared.sixtyCardDeckList[rowNum] = DeckController.shared.deck
            case 1:
                DeckController.shared.hundredCardDeckList[rowNum] = DeckController.shared.deck
            case 2:
                DeckController.shared.fortyCardDeckList[rowNum] = DeckController.shared.deck
            default:
                print("ERROR, DECK SECTION OUT OF BOUNDS")
            }
            
        } else {
            switch formatNum {
            case 0:
                DeckController.shared.sixtyCardDeckList.append(DeckController.shared.deck)
            case 1:
                DeckController.shared.hundredCardDeckList.append(DeckController.shared.deck)
            case 2:
                DeckController.shared.fortyCardDeckList.append(DeckController.shared.deck)
            default:
                print("ERROR, DECK SECTION OUT OF BOUNDS")
            }
        }
        
        DeckController.shared.sharedDeckSection = -1
        DeckController.shared.sharedDeckSection = -1
        DeckController.shared.saveDecks()
        self.updateUI()
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
            if indexPath.section == 0 {
            // Delete the row from the data source
            //add in 100 card here
                DeckController.shared.sixtyCardDeckList.remove(at: indexPath.row)
            } else {
                DeckController.shared.fortyCardDeckList.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            DeckController.shared.saveDecks()
            
        }
        /*} else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var actions = [UIAlertAction]()
        for formatIndex in 0..<DeckController.shared.sectionTitles.count {
            let newAction = UIAlertAction(title: DeckController.shared.sectionTitles[formatIndex], style: .default/*, handler: showEntrySegue*/) { (action) in
                self.performSegue(withIdentifier: "deckEntrySegue", sender: nil)
                DeckController.shared.sharedDeckSection = formatIndex                
            }
            actions.append(newAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actions.append(cancelAction)
        
        let formatChoiceAlert = UIAlertController(title: "Choose Deck Format", message: "The format is used to calculate the number of lands needed to draw sufficient colored sources to cast a card on the earliest turn possible based on the minimum number of cards in the deck.", preferredStyle: .actionSheet)
        
        for action in actions {
            formatChoiceAlert.addAction(action)
        }
        
            self.present(formatChoiceAlert, animated: true)
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

}
