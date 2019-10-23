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
//
//    weak var videoView: VideoView?
//
//    var player: AVPlayer? {
//        didSet {
//            self.addPlayerObserver()
//        }
//    }
//
//    @IBOutlet weak var playOrPauseButton: UIButton!
//    @IBOutlet weak var currentTimeLabel: UILabel!
//    @IBOutlet weak var totalTimeLabel: UILabel!
//    @IBOutlet weak var sliderView: UISlider!
//
//    @IBOutlet weak var changeModeButton: UIButton!
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setNib()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setNib()
//    }
//
//    func setNib() {
//        let view = Bundle.main.loadNibNamed("VideoControllerView", owner: self, options: nil)?.first as! UIView
//        view.frame = self.bounds
//        self.addSubview(view)
//    }
//
//    func goosetUI() {
//
//    }
//
//
//    func addPlayerObserver() {
//
//        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main, using: { (time) in
//
//            if self.player!.currentItem?.status == .readyToPlay {
//                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
//                self.updateCurrentTimeText(currentTime: currentTime)
//                self.updateTotalTimeText()
//            }
//
//        })
//    }
//
//
//    //MARK: - Seek Bar
//
//    func updateCurrentTimeText(currentTime: Float64) {
//        let secs = Int(currentTime)
//        self.currentTimeLabel.text = NSString(format: "%02d:%02d", secs / 60, secs % 60) as String
//        self.sliderView.value = Float(secs)
//    }
//
//    func updateTotalTimeText() {
//        let secs = Int((self.player?.currentItem?.duration.seconds)!)
//        self.totalTimeLabel.text = NSString(format: "%02d:%02d", secs / 60, secs % 60) as String
//        self.sliderView.maximumValue = Float(secs)
//    }
//
//    @IBAction func playbackSliderValueChanged(_ playbackSlider: UISlider) {
//        let seconds : Int64 = Int64(playbackSlider.value)
//        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//
//        player!.seek(to: targetTime)
//
//        if player!.rate == 0 {
//            player?.play()
//        }
//    }
//
//    // MARK: - Play & Pause & Skip Event
//
//    @IBAction func onPlayOrPauseTouched(_ sender: UIButton) {
//        if(self.player!.isPlaying) {
//            self.player?.pause()
//            self.playOrPauseButton.setImage(UIImage(named: "mPlay"), for: .normal)
//        }
//        else {
//            self.player?.play()
//            self.playOrPauseButton.setImage(UIImage(named: "mStop"), for: .normal)
//        }
//    }
//
//
//    fileprivate let seekDuration: Float64 = 5
//
//    @IBAction func onSkipBackwardTouched(_ sender: UIButton) {
//
//        let playerCurrentTime = CMTimeGetSeconds(self.player!.currentTime())             // 24.015901193
//
//        let seekTime = Int(playerCurrentTime - seekDuration)        // 19
//        let backwardTime: CMTime = CMTimeMake(value: Int64(seekTime * 1000), timescale: 1000)
//        player?.seek(to: backwardTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//
//    }
//
//    @IBAction func onSkipForwardTouched(_ sender: UIButton) {
//        if let player = self.player {
//            guard let duration = player.currentItem?.duration else {
//                return
//            }
//
//            let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
//            let newTime = playerCurrentTime + seekDuration
//            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
//            player.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//        }
//    }
//
//
//    // MODE Change
//
//    @IBAction func onChangeModeTouched(_ sender: UIButton) {
//        if !player!.isPlaying {
//            return
//        }
//
//        if videoView?.playMode == .videoMode {
//            videoView?.playAudioMode()
//        }
//        else {
//            videoView?.playVideoMode()
//        }
//    }
//

}

