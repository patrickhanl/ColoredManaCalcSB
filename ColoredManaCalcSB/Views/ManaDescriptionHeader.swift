//
//  manaDescriptionHeader.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/3/21.
//  Copyright © 2021 Patrick Hanley. All rights reserved.
//

import UIKit

class ManaDescriptionHeader: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    /*override var self.backgroundView: UIView? {
        get {

        }
    }*/
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            leftLabel.heightAnchor.constraint(equalToConstant: 30),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                        
            rightLabel.heightAnchor.constraint(equalToConstant: 30),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            //rightLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

}
