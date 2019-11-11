//
//  TextTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/11.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    var data: VideoConfigObject? {
        didSet {
            titleLabel.text = data!.title
            subTitleLabel.text = data!.subTitle
            selectedValue.text = data!.selectedValue
            
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var selectedValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
