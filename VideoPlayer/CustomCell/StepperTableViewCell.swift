//
//  StepperTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/13.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

protocol StepperCellDelegate: class {
    func stepperCellValueChanged(cell: StepperTableViewCell)
}

class StepperTableViewCell: UITableViewCell {
    
    weak var delegate: StepperCellDelegate?
    
    var data: VideoConfigObject? {
        didSet {
            titleLabel.text = data!.title
            subTitleLabel.text = data!.subTitle
            
            if data?.title == "지연" {
                stepper.maximumValue = 1000
                stepper.minimumValue = -1000
                stepper.stepValue = 0.1
            }
            else {
                stepper.maximumValue = 50
                stepper.minimumValue = 1
                stepper.stepValue = 1
            }
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
        if data?.title == "지연" {
            let value = sender.value
            let valueString = String(format: "%.2f", value)
            subTitleLabel.text = valueString
            data?.selectedValue = valueString
            delegate?.stepperCellValueChanged(cell: self)
        }
        else {
            let value = sender.value
            let valueString = String(format: "%.0f", value)
            subTitleLabel.text = valueString
            data?.selectedValue = valueString
            delegate?.stepperCellValueChanged(cell: self)
        }
    }
}
