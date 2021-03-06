//
//  VideoView.swift
//  VideoPlayer
//
//  Created by kiwan on 21/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import MediaPlayer
import NVActivityIndicatorView
import AVKit

protocol VideoViewDelegate: class {
    func videoViewDidClosed(videoView: VideoView)
    func videoViewDidPlayed(videoView: VideoView)
    func videoViewSettingTouched(videoView: VideoView)
}


class VideoView: UIView {
    var currentAspectRatio: VideoAspectRatio = .aspectFit
    var isPlaying: Bool = true
    
    weak var delegate: VideoViewDelegate?
    var playItem: FileObject!
    
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])
    
    var playSpeedRate: Float = 1.0
    
    var sleepTimer: Timer = Timer()
    var volumeView: MPVolumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 100, height: 100))
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var controllerView: UIView!
    @IBOutlet weak var brightnessToastView: BrightnessToastView!
    
    @IBOutlet weak var titleMarqueeLabel: MarqueeLabel!
    @IBOutlet weak var sliderView: PlayerSliderView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    // bottom view
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var sleepTimerButton: UIButton!
    @IBOutlet weak var skipBackwardButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var screenRatioButton: UIButton!
    
    @IBOutlet weak var brightnessSettingView: BrightnessSettingView!
    
    
    // speed ribght
    @IBOutlet weak var playSpeedUpButton: UIButton!
    @IBOutlet weak var normalSpeedButton: UIButton!
    @IBOutlet weak var playSpeedDownButton: UIButton!
    
    // left
    @IBOutlet weak var rotationLockButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var statusBar: StatusBar!
    @IBOutlet open weak var consStatusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var consLeftWidth: NSLayoutConstraint!
    @IBOutlet weak var consRightWidth: NSLayoutConstraint!
    
    @IBOutlet weak var popupLabel: UILabel!
    var popupLabelTimer: Timer = Timer()
    
    @IBOutlet weak var indicatorBackgroundView: UIView!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    
    //MARK: - Func
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
    
    //MARK: - Private Func
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("VideoView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {
        playSpeedUpButton.layer.cornerRadius = playSpeedUpButton.bounds.height / 2
        normalSpeedButton.layer.cornerRadius = normalSpeedButton.bounds.height / 2
        playSpeedDownButton.layer.cornerRadius = playSpeedDownButton.bounds.height / 2
        rotationLockButton.layer.cornerRadius = rotationLockButton.bounds.height / 2
        repeatButton.layer.cornerRadius = repeatButton.bounds.height / 2
        settingButton.layer.cornerRadius = settingButton.bounds.height / 2
        brightnessSettingView.layer.cornerRadius = 10
        closeButton.imageView?.contentMode = .scaleAspectFit
        
    }
    
    func setEvent() {
        mediaPlayer.delegate = self
        sliderView.delegate = self
        brightnessSettingView.delegate = self
        panGestureRecognizer.delegate = self
        singleTapGestureRecognizer.delegate = self
        //        videoSingleTapGestureRecognizer.delegate = self
        //        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        //        videoSingleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
    }
    
    
    func setPlayItem(item: FileObject) {
        self.playItem = item
        
//        indicatorView.startAnimating()
        
        mediaPlayer.media = playItem.vlcMedia!
        mediaPlayer.drawable = videoView
        
        configureMarqueeTitleLabel()
        configureVolume()
        setupTimer()
        
        mediaPlayer.brightness = PreferenceManager.shared.brightness
        mediaPlayer.contrast = PreferenceManager.shared.contrast
        mediaPlayer.hue = PreferenceManager.shared.hue
        mediaPlayer.saturation = PreferenceManager.shared.saturation
        mediaPlayer.gamma = PreferenceManager.shared.gamma
        mediaPlayer.equalizerEnabled = true
        
        play()
        
        configureVisibleStatusBar()
        sliderView.setProgress(0, animated: false)

        mediaPlayer.setTextRendererFontSize(PreferenceManager.shared.subtitleSize as NSNumber)
    }
    
    
    // MARK: - Configure
    func configureVolume() {
        brightnessToastView.volumeSlider = volumeView.subviews.first as? UISlider
        addSubview(volumeView)
    }
    
    func configureMarqueeTitleLabel() {
        let fileName = mediaPlayer.media.url.lastPathComponent
        titleMarqueeLabel.text = "\(fileName)  "
    }
    
    open func configureVisibleStatusBar() {
        if self.frame.size.width > self.frame.size.height {
            statusBar.isHidden = false
            consStatusBarHeight.constant = 23
            consLeftWidth.constant = 50
            consRightWidth.constant = 50
        }
        else {
            statusBar.isHidden = true
            consStatusBarHeight.constant = 0
            consLeftWidth.constant = 40
            consRightWidth.constant = 40
        }
    }
    
    
    var isDisplayControl: Bool = true
    var controlViewTimer: Timer = Timer()
    
    
    // MARK: - Event
    @IBAction func onSleepTimerTouched(_ sender: UIButton) {
        if sleepTimerButton.isSelected {
            sleepTimerButton.isSelected = !sleepTimerButton.isSelected
            sleepTimer.invalidate()
            setupTimer()
        }
        else {
            self.hiddenControlAnimation()
            let popupView = SleepTimerPopupView(frame: self.bounds)
            popupView.delegate = self
            addSubview(popupView)
        }
    }
    
    @IBAction func onCloseTouched(_ sender: UIButton?) {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.mediaPlayer.media = nil
            
            self.alpha = 0
        }) { (completion) in
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
    
    
    @IBAction func onRotationLockTouched(_ sender: UIButton) {
        rotationLockButton.isSelected = !rotationLockButton.isSelected
        
        if rotationLockButton.isSelected {
            let LANDSCAPE_RIGHT: Bool = UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
            let LANDSCAPE_LEFT: Bool = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
            let PORTRAIT: Bool = UIDevice.current.orientation == UIDeviceOrientation.portrait
            
            var orientationMask: UIInterfaceOrientationMask = .all
            
            if LANDSCAPE_RIGHT {
                orientationMask = .landscapeLeft
            }
            else if LANDSCAPE_LEFT {
                orientationMask = .landscapeRight
            }
            else if PORTRAIT {
                orientationMask = .portrait
            }
            
            AppUtility.lockOrientation(orientationMask)
        }
        else {
            AppUtility.lockOrientation(.all)
        }
        
        setupTimer()
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    @IBAction func onRepeatTouched(_ sender: UIButton) {
        repeatButton.isSelected = !repeatButton.isSelected
        setupTimer()
    }
    
    @IBAction func onSettingTouched(_ sender: UIButton) {
        delegate?.videoViewSettingTouched(videoView: self)
        setupTimer()
    }
    
    @IBAction func onBrightnessSettingTouched(_ sender: UIButton) {
        if brightnessSettingView.isHidden {
            brightnessSettingView.isHidden = false
            brightnessSettingView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.brightnessSettingView.alpha = 1
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.brightnessSettingView.alpha = 0
            }) { (completion) in
                self.brightnessSettingView.isHidden = true
            }
        }
        setupTimer()
    }
        
    @IBAction func onScreenRatioTouched(_ sender: UIButton) {
        switch currentAspectRatio {
        case .aspectFit:
            let ratio = "\(Int(self.bounds.width)):\(Int(self.bounds.height + 1))"
            mediaPlayer.videoAspectRatio = nil
            mediaPlayer.videoCropGeometry = strdup(ratio)
            currentAspectRatio = .aspectFill
            setupPopupLabelTimer("비율에 맞게 채움")
        case .aspectFill:
            let ratio = "\(Int(self.bounds.width)):\(Int(self.bounds.height + 1))"
            mediaPlayer.videoAspectRatio = strdup(ratio)
            mediaPlayer.videoCropGeometry = nil
            currentAspectRatio = .scaleToFill
            setupPopupLabelTimer("채움")
        case .scaleToFill, .custom:
            mediaPlayer.videoAspectRatio = nil
            mediaPlayer.videoCropGeometry = nil
            currentAspectRatio = .aspectFit
            setupPopupLabelTimer("비율에 맞게 맞춤")
        }
        setupTimer()
    }
    
    open func onRotateScreenUpdate() {
        if let aspectRatio = UnsafeMutablePointer<Int8>(mutating: mediaPlayer.videoAspectRatio) {
            var aspectString = String(cString: aspectRatio)
            let aspect = aspectString.components(separatedBy: ":")
            if currentAspectRatio == .scaleToFill {
                aspectString = "\(aspect[1]):\(aspect[0])"
            }
            else {
                aspectString = "\(aspect[0]):\(aspect[1])"
            }
            mediaPlayer.videoAspectRatio = strdup(aspectString)
        }
        
        if let cropGeometry = UnsafeMutablePointer<Int8>(mutating: mediaPlayer.videoCropGeometry) {
            var cropString = String(cString: cropGeometry)
            let crop = cropString.components(separatedBy: ":")
            cropString = "\(crop[1]):\(crop[0])"
            mediaPlayer.videoCropGeometry = strdup(cropString)
        }
    }
    
    internal func setupPopupLabelTimer(_ text: String) {
        popupLabel.text = text
        popupLabel.isHidden = false
        popupLabelTimer.invalidate()
        popupLabelTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            strongSelf.popupLabel.isHidden = true
        })
    }
    
    @IBAction func onAirplayTouched(_ sender: UIButton) {
        let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        airplayVolume.showsVolumeSlider = true
        self.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }

        airplayVolume.removeFromSuperview()
