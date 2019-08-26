//
//  BrightnessSettingView.swift
//  VideoPlayer
//
//  Created by 이기완 on 25/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

enum SliderType: Int {
    case brightness
    case contrast
    case hue
    case saturation
    case gamma
}


protocol BrightnessSliderDelegate: class {
    func onSliderTouchDown(view :BrightnessSettingView, slider: UISlider)
    func onSliderValuedChanged(view :BrightnessSettingView, slider: UISlider)
    func onSliderTouchUpInside(view :BrightnessSettingView, slider: UISlider)

}




class BrightnessSettingView: UIView {
    
    var delegate: BrightnessSliderDelegate?
    
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var gammaSlider: UISlider!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
//        setUI()
//        setEvent()
        
        setConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
//        setUI()
        setConfiguration()
//        setEvent()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("BrightnessSettingView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    
    func setConfiguration() {
        let thumbImage = UIImage(named: "VGPlayer_ic_slider_thumb")
        let normalThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 15, height: 15))
        let highlightedThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 20, height: 20))
        
        brightnessSlider.tag = SliderType.brightness.rawValue
        
        brightnessSlider.minimumValue = 0.0
        brightnessSlider.maximumValue = 2.0
        brightnessSlider.value = 1.0
        brightnessSlider.setThumbImage(normalThumbImage, for: .normal)
        brightnessSlider.setThumbImage(highlightedThumbImage, for: .highlighted)
        
        // Contrast
        contrastSlider.tag = SliderType.contrast.rawValue
        contrastSlider.minimumValue = 0.0
        contrastSlider.maximumValue = 2.0
        contrastSlider.value = 1.0
        contrastSlider.setThumbImage(normalThumbImage, for: .normal)
        contrastSlider.setThumbImage(highlightedThumbImage, for: .highlighted)
        
        // hue
        hueSlider.tag = SliderType.hue.rawValue
        hueSlider.minimumValue = -180
        hueSlider.maximumValue = 180
        hueSlider.value = 0
        hueSlider.setThumbImage(normalThumbImage, for: .normal)
        hueSlider.setThumbImage(highlightedThumbImage, for: .highlighted)
        
        // saturation
        saturationSlider.tag = SliderType.saturation.rawValue
        saturationSlider.minimumValue = 0.0
        saturationSlider.maximumValue = 3.0
        saturationSlider.value = 1.0
        saturationSlider.setThumbImage(normalThumbImage, for: .normal)
        saturationSlider.setThumbImage(highlightedThumbImage, for: .highlighted)
        
        // gamma
        gammaSlider.tag = SliderType.gamma.rawValue
        gammaSlider.minimumValue = 0.0
        gammaSlider.maximumValue = 10.0
        gammaSlider.value = 1.0
        gammaSlider.setThumbImage(normalThumbImage, for: .normal)
        gammaSlider.setThumbImage(highlightedThumbImage, for: .highlighted)
    }
    
    
    // MARK: - Event
    
    @IBAction func onSliderTouchDown(_ sender: UISlider) {
        delegate?.onSliderTouchDown(view: self, slider: sender)
    }
    
    @IBAction func onSliderValuedChanged(_ sender: UISlider) {
        delegate?.onSliderValuedChanged(view: self, slider: sender)
    }
    
    @IBAction func onSliderTouchUpInside(_ sender: UISlider) {
        delegate?.onSliderTouchUpInside(view: self, slider: sender)
    }
    
}
