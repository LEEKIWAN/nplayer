//
//  VideoControllerView.swift
//  VideoPlayer
//
//  Created by kiwan on 03/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation

class VideoControllerView: UIView {
    
    var player: AVPlayer? {
        didSet {
            self.addPlayerObserver()
        }
    }
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("VideoControllerView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {
        
    }
    
    
    func addPlayerObserver() {
        
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main, using: { (time) in
            
            if self.player!.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                self.updateCurrentTimeText(currentTime: currentTime)
                self.updateTotalTimeText()
            }
            
        })
    }
    
    
    func updateCurrentTimeText(currentTime: Float64) {
        let secs = Int(currentTime)
        self.currentTimeLabel.text = NSString(format: "%02d:%02d", secs / 60, secs % 60) as String
        self.sliderView.value = Float(secs)
    }
    
    func updateTotalTimeText() {
        let secs = Int((self.player?.currentItem?.duration.seconds)!)
        self.totalTimeLabel.text = NSString(format: "%02d:%02d", secs / 60, secs % 60) as String
        self.sliderView.maximumValue = Float(secs)
        
    }
    
    
    @IBAction func onPauseTouched(_ sender: UIButton) {
        if(self.player!.isPlaying) {
            self.player?.pause()
        }
        else {
            self.player?.play()
        }
    }
    
    
    fileprivate let seekDuration: Float64 = 5
    
    @IBAction func onSkipForwardTouched(_ sender: UIButton) {
        if let player = self.player {
            guard let duration = player.currentItem?.duration else {
                return
            }
            let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
            let newTime = playerCurrentTime + seekDuration
            
//            if newTime < (CMTimeGetSeconds(duration)) {
            
                let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//            }
//            else {
//                let time2: CMTime = CMTimeMake(duration)
//                player.seek(to: time2)
//            }
        }
    }
    
    @IBAction func onSkipBackwardTouched(_ sender: UIButton) {
    
        let playerCurrentTime = CMTimeGetSeconds(self.player!.currentTime())
        let seekTime = Int(playerCurrentTime - seekDuration)
    
        let time2: CMTime = CMTimeMake(value: Int64(seekTime * 1000), timescale: 1000)
        
        
        print("\(time2)")
//        player?.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.seek(to: time2)
    
    }
    
    
    @IBAction func playbackSliderValueChanged(_ playbackSlider: UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0 {
            player?.play()
        }
    }
    
}

