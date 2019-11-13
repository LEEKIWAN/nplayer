//SliderTableViewCell
//  SlideTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/13.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

protocol SliderCellDelegate: class {
    func sliderCellValueChanged(cell: SliderTableViewCell)
}

class SliderTableViewCell: UITableViewCell {

    weak var delegate: SliderCellDelegate?
    
    var data: VideoConfigObject? {
        didSet {
            titleLabel.text = data!.title
            slider.value = (data!.selectedValue as NSString).floatValue
            percentageLabel.text = "\(Int(slider.value) * 5 + 100)%"
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Slider
    @IBAction func onSliderValueChagned(_ sender: UISlider) {
        if data?.selectedValue != "\(Int(sender.value))" {
            data?.selectedValue = "\(Int(sender.value))"
            let value = Int(sender.value) * 5 + 100
            percentageLabel.text = "\(value)%"
            
            
            
            delegate?.sliderCellValueChanged(cell: self)
        }
    }
    
}
