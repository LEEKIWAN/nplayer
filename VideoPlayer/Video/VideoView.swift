//
//  VideoView.swift
//  VideoPlayer
//
//  Created by kiwan on 21/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import MediaPlayer

protocol VideoViewDelegate: class {
    func videoViewDidClosed(videoView: VideoView)
    func videoViewDidPlayed(videoView: VideoView)
}


class VideoView: UIView {
    var currentAspectRatio: VideoAspectRatio = .aspectFit
    
    var delegate: VideoViewDelegate?
    var playItem: FileObject!
    
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])
    
    var playSpeedRate: Float = 1.0
    
    
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
    
    var volumeSlider : UISlider?
    
    @IBOutlet weak var brightnessSettingBoundsView: UIView!
    
    lazy var brightnessSettingView: BrightnessSettingView = {
        let settingView = BrightnessSettingView(frame: self.brightnessSettingBoundsView.bounds)
        settingView.delegate = self
        return settingView
    }()
    
    
    // speed
    @IBOutlet weak var playSpeedUpButton: UIButton!
    @IBOutlet weak var normalSpeedButton: UIButton!
    @IBOutlet weak var playSpeedDownButton: UIButton!
    
    
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
        let view = Bundle.main.loadNibNamed("VideoView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {
        playSpeedUpButton.layer.cornerRadius = playSpeedUpButton.bounds.height / 2
        normalSpeedButton.layer.cornerRadius = normalSpeedButton.bounds.height / 2
        playSpeedDownButton.layer.cornerRadius = playSpeedDownButton.bounds.height / 2
    }
    
    func setEvent() {
        panGestureRecognizer.delegate = self
//        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
//        videoSingleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
    }
    
    func setPlayItem(item: FileObject) {
        self.playItem = item
        mediaPlayer.media = playItem.vlcMedia!
        mediaPlayer.delegate = self
        mediaPlayer.drawable = videoView
        
        configurationVolumeSlider()
        setupTimer()
        play()
    }
    
    internal func configurationVolumeSlider() {
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider {
            volumeSlider = view
        }
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
    
    
    @IBAction func onBrightnessSettingTouched(_ sender: UIButton) {
        brightnessSettingBoundsView.addSubview(brightnessSettingView)
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
    var isVolumeAreaTouched : Bool = false
    
    
    @IBAction func onPanGesture(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: self)
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            if abs(Float(velocity.y)) > abs(Float(velocity.x)) {
                if location.x > bounds.width / 2 {
                    isVolumeAreaTouched = true
                } else {
                    isVolumeAreaTouched = false
                }
                
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
                isVolumeAreaTouched ? (volumeSlider!.value -= Float(velocity.y / 10000)) : (UIScreen.main.brightness -= velocity.y / 10000)
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

// MARK: - Play Speed Control
extension VideoView {
    @IBAction func onPlaySpeedUpTouched(_ sender: UIButton) {
        if playSpeedRate >= 4.0 {
            return
        }
        playSpeedRate = Float(String(format: "%.1f", playSpeedRate + 0.1))!
        mediaPlayer.fastForward(atRate: playSpeedRate)
        normalSpeedButton.setTitle(String(format: "%.1f", playSpeedRate), for: .normal)
        setupTimer()
    }
    
    @IBAction func onNormalSpeedTouched(_ sender: UIButton) {
        playSpeedRate = 1.0
        mediaPlayer.fastForward(atRate: 1.0)
        normalSpeedButton.setTitle(String(format: "%.1f", playSpeedRate), for: .normal)
        setupTimer()
    }
    
    @IBAction func onPlaySpeedDownTouched(_ sender: UIButton) {
        if playSpeedRate <= 0.1 {
            return
        }
        playSpeedRate = Float(String(format: "%.1f", playSpeedRate - 0.1))!
        mediaPlayer.fastForward(atRate: playSpeedRate)
        normalSpeedButton.setTitle(String(format: "%.1f", playSpeedRate), for: .normal)
        setupTimer()
    }
    
}


extension VideoView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var isDrawableView = false
        
        let drawableView = mediaPlayer.drawable as! UIView
        for view in drawableView.subviews {
            if touch.view! == view {
                isDrawableView = true
                break
            }
        }
        
        return touch.view! == controllerView || isDrawableView
    }

    
}

extension VideoView: BrightnessSliderDelegate {
    func onSliderTouchDown(view: BrightnessSettingView, slider: UISlider) {
        controlViewTimer.invalidate()
    }
    
    func onSliderValuedChanged(view: BrightnessSettingView, slider: UISlider) {
        controlViewTimer.invalidate()

        switch slider.tag {
        case SliderType.brightness.rawValue:
            mediaPlayer.brightness = slider.value
        case SliderType.contrast.rawValue:
            mediaPlayer.contrast = slider.value
        case SliderType.hue.rawValue:
            mediaPlayer.hue = slider.value
        case SliderType.saturation.rawValue:
            mediaPlayer.saturation = slider.value
        case SliderType.gamma.rawValue:
            mediaPlayer.gamma = slider.value
        default:
            break
        }
    }
    
    func onSliderTouchUpInside(view: BrightnessSettingView, slider: UISlider) {
        setupTimer()
    }
}
