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
    var hideTimer: Timer = Timer()
    let audioSession = AVAudioSession.sharedInstance()
    
    weak var volumeSlider : UISlider?
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
        
        self.isHidden = true
    }
    
    func setEvent() {
        addVolumeObserver()
    }
    
    func addVolumeObserver() {
        do {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.old, context: nil)
        } catch {
            print("Error")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume"{
            setVolumeProgressView(value: audioSession.outputVolume)
        }
    }
    
    func setVolumeProgressView(value: Float) {
        self.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }, completion: { (completion) in
        })
        
        guard let volumeSlider = volumeSlider else {
            return
        }
        
        volumeSlider.value = value
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
    
        
        setupHideTimer()
    }
    
    
    
    func updateProgressView(isVolumeAreaTouched: Bool, value: Float) {
        self.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }, completion: { (completion) in
        })
        
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
        
        setupHideTimer()
    }
    
    
    func setupHideTimer() {
        hideTimer.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                strongSelf.alpha = 0
            }, completion: { (completion) in
                strongSelf.isHidden = true
            })
            
            
        })
    }
    
    // MARK : - Event
    
    deinit {
        audioSession.removeObserver(self, forKeyPath: "outputVolume")
        
    }
}

