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
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let noDeckAlert = UIAlertController(title: "No Deck Entered", message: "Please enter a deck", preferredStyle: .alert)
        noDeckAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        if deckEntryTextView.text == "" {present(noDeckAlert, animated: true, completion: nil) }
        
        do {
            try DeckController.shared.buildDeckDicts(with: deckEntryTextView.text)
            

        } catch {
            present(noDeckAlert, animated: true, completion: nil)
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