//
        
    }
    
    
    // MARK: - UIGestureRecognizer
    
    @IBOutlet var videoSingleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    //    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBAction func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        isDisplayControl = !isDisplayControl
        displayControlView(isDisplayControl)
    }
    
    //    @IBAction func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
    //        if mediaPlayer.isPlaying {
    //            pause()
    //        }
    //        else {
    //            play()
    //        }
    //    }
    
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    var panGestureDirection: GestureDirection = .horizontal
    var isVolumeAreaTouched : Bool = false
    var firstLocation: CGPoint = CGPoint.zero
    var firstCurrentDuration: Float = 0
    
    @IBAction func onPanGesture(_ gesture: UIPanGestureRecognizer) {
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
                firstLocation = location
                firstCurrentDuration = sliderView.progressView.progress * mediaPlayer.media.length.value.floatValue
                timeSliderTouchDown(sliderView: sliderView)
            }
        case .changed:
            guard let direction = gesture.direction else { return }
            if panGestureDirection == .horizontal {
                var changedLocationX = location.x - firstLocation.x
                let totalDuration = mediaPlayer.media.length
                var currentTime = mediaPlayer.time.value.floatValue
                
                let slideSensitivity = totalDuration.value.intValue / 400

                changedLocationX *= CGFloat(slideSensitivity)
                currentTime += Float(changedLocationX)
                                
                sliderView.setProgress(currentTime / totalDuration.value.floatValue, animated: false)
                timeSliderValueChanged(sliderView: sliderView)
            }
            else {
                brightnessToastView.updateProgressView(isVolumeAreaTouched: isVolumeAreaTouched, value: Float(velocity.y / 10000))
            }
        case .ended:
            if panGestureDirection == .horizontal {
                timeSliderTouchUpInside(sliderView: sliderView)
            }
            break
            
        default:
            break
        }
    }
    
    deinit {
        self.mediaPlayer.media = nil
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
    
    open func displayControlView(_ willShow: Bool) {
        if willShow {
            showControlAnimation()
        }
        else {
            hiddenControlAnimation()
        }
    }
    
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
            self.brightnessSettingView.isHidden = true
        }
    }
    
    internal func setupTimer() {
        controlViewTimer.invalidate()
        controlViewTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
        })
    }
}


