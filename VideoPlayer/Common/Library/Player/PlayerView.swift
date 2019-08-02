//
//  PlayerView.swift
//  VideoPlayer
//
//  Created by kiwan on 01/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation


public protocol VGPlayerViewDelegate: class {
    
//    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen isFullscreen: Bool)
//    
//    func vgPlayerView(didTappedClose playerView: VGPlayerView)
//    
//    func vgPlayerView(didDisplayControl playerView: VGPlayerView)
}


open class PlayerView: UIView {

    @IBOutlet var view: UIView!    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!    
    @IBOutlet weak var timeSlider: PlayerSlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replayButton: UIButton!
    
    
    var player: Player?
    var controlViewDuration: TimeInterval = 5.0
    var playerLayer : AVPlayerLayer?
    var isFullScreen: Bool = false
    var isTimeSliding: Bool = false
    var isDisplayControl: Bool = true {
        didSet {
            if isDisplayControl != oldValue {
                
            }
        }
    }
    
    var timer: Timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
//        setInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
//        setInit()
    }
    
    func setNib() {
        view = (Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! UIView)
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateDisplayView(frame: bounds)
    }
    
    
    open func reloadPlayerView() {
        playerLayer = AVPlayerLayer(player: nil)
        reloadPlayerLayer()
    }
    
    open func reloadPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player?.player)
        self.view.layer.insertSublayer(playerLayer!, below: bottomView.layer)
        updateDisplayView(frame: bounds)
        timeSlider.isUserInteractionEnabled = player?.mediaFormat != .m3u8
        self.reloadGravity()
    }
    
    open func reloadGravity() {
        guard let player = player else { return }
        
        switch player.gravityMode {
            case .resize:
                playerLayer?.videoGravity = .resize
            case .resizeAspect:
                playerLayer?.videoGravity = .resizeAspect
            case .resizeAspectFill:
                playerLayer?.videoGravity = .resizeAspectFill
            default:
                break
        }
    }
    
    // MARK: - called by change Player Value
    
    open func playStateDidChange(_ state: PlayerState) {
        playButton.isSelected = state == .playing
        replayButton.isHidden = !(state == .playFinished)
        
        if state == .playing || state == .playFinished {
            setupTimer()
        }
        
        if state == .playFinished {
            
        }
    }
    
    open func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        var current = formatSecondsToString(currentDuration)
        if totalDuration.isNaN {  // HLS
            current = "00:00"
        }
        if !isTimeSliding {
            timeLabel.text = "\(current + " / " +  (formatSecondsToString(totalDuration)))"
            timeSlider.value = Float(currentDuration / totalDuration)
        }
    }
    
    
    open func bufferStateDidChange(_ state: PlayerBufferState) {
        if state == .buffering {
            
        }
        else {
            
        }
        var current = formatSecondsToString(player!.currentDuration)
        if (player?.totalDuration.isNaN)! {
            current = "00:00"
        }
        
        if state == .readyToPlay && !isTimeSliding {
            timeLabel.text = "\(current + " / " +  (formatSecondsToString((player?.totalDuration)!)))"
        }
    }
    
    open func bufferedDidChange(_ bufferedDuration: TimeInterval, totalDuration: TimeInterval) {
        timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: true)
    }
    
    
    internal func setupTimer() {
        timer.invalidate()
//        timer = Timer.
    }
    

    // MARK: - public
    
    open func updateDisplayView(frame: CGRect) {
        playerLayer?.frame = frame
    }
    
    
    open func play() {
//        player?.play()
    }
    
    
    
    
    
    
    
    //MARK: - Player Delegate
    
    
    public func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN{
            return "00:00"
        }
        let interval = Int(seconds)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = interval / 60
        return String(format: "%02d:%02d", min, sec)
    }
    
}
