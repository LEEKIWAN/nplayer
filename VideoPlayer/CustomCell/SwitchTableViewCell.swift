
//
//  SwitchTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/11.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func switchCellValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {

    weak var delegate: SwitchCellDelegate?
    
    var data: VideoConfigObject? {
        didSet {
            titleLabel.text = data!.title
            self.switch.isOn = data!.switchIsOn            
            
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        delegate?.switchCellValueChanged(cell: self)
    }
}