// MARK: - SliderView Touch Event
extension VideoView: PlayerSliderViewDelegate {
    func timeSliderTouchDown(sliderView: PlayerSliderView) {
        isPlaying = mediaPlayer.isPlaying
        controlViewTimer.invalidate()
        mediaPlayer.pause()
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    func timeSliderTouchUpInside(sliderView: PlayerSliderView) {
        if isPlaying {
            play()
        }
        setupTimer()
        
    }
    
    func timeSliderValueChanged(sliderView: PlayerSliderView) {
        let totalDuration = mediaPlayer.media.length
        let prevTime = mediaPlayer.time.value.floatValue
        let currentTime = sliderView.progressView.progress * totalDuration.value.floatValue
        
        let currentDuration = VLCTime(int: Int32(currentTime))
        mediaPlayer.time = currentDuration
        currentDurationLabel.text = currentDuration?.stringValue
        
        var searchTime = Int(currentTime - prevTime) / 1000
        searchTime > 0 ? setupPopupLabelTimer("+\(searchTime.timeFormatted()) (\(String(describing: currentDuration!.stringValue!)))") : setupPopupLabelTimer("-\(searchTime.timeFormatted()) (\(String(describing: currentDuration!.stringValue!)))")
        
    }
    
}

// MARK: - VLCMediaPlayerDelegate
extension VideoView: VLCMediaPlayerDelegate {
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        if mediaPlayer.media == nil {
            return
        }
        
