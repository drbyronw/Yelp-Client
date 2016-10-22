//
//  SwitchCell.swift
//  YelpClient
//
//  Created by Byron J. Williams on 10/21/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool)
    
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: UIControlEvents.valueChanged)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged() {
//        print("Switch Value Changed")
        if delegate != nil {
            delegate?.switchCell!(self, didChangeValue: onSwitch.isOn)
        }
    }
}
