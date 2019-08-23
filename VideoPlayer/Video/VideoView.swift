//
//  VideoView.swift
//  VideoPlayer
//
//  Created by kiwan on 21/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

protocol VideoViewDelegate: class {
    func videoViewDidClosed(videoView: VideoView)
    func videoViewDidPlayed(videoView: VideoView)
}


class VideoView: UIView {
    var currentAspectRatio: VideoAspectRatio = .aspectFit
    
    var delegate: VideoViewDelegate?
    var playItem: FileObject!
    
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])
    
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var controllerView: UIView!
    
    // top view
    @IBOutlet weak var sliderView: PlayerSlider!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    // bottom view
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var skipBackwardButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var screenRatioButton: UIButton!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
        setEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
        setEvent()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("VideoView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setEvent() {
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        videoSingleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
    }
    
    func setPlayItem(item: FileObject) {
        self.playItem = item
        mediaPlayer.media = playItem.vlcMedia!
        mediaPlayer.delegate = self
        mediaPlayer.drawable = videoView
        setupTimer()
        play()
    }
    
    
    var isDisplayControl: Bool = true
    var controlViewTimer: Timer = Timer()
   
    
    open func displayControlView(_ willShow: Bool) {
        if willShow {
            showControlAnimation()
        }
        else {
            hiddenControlAnimation()
        }
    }
    
    
    // MARK: - Event
    
    @IBAction func onCloseTouched(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.alpha = 0
        }) { (completion) in
            self.removeFromSuperview()
            self.delegate?.videoViewDidClosed(videoView: self)
        }
    }
    
    @IBAction func onPlayTouched(_ sender: UIButton) {
        play()
    }
    @IBAction func onPauseTouched(_ sender: UIButton) {
        pause()
    }
    
    @IBAction func onSkipForwardTouched(_ sender: UIButton) {
        mediaPlayer.shortJumpForward()
        setupTimer()
        self.mediaPlayerTimeChanged(nil)
    }
    
    @IBAction func onSkipBackwardTouched(_ sender: UIButton) {
        mediaPlayer.shortJumpBackward()
        setupTimer()
        self.mediaPlayerTimeChanged(nil)
    }
    
    @IBAction func onScreenRatioTouched(_ sender: UIButton) {
        switch currentAspectRatio {
        case .aspectFit:
            let ratio = "\(Int(self.bounds.width)):\(Int(self.bounds.height))"
            mediaPlayer.videoCropGeometry = strdup(ratio)
            currentAspectRatio = .aspectFill
        case .aspectFill:
            mediaPlayer.videoCropGeometry = nil
            let ratio = "\(Int(self.bounds.width)):\(Int(self.bounds.height + 1))"
            mediaPlayer.videoAspectRatio = strdup(ratio)
            currentAspectRatio = .scaleToFill
        case .scaleToFill:
            mediaPlayer.videoAspectRatio = nil
            mediaPlayer.videoCropGeometry = nil
            currentAspectRatio = .aspectFit
        }
        
        setupTimer()
    }
    
    
    // MARK: - UIGestureRecognizer
    
    @IBOutlet var videoSingleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
   
    @IBAction func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        isDisplayControl = !isDisplayControl
        displayControlView(isDisplayControl)
    }
    
    @IBAction func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        if mediaPlayer.isPlaying {
            pause()
        }
        else {
            play()
        }
    }
    
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    var panGestureDirection: GestureDirection = .horizontal
    
    @IBAction func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
//        let location = gesture.location(in: self)
//        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            let x = abs(translation.x)
            let y = abs(translation.y)

            if x < y {
                panGestureDirection = .vertical
            }
            else {
                panGestureDirection = .horizontal
            }
            
        case .changed:
            guard let direction = gesture.direction else { return }
            
            if panGestureDirection == .horizontal {
                if direction == .Right {
                    mediaPlayer.jumpForward(10)
                }
                else if direction == .Left{
                    mediaPlayer.jumpBackward(10)
                }
                play()
                panGestureRecognizer.isEnabled = false
                panGestureRecognizer.isEnabled = true
                
            }
            else {
                if direction == .Down {
                    print("down")
                }
                else if direction == .Up {
                    print("up")
                }
            }
        default:
            break
        }
    }
    
    deinit {
        print("deinit")
    }
}


// MARK: - Video Control
extension VideoView {
    func pause() {
        if mediaPlayer.canPause {
            mediaPlayer.pause()
            playButton.isHidden = false
            pauseButton.isHidden = true
            setupTimer()
        }
    }
    
    func play() {
        mediaPlayer.play()
        playButton.isHidden = true
        pauseButton.isHidden = false
        setupTimer()
    }
}

// MARK: - ControlView Show && Hide
extension VideoView {
    internal func showControlAnimation() {
        controllerView.alpha = 0
        isDisplayControl = true
        UIView.animate(withDuration: 0.3, animations: {
            self.controllerView.alpha = 1
        }) { (completion) in
            self.setupTimer()
        }
    }
    
    internal func hiddenControlAnimation() {
        controlViewTimer.invalidate()
        isDisplayControl = false
        UIView.animate(withDuration: 0.3, animations: {
            self.controllerView.alpha = 0
        }) { (completion) in
        }
    }
    
    internal func setupTimer() {
        controlViewTimer.invalidate()
        controlViewTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
        })
    }
}


// MARK: - SliderView Touch Event
extension VideoView {
    @IBAction func timeSliderValueChanged(_ sender: PlayerSlider) {
        let currentDuration = mediaPlayer.time
        let totalDuration = mediaPlayer.media.length
        
        let currentTime = sender.value * Float(totalDuration.intValue)
        
        mediaPlayer.time = VLCTime(int: Int32(currentTime))
        currentDurationLabel.text = currentDuration?.stringValue
        totalDurationLabel.text = totalDuration.stringValue
        
        play()
    }
    
    @IBAction func timeSliderTouchDown(_ sender: PlayerSlider) {
        controlViewTimer.invalidate()
    }
    
    @IBAction func timeSliderTouchUpInside(_ sender: PlayerSlider) {
        setupTimer()
    }
    
}

// MARK: - VLCMediaPlayerDelegate
extension VideoView: VLCMediaPlayerDelegate {
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        let currentDuration = mediaPlayer.time
        let totalDuration = mediaPlayer.media.length
        currentDurationLabel.text = currentDuration?.stringValue!
        totalDurationLabel.text = totalDuration.stringValue!
        
        let progresssValue = Float(currentDuration!.intValue) / Float(totalDuration.intValue)
        
        sliderView.value = progresssValue
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if mediaPlayer.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.onCloseTouched(self.closeButton)
            }
        }
    }
    
}
