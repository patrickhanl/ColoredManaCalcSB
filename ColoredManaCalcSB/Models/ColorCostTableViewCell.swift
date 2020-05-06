//
//  ColorCostTableViewCell.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 5/3/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class ColorCostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var hasSourcesLabel: UILabel!
    @IBOutlet weak var needsSourcesLabel: UILabel!
    
    func update(with color: String) {
        colorLabel.text = color
        hasSourcesLabel.text = "Deck has sources: " + String(DeckController.shared.deck.numLandsForColor[color]!)
        needsSourcesLabel.text = "Deck needs sources " + String(getNumSources(from: DeckController.shared.deck.mostExpensiveCardForColor[color]!.colorClassDict()[color]!))
    }
    
}