        let currentDuration = mediaPlayer.time
        let totalDuration = mediaPlayer.media.length
        currentDurationLabel.text = currentDuration?.stringValue!
        totalDurationLabel.text = totalDuration.stringValue!
        
        let progresssValue = Float(currentDuration!.intValue) / Float(totalDuration.intValue)
        sliderView.setProgress(progresssValue, animated: false)
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if mediaPlayer.state == .ended {
            
            if repeatButton.isSelected {
                
                //                mediaPlayer.time = VLCTime(int: 0)
                //                mediaPlayer.play()
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.onCloseTouched(self.closeButton)
                }
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
        if gestureRecognizer == panGestureRecognizer {
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
        else if gestureRecognizer == singleTapGestureRecognizer || gestureRecognizer == videoView {
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
        
        return true
    }
}

//MARK: - BrightnessSliderDelegate
extension VideoView: BrightnessSliderDelegate {
    func onSliderTouchDown(view: BrightnessSettingView, slider: UISlider) {
        controlViewTimer.invalidate()
    }
    
    func onSliderValuedChanged(view: BrightnessSettingView, slider: UISlider) {
        controlViewTimer.invalidate()
        
        switch slider.tag {
        case SliderType.brightness.rawValue:
            mediaPlayer.brightness = slider.value
            PreferenceManager.shared.brightness = slider.value
        case SliderType.contrast.rawValue:
            mediaPlayer.contrast = slider.value
            PreferenceManager.shared.contrast = slider.value
        case SliderType.hue.rawValue:
            mediaPlayer.hue = slider.value
            PreferenceManager.shared.hue = slider.value
        case SliderType.saturation.rawValue:
            mediaPlayer.saturation = slider.value
            PreferenceManager.shared.saturation = slider.value
        case SliderType.gamma.rawValue:
            mediaPlayer.gamma = slider.value
            PreferenceManager.shared.gamma = slider.value
        default:
            break
        }
    }
    
    func onSliderTouchUpInside(view: BrightnessSettingView, slider: UISlider) {
        setupTimer()
    }
    
    func onResetTouched(view: BrightnessSettingView) {
        mediaPlayer.brightness = PreferenceManager.shared.brightness
        mediaPlayer.contrast = PreferenceManager.shared.contrast
        mediaPlayer.hue = PreferenceManager.shared.hue
        mediaPlayer.saturation = PreferenceManager.shared.saturation
        mediaPlayer.gamma = PreferenceManager.shared.gamma
        setupTimer()
    }
}

extension VideoView: SleepTimerPopupViewDelegate {
    func SleepTimerPopup(view: SleepTimerPopupView, hour: Int, minutes: Int) {
        sleepTimerButton.isSelected = true
        
        let timeInterval: Double = Double((hour * 60 * 60) + (minutes * 60))
        sleepTimer.invalidate()
        sleepTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            strongSelf.onCloseTouched(nil)
        })
    }
    
}
