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
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissMyKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //always set shared deck to new empty deck on load
        DeckController.shared.deck = Deck()
    }
    
    let fetchingAlert = UIAlertController(title: "Downloading card data...", message: "Card data should be downloaded by the time you finish reading this message!", preferredStyle: .alert)
    @IBOutlet weak var deckEntryTextView: UITextView!

    @IBOutlet weak var deckNameTextField: UITextField!
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let noDeckAlert = UIAlertController(title: "No Deck Entered", message: "Please enter a deck", preferredStyle: .alert)
        noDeckAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        let noDeckNameAlert = UIAlertController(title: "No Deck Name Entered", message: "Please enter a deck name", preferredStyle: .alert)
        noDeckNameAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        textLabel: if !deckEntryTextView.hasText {
            present(noDeckAlert, animated: true)
            return
        } else {
            do {
                //I don't hink buildDeckDicts needs to throw unless I want to catch more errors???
                try DeckController.shared.buildDeckDicts(with: deckEntryTextView.text)
            } catch DeckController.cardProcessError.noNumber {
                let noNumberAlert = UIAlertController(title: "Can't find # of cards", message: "Enter cards with number in front like: \n4 Counterspell", preferredStyle: .alert)
                noNumberAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(noNumberAlert, animated: true)
                return
            } catch {
                print("Generic Error")
                present(noDeckAlert, animated: true, completion: nil)
            }
        }
        
        if deckNameTextField.hasText {
            DeckController.shared.deck.name = deckNameTextField.text!
        } else {
            present(noDeckNameAlert, animated: true, completion: nil)
            return
        }
        
        self.present(self.fetchingAlert, animated: true)
        DeckController.shared.fetchCards(completion: { (cards) in
            self.dismiss(animated: true, completion: {
                self.segueToDrops(cards: cards)
            })
        })
    }
    
    @IBAction func copyButtonTapped(_ sender: UIBarButtonItem) {
        let noTextAlert = UIAlertController(title: "No text in clipboard", message: "Go get a deck!", preferredStyle: .alert)
        noTextAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        guard let deckText = UIPasteboard.general.string else {
            present(noTextAlert, animated: true)
            return
        }
        deckEntryTextView.text = deckText
        //if UIPasteboard.general.hasStrings {
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @objc func adjustForKeyboard (notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else {
            bottomConstraint.constant = keyboardViewEndFrame.height
        }
    }
    
    @objc func dismissMyKeyboard () {
        deckEntryTextView.endEditing(true)
        deckNameTextField.endEditing(true)
    }
    
    func segueToDrops (cards:[Card]) {
        do {
            try DeckController.shared.process(cards)
            DeckController.shared.setDropAndColors()
        } catch DeckController.cardGetError.couldNotFindCardError(let cardsNotFound) {
            var cardNames = String()
            for card in cardsNotFound {
                cardNames.append(card + "\n")
            }
            let cardNotFoundError = UIAlertController(title: "Could not find cards", message: "Could not find these cards on Scryfall: \n" + cardNames, preferredStyle: .alert)
            cardNotFoundError.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(cardNotFoundError, animated: true)
            return
        } catch {
            //generic error?
        }
        performSegue(withIdentifier: "setDropSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let setDropDestination = segue.destination as? SetDropTableViewController {
            
            setDropDestination.updateUI()
        }
    }*/

}
