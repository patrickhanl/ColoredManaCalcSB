//
//  DeckEntryViewController.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/18/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class DeckEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deckEntryTextView.layer.borderWidth = 2.0
        deckEntryTextView.layer.borderColor = UIColor.lightGray.cgColor
        deckEntryTextView.layer.cornerRadius = 8
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var deckEntryTextView: UITextView!

    @IBOutlet weak var deckNameTextField: UITextField!
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let noDeckAlert = UIAlertController(title: "No Deck Entered", message: "Please enter a deck", preferredStyle: .alert)
        noDeckAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        let noDeckNameAlert = UIAlertController(title: "No Deck Name Entered", message: "Please enter a deck name", preferredStyle: .alert)
        noDeckNameAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        if deckEntryTextView.text == "" {present(noDeckAlert, animated: true, completion: nil) }
        
        do {
            try DeckController.shared.buildDeckDicts(with: deckEntryTextView.text)
            

        } catch {
            present(noDeckAlert, animated: true, completion: nil)
        }
        
        if deckNameTextField.hasText {
            DeckController.shared.deck.name = deckNameTextField.text!
        } else { present(noDeckNameAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func copyButtonTapped(_ sender: UIBarButtonItem) {
        if UIPasteboard.general.hasStrings {
            deckEntryTextView.text = UIPasteboard.general.string
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
