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
    
    
    func update (with color: String, /*images colorImage: UIImage,*/ card: Card, num: String) {
        let colorImage = NSTextAttachment()
        colorImage.image = UIImage(named: pipTextToImageName[color] ?? color)
        colorImage.bounds = pipImageBounds
        
        let cardLabelText = NSMutableAttributedString(string: "The most expensive ")
        cardLabelText.append(NSAttributedString(attachment: colorImage))
        cardLabelText.append(NSAttributedString(string: " card you have is \(card.name) ("))
        
        let mod_str = card.manaCost.replacingOccurrences(of: "{", with: "")
        let pips = mod_str.components(separatedBy: "}").filter({$0 != ""})
        
        for pip in pips {
            let pipImage = NSTextAttachment()
            pipImage.image = UIImage(named: pipTextToImageName[pip] != nil ? pipTextToImageName[pip]! : pip)
            //maybe you can set height programatically???
            pipImage.bounds = pipImageBounds
            cardLabelText.append(NSAttributedString(attachment: pipImage))
        }
        
        cardLabelText.append(NSAttributedString(string: ")"))
        cardLabel.attributedText = cardLabelText
        
        let numSources = getNumSources(from: card.colorClassDict()[color]!, format: DeckController.shared.sharedDeckSection)
        
        if numSources >= 0 {
            let costLabelText = NSMutableAttributedString(string: "To cast it on turn \(card.drop), you need \(numSources) ")
        
            costLabelText.append(NSAttributedString(attachment: colorImage))
            costLabelText.append(NSAttributedString(string: " sources. You have \(num) "))
            costLabelText.append(NSAttributedString(attachment: colorImage))
            costLabelText.append(NSAttributedString(string: " sources."))
            
            costLabel.attributedText = costLabelText
        } else {
            costLabel.text = "Due to the colored mana requirement, you will probably not be able to cast this card on curve."
        }
    }
}
