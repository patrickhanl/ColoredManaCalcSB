//
//  MostExpensiveCardColorCell.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 3/21/21.
//  Copyright © 2021 Patrick Hanley. All rights reserved.
//

import UIKit

class MostExpensiveCardColorCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    func update (with color: String, card: Card, num: String) {
        cardLabel.text = "The most expensive \(color) card you have is \(card.name)  (\(card.manaCost))."
        costLabel.text = "To cast it on turn \(card.drop), you need \(getNumSources(from: card.colorClassDict()[color]!)) \(color) sources. You have \(num) \(color) sources"
    }

}
