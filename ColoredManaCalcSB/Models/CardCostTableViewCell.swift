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
        youNeedSources.text = card.numSourcesPerColor(!sortLowHi)
    }

}
