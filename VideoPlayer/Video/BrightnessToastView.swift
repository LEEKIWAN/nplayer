//
//  BrightnessToastView.swift
//  VideoPlayer
//
//  Created by kiwan on 27/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import MediaPlayer

class BrightnessToastView: UIView {
    
    var volumeView: MPVolumeView = MPVolumeView(frame: .zero)
    var volumeSlider : UISlider?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progoressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
        setUI()
        setEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
        setUI()
        setEvent()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("BrightnessToastView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {
        self.layer.cornerRadius = self.bounds.height / 2
        progoressView.progressTintColor = UIColor.white
        progoressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.4)
        volumeView.clipsToBounds = true
        
        volumeSlider = volumeView.subviews.first as? UISlider
        self.addSubview(volumeView)
        
    }
    
    func setEvent() {
        
    }
    
    func updateProgressView(isVolumeAreaTouched: Bool, value: Float) {
        
        if isVolumeAreaTouched {
            guard let volumeSlider = volumeSlider else {
                return
            }
            
            volumeSlider.value -= value
            progoressView.setProgress(volumeSlider.value, animated: false)
            
            if volumeSlider.value == 0 {
                imageView.setImage(UIImage(named: "ZFPlayer_muted")!)
            }
            else if volumeSlider.value < 0.5 {
                imageView.setImage(UIImage(named: "ZFPlayer_volume_low")!)
            }
            
            else {
                imageView.setImage(UIImage(named: "ZFPlayer_volume_high")!)
            }
            
        }
        else {
            UIScreen.main.brightness -= CGFloat(value)
            progoressView.setProgress(Float(UIScreen.main.brightness), animated: false)
            
            if UIScreen.main.brightness >= 0.5 {
                imageView.setImage(UIImage(named: "ZFPlayer_brightness_high")!)
            }
            else {
                imageView.setImage(UIImage(named: "ZFPlayer_brightness_low")!)
            }
            
        }
        
//        UIScreen.main.brightness -= value
        
    }
    
    // MARK : - Event
    
}

