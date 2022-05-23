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
        /*let colorImage = (UIImage(named: pipTextToImageName[color] ?? color))
        let imageAttachment = NSTextAttachment(image: colorImage!)
        imageAttachment.bounds = pipImageBounds
        colorLabel.attributedText = NSAttributedString(attachment: imageAttachment)*/
        
        hasSourcesLabel.text = "Deck has sources: " + String(DeckController.shared.deck.numLandsForColor[color]!)
        needsSourcesLabel.text = "Deck needs sources " + String(getNumSources(from: DeckController.shared.deck.mostExpensiveCardForColor[color]!.colorClassDict()[color]!, numCardsInDeck: DeckController.shared.deck.numCardsMain))
    }
    
}
