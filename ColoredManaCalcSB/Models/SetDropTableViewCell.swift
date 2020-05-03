//
//  SetDropTableViewCell.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/22/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class SetDropTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var dropLabel: UILabel!
    
    @IBOutlet weak var dropStepperValue: UIStepper!
    
    
    @IBAction func dropStepper(_ sender: UIStepper) {
        dropLabel.text = String(Int(dropStepperValue.value))
        for index in 0..<DeckController.shared.deck.mainCardArray.count {
            if DeckController.shared.deck.mainCardArray[index].name == cardName.text{
                DeckController.shared.deck.mainCardArray[index].drop = Int(dropStepperValue.value)
            }
        }
    }
    
    func update (with card:Card) {
        cardName.text = card.name
        dropStepperValue.value = Double(card.drop)
        dropLabel.text = String(card.drop)
    }

}
