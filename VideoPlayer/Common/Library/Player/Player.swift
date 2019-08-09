//
//  Player.swift
//  VideoPlayer
//
//  Created by kiwan on 01/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

public enum PlayerState: Int {
    case none            // default
    case playing
    case paused
    case playFinished
    case error
}

public enum PlayerBufferState: Int {
    case none           // default
    case readyToPlay
    case buffering
    case stop
    case bufferFinished
}

public enum PlayerBackgroundMode: Int {
    case suspend
    case autoPlayAndPaused
    case proceed
}

public protocol PlayerDelegate: class {
    func player(_ player: Player, stateDidChange state: PlayerState)
    // playe Duration
    func player(_ player: Player, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval)
    // buffer state
    func player(_ player: Player, bufferStateDidChange state: PlayerBufferState)
    // buffered Duration
    func player(_ player: Player, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval)
    // play error
    //    func vgPlayer(_ player: Player, playerFailed error: PlayerError)
}


open class Player: NSObject {
    var state: PlayerState = .none {
        didSet {
            if state != oldValue {
                self.displayView.playStateDidChange(state)
                self.delegate?.player(self, stateDidChange: state)
            }
        }
    }
    
    var bufferState: PlayerBufferState = .none {
        didSet {
            if bufferState != oldValue {
                self.displayView.bufferStateDidChange(bufferState)
                self.delegate?.player(self, bufferStateDidChange: bufferState)
            }
        }
    }
    
    
    
    var mediaFormat: PlayerMediaFormat = .unknown           // init
    var gravityMode: AVLayerVideoGravity = .resizeAspect
    var backgroundMode: PlayerBackgroundMode = .autoPlayAndPaused
    
    var bufferInterval: TimeInterval = 2.0
    weak var delegate: PlayerDelegate?
    
    var displayView: PlayerView
    var totalDuration: TimeInterval = 0
    var currentDuration: TimeInterval = 0
    
    var buffering: Bool = false
    
    
    var player: AVPlayer? {
        willSet {
            removePlayerObservers()
        }
        didSet {
            addPlayerObservers()
        }
    }
    
    private var timeObserver: Any?
    
    var playerItem: AVPlayerItem? {
        willSet {
            removePlayerItemObservers()
            removePlayerNotification()
        }
        
        didSet {
            addPlayerItemObservers()
            addPlayerNotifications()
        }
    }
    
    var playerAsset: AVURLAsset?                // piryo?
    var contentURL: URL?
    
    var seeking: Bool = false
    
    
    public init(URL: URL? = nil, playerView: PlayerView? = nil) {                   // URL nil ?
        mediaFormat = PlayerUtils.decoderVideoFormat(URL)
        if let playerView = playerView {
            self.displayView = playerView
        }
        else {
            self.displayView = PlayerView()
        }
        
        contentURL = URL
        
        super.init()
        
        if contentURL != nil {
            configurationPlayer(contentURL!)
        }
    }
    
    internal func configurationPlayer(_ URL: URL) {
        displayView.player = self
        self.playerAsset = AVURLAsset(url: URL, options: .none)
        
        
        if URL.absoluteString.hasPrefix("file:///") {
            let keys = ["tracks", "playable"]
            playerItem = AVPlayerItem(asset: self.playerAsset!, automaticallyLoadedAssetKeys: keys)
        }
        else {
            let urlAsset = AVURLAsset(url: URL)
            playerItem = AVPlayerItem(asset: urlAsset)
        }
        
        player = AVPlayer(playerItem: playerItem)
        displayView.reloadPlayerView()
    }
    
    //MARK: - Observer
    
