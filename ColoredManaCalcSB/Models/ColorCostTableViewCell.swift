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
    
    @IBOutlet weak var hasSourcesLabel: UILabel!
    @IBOutlet weak var needsSourcesLabel: UILabel!
    
    @IBOutlet weak var bigPipImage: UIImageView!
    
    
    func update(with color: String) {
        bigPipImage.image = (UIImage(named: pipTextToImageName[color] ?? color))
        
        hasSourcesLabel.text = "Deck has sources: " + String(DeckController.shared.deck.numLandsForColor[color]!)
        
        let sources = getNumSources(from: DeckController.shared.deck.mostExpensiveCardForColor[color]!.colorClassDict()[color]!, format: DeckController.shared.sharedDeckSection)
        
        if sources >= 0 {
            needsSourcesLabel.text = "Deck needs sources " + String(sources)
        } else {
            needsSourcesLabel.text = "Deck needs too many sources to reliably cast on curve"
        }
    }
    
}
