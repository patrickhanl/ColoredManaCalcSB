//
//  CardCostTableViewCell.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 5/1/20.
//  Copyright © 2020 Patrick Hanley. All rights reserved.
//

import UIKit

class CardCostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var toCastCardName: UILabel!
    @IBOutlet weak var youNeedSources: UILabel!
    
    func update(with card: Card, _ sortLowHi: Bool) {
        toCastCardName.text = "To cast \(card.name) on turn \(card.drop), you need:"
        let toCastText = NSMutableAttributedString(string: "")
        for line in card.numSourcesPerColor(!sortLowHi) {
            if line.firstIndex(of: "T") != nil {
                toCastText.append(NSAttributedString(string: line))
            } else {
                let lineArray = line.components(separatedBy: " ")
                let toCastLine = NSMutableAttributedString(string: lineArray[0] + " ")
                let pipImage = UIImage(named: pipTextToImageName[lineArray[1]] ?? lineArray[1])
                let pipAttachment = NSTextAttachment(image: pipImage!)
                pipAttachment.bounds = pipImageBounds
                toCastLine.append(NSAttributedString(attachment: pipAttachment))
                toCastLine.append(NSAttributedString(string: " " + lineArray[2]))
                toCastText.append(toCastLine)
            }
        }
        youNeedSources.attributedText = toCastText
    }

}
