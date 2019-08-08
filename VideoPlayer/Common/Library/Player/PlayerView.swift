//
//  PlayerView.swift
//  VideoPlayer
//
//  Created by kiwan on 01/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation


enum PanGestureDirection {
    case vertical
    case horizontal
}


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
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replayButton: UIButton!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var player: Player?
    var controlViewDuration: TimeInterval = 3.5
    var playerLayer: AVPlayerLayer?
    var isFullScreen: Bool = false
    var isTimeSliding: Bool = false
    var isDisplayControl: Bool = true {
        didSet {
            if isDisplayControl != oldValue {
                
            }
        }
    }
    
    var timer: Timer = Timer()
    
    fileprivate weak var parentView: UIView?
    fileprivate var viewFrame = CGRect()
    
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
        
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        self.addSubview(view)
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    
    open func reloadPlayerView() {
        playerLayer = AVPlayerLayer(player: nil)
        timeSlider.value = 0
        timeSlider.setProgress(0, animated: false)
        replayButton.isHidden = true
        isTimeSliding = false
        indicatorView.startAnimating()
        timeLabel.text = "--:-- / --:--"
        reloadPlayerLayer()
    }
    
    open func reloadPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player?.player)
        self.view.layer.insertSublayer(playerLayer!, below: bottomView.layer)
        playerLayer?.frame = self.bounds
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
            indicatorView.stopAnimating()
        }
    }
    
    
    open func bufferStateDidChange(_ state: PlayerBufferState) {
        if state == .buffering {
            indicatorView.startAnimating()
        }
        else {
            indicatorView.stopAnimating()
        }
        
        var current = formatSecondsToString(player!.currentDuration)
        if (player?.totalDuration.isNaN)! {
            current = "00:00"
        }
        
        if state == .readyToPlay && !isTimeSliding {
            timeLabel.text = "\(current + " / " +  (formatSecondsToString((player?.totalDuration)!)))"
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
    
    
    
    open func bufferedDidChange(_ bufferedDuration: TimeInterval, totalDuration: TimeInterval) {
        if bufferedDuration == totalDuration {
            timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: false)
        }
        else {
            timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: true)
        }
    }
    
    
    // MARK: - Full Screen
    
    open func enterFullScreen() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait {
            parentView = self.superview!
            viewFrame = self.frame
        }
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .landscapeRight
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
        fullScreenButton.isSelected = true
    }

    open func exitFullScreen() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .portrait
        
        fullScreenButton.isSelected = false
    }
    
    
    // MARK: - ControlView
    
    open func displayControlView(_ willShow: Bool) {
        if willShow {
            showControlAnimation()
        }
        else {
            hiddenControlAnimation()
        }
    }
    
    internal func showControlAnimation() {
        bottomView.isHidden = false
        topView.isHidden = false
        isDisplayControl = true
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1
            self.topView.alpha = 1
        }) { (completion) in
            self.setupTimer()
        }
    }
    
    internal func hiddenControlAnimation() {
        timer.invalidate()
        isDisplayControl = false
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
            self.topView.alpha = 0
        }) { (completion) in
            self.bottomView.isHidden = true
            self.topView.isHidden = true
        }
    }

    internal func setupTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: self.controlViewDuration, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
        })
    }

    
    // MARK: - Event - timeSlider
    
    @IBAction func timeSliderValueChanged(_ sender: PlayerSlider) {
        if let duration = player?.totalDuration {
            let currentTime = Double(sender.value) * duration
            timeLabel.text = "\(formatSecondsToString(currentTime) + " / " +  (formatSecondsToString(duration)))"
        }
    }
    
    @IBAction func timeSliderTouchDown(_ sender: PlayerSlider) {
        isTimeSliding = true
        timer.invalidate()
    }
    
    @IBAction func timeSliderTouchUpInside(_ sender: PlayerSlider) {
        isTimeSliding = true
        
        if let duration = player?.totalDuration {
            let currentTime = Double(sender.value) * duration
            
            player?.seekTime(currentTime, completion: { [weak self] (finished) in
                guard let strongSelf = self else { return }
                if finished {
                    strongSelf.isTimeSliding = false
                    strongSelf.setupTimer()
                }
            })
            timeLabel.text = "\(formatSecondsToString(currentTime) + " / " +  (formatSecondsToString(duration)))"
        }
    }
    
    // MARK: - Event - Button
    
    @IBAction func onPlayTouched(_ sender: UIButton) {
        if sender.isSelected {
            player?.play()
        }
        else {
            player?.pause()
        }
    }
    
    @IBAction func onFullScreenTouched(_ sender: UIButton) {
        if sender.isSelected {
            self.exitFullScreen()
        }
        else {
            self.enterFullScreen()
        }
    }
    
    @IBAction func onReplayTouched(_ sender: UIButton) {
        player?.replaceVideo((player?.contentURL)!)
        player?.play()
    }
    
    
    // MARK: - Event - Gesture Recognizer
    
    fileprivate(set) var panGestureDirection : PanGestureDirection = .horizontal
    fileprivate var sliderSeekTimeValue : TimeInterval = .nan
    
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    
    @IBAction func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        isDisplayControl = !isDisplayControl
        displayControlView(isDisplayControl)
    }
    
    @IBAction func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let player = player else {
            return
        }
        
        switch player.state {
        case .playFinished:
            break
        case .playing:
            player.pause()
        case .paused:
            player.play()
        default:
            break
        }
    }
    
    @IBAction func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            let x = abs(translation.x)
            let y = abs(translation.y)
            
            if x < y {
                panGestureDirection = .vertical
            }
            else {
                guard player?.mediaFormat == .m3u8 else {
                    panGestureDirection = .horizontal
                    return
                }
            }
            
        case .changed:
            switch panGestureDirection {
            case .horizontal:
                sliderSeekTimeValue = panGestureHorizontal(velocity.x)
            case .vertical:
                panGestureVertical(velocity.y)
            }
            
        case .ended:
            switch panGestureDirection {
            case .horizontal:
                if sliderSeekTimeValue.isNaN { return }
                player?.seekTime(sliderSeekTimeValue, completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    if finished {
                        strongSelf.isTimeSliding = false
                        strongSelf.setupTimer()
                    }
                }) 
            case .vertical:
                break
            }
        default:
            break
        }
    }
    
    internal func panGestureHorizontal(_ velocityX: CGFloat) -> TimeInterval {
        displayControlView(true)
        isTimeSliding = true
        timer.invalidate()
        let value = timeSlider.value
        
        if let _ = player?.currentDuration, let totalDuration = player?.totalDuration {
            let sliderValue = (TimeInterval(value) * totalDuration) + TimeInterval(velocityX) / 100.0 * (TimeInterval(totalDuration) / 400)
            timeSlider.setValue(Float(sliderValue/totalDuration), animated: true)
            return sliderValue
        }
        else {
            return TimeInterval.nan
        }
    }
    

    internal func panGestureVertical(_ velocityY: CGFloat) {
        
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
