//
//  StepperTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/13.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

protocol StepperCellDelegate: class {
//    func sliderCellValueChanged(cell: SliderTableViewCell)
}

class StepperTableViewCell: UITableViewCell {
    
    weak var delegate: StepperCellDelegate?
    
    var data: VideoConfigObject? {
        didSet {
            titleLabel.text = data!.title
            subTitleLabel.text = data!.subTitle
            
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onStepperValueChanged(_ sender: UIStepper) {
        
    }
}
