//
//  PlayItemTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class PlayItemTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalPlayTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
