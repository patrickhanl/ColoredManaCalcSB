//
//  manaDescriptionHeader.swift
//  ColoredManaCalcSB
//
//  Created by Patrick Hanley on 4/3/21.
//  Copyright © 2021 Patrick Hanley. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class ManaDescriptionHeader: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    let leftButton: UIButton = UIButton()
    let rightButton: UIButton = UIButton()
    
    var buttonConfig = UIButton.Configuration.plain()
    
    let buttonImage = UIImage(systemName: "arrow.up.arrow.down.square") /*, withConfiguration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title2)))?.withTintColor(.foreground, renderingMode: .alwaysOriginal)*/
    
    func update(with data:ManaDescriptionTableViewController.headerData) {
        if(data.leftLabelText != nil) {
            leftLabel.isHidden = false
            leftButton.isHidden = true
            leftLabel.text = data.leftLabelText
        } else {
            leftLabel.isHidden = true
            leftButton.isHidden = false
            leftButton.setTitle(data.leftButtonText, for: .normal)
            //this causes an error here????
            //leftButton.addTarget(self, action: #selector(ManaDescriptionTableViewController.CDButtonSort), for: .touchUpInside)
}
        
        if(data.rightLabelText != nil) {
            rightLabel.isHidden = false
            rightButton.isHidden = true
            rightLabel.text = data.rightLabelText
        } else {
            rightLabel.isHidden = true
            if (data.rightButtonText == nil) {
                rightButton.isHidden = true
            } else {
                rightButton.isHidden = false
            }
            rightButton.setTitle(data.rightButtonText, for: .normal)
        }
    }
    
    func configureContents() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        
        buttonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(hierarchicalColor: UIColor.label)
        //buttonConfig.background.strokeColor = .label
        buttonConfig.image = buttonImage
        buttonConfig.imagePlacement = .trailing
        buttonConfig.titleTextAttributesTransformer  = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            
            outgoing.font = UIFont.preferredFont(forTextStyle: .body)
            outgoing.foregroundColor = UIColor.label
            return outgoing
        }
        
        leftButton.configuration = buttonConfig
        rightButton.configuration = buttonConfig
        
        NSLayoutConstraint.activate([
            leftLabel.heightAnchor.constraint(equalToConstant: 30),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                        
            rightLabel.heightAnchor.constraint(equalToConstant: 30),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            //rightLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            leftButton.heightAnchor.constraint(equalToConstant: 30),
            leftButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            leftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightButton.heightAnchor.constraint(equalToConstant: 30),
            rightButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            //rightButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
    }

}