    internal func addPlayerObservers() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 10), queue: DispatchQueue.main, using: { [weak self] time in
            guard let strongSelf = self else { return }
            
            if let currentTime = strongSelf.player?.currentTime().seconds, let totalDuration = strongSelf.player?.currentItem?.duration.seconds {
                strongSelf.currentDuration = currentTime
                strongSelf.delegate?.player(strongSelf, playerDurationDidChange: currentTime, totalDuration: totalDuration)
                strongSelf.displayView.playerDurationDidChange(currentTime, totalDuration: totalDuration)
            }
        })
    }
    
    internal func removePlayerObservers() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
    }
    
    // MARK: - Public
    
    open func reloadPlayer() {
        seeking = false
        totalDuration = 0
        currentDuration = 0
        state = .none
        buffering = false
        bufferState = .none
        cleanPlayer()
    }
    
    open func cleanPlayer() {
        player?.pause()
        player?.cancelPendingPrerolls()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        playerAsset?.cancelLoading()
        playerAsset = nil
        
        playerItem?.cancelPendingSeeks()
        playerItem = nil
    }
    
    
    open func replaceVideo(_ URL: URL) {
        reloadPlayer()
        mediaFormat = PlayerUtils.decoderVideoFormat(URL)
        contentURL = URL
        configurationPlayer(URL)
    }
    
    open func play() {
        guard contentURL != nil else { return }
        player?.play()
        state = .playing
        displayView.playButton.isSelected = false
    }
    
    open func pause() {
        guard state == .paused else {
            player?.pause()
            state = .paused
            displayView.playButton.isSelected = true
            return
        }
    }
    
    open func seekTime(_ time: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        if time.isNaN || playerItem?.status != .readyToPlay {
            if completion != nil {
                completion!(false)
            }
        }
        
//        DispatchQueue.main.async { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.seeking = true
//            strongSelf.startPlayerBuffering()
//            strongSelf.playerItem?.seek(to: CMTimeMakeWithSeconds(time, preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { (finished) in
//                DispatchQueue.main.async {
//                    strongSelf.seeking = false
//                    strongSelf.stopPlayerBuffering()
//                    strongSelf.play()
//                    if(completion != nil) {
//                        completion!(finished)
//                    }
//                }
//            })
//        }
    }
    
    //MARK: - buffering
    internal func startPlayerBuffering() {
        pause()
        bufferState = .buffering
        buffering = true
    }
    
    internal func stopPlayerBuffering() {
        bufferState = .stop
        buffering = false
    }
    
    
    //MARK: - KVO
    
    internal func addPlayerItemObservers() {
        let options = NSKeyValueObservingOptions(arrayLiteral: [.new, .initial])
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: options, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: options, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty), options: options, context: nil)
    }
    
    internal func removePlayerItemObservers() {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            var status: AVPlayerItem.Status?
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            }
            else {
                status = .unknown
            }
            
            switch status! {
            case .unknown:
//                startPlayerBuffering()
                break
            case .readyToPlay:
                bufferState = .readyToPlay
            case .failed:
                state = .error
                //                    collectplayererrorlgo
//                stopPlayerBuffering()
                //                    delegate.playererr
                
                //                    diapl
                break
            default:
                break
            }
            
        }
        else if keyPath == #keyPath(AVPlayerItem.isPlaybackBufferEmpty) {
//            if let playbackBufferEmpty = change?[.newKey] as? Bool {
//                if playbackBufferEmpty {
//                    startPlayerBuffering()
//                }
//            }
        }
        else if keyPath  == #keyPath(AVPlayerItem.loadedTimeRanges) {
//            let loadedTimeRanges = player?.currentItem?.loadedTimeRanges            // 영상 로드된 시작 끝 값
//            if let bufferTimeRange = loadedTimeRanges?.first?.timeRangeValue {
//                let start = bufferTimeRange.start.seconds
//                let duration = bufferTimeRange.duration.seconds
//                let bufferTime = start + duration
//
//                if let itemDuration = playerItem?.duration.seconds {
//                    delegate?.player(self, bufferedDidChange: bufferTime, totalDuration: itemDuration)
//                    displayView.bufferedDidChange(bufferTime, totalDuration: itemDuration)
//                    totalDuration = itemDuration
//
//                    if itemDuration == bufferTime {
//                        bufferState = .bufferFinished
//                    }
//                }
//
//                if let currentTime = playerItem?.currentTime().seconds {
//                    if bufferTime - currentTime >= bufferInterval && state != .paused {
//                        play()
//                    }
//
//                    if (bufferTime - currentTime) < bufferInterval {
//                        bufferState = .buffering
//                        buffering = true
//                    }
//                    else {
//                        bufferState = .readyToPlay
//                        buffering = false
//                    }
//                }
//            }
//            else {
//                play()
//            }
        }
    }
    
    
    //MARK: - Notification
    
    internal func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    internal func removePlayerNotification() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc internal func playerItemDidPlayToEnd(_ notification: Notification) {
        if state != .playFinished {
            state = .playFinished
        }
    }
    
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
        //        if let player = displayView.player {
        //            playerLayer.player = player
        //        }
        
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            play()
        case .proceed:
            break
        }
    }
    
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {
        //        if let playerLayer = displayView.playerLayer  {
        //            playerLayer.player = nil
        //        }
        
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            pause()
        case .proceed:
            play()
        }
    }
    
    deinit {
        removePlayerNotification()
        cleanPlayer()
        displayView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
}
