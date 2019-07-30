//
//  VideoView.swift
//  Video
//
//  Created by Rodrigo Leite on 13/05/17.
//  Copyright © 2017 kobe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    var audioPlayGIFImageView: UIImageView?
    
    var playMode: PlayMode = .videoMode
    
    var playerItem: AVPlayerItem?
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    var controllerView = VideoControllerView()
    
    func configure(playerItem: AVPlayerItem) {
        player = nil
        playerLayer?.removeFromSuperlayer()
        
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
    
        layer.addSublayer(playerLayer!)
        
        setControllerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    // MARK: - Layout
    func setControllerView() {
        controllerView.frame = bounds
        controllerView.player = player
        controllerView.videoView = self
        addSubview(controllerView)
    }
    
    override func layoutSubviews() {
        playerLayer?.frame = bounds
        controllerView.frame = bounds
    }
    
    // MARK: - ETC
    
    func setPlayMode()  {
        let assetTracks = self.playerItem?.asset.tracks
        
        for track in assetTracks! {
            if track.mediaType == .video {
                playMode = .videoMode
                return
            }
        }
        playMode = .audioMode
    }
    
    
    // MARK: - Play Func
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
    
    // MARK: - Audio Mode, Video Play Mode
    
    func getAudioAssetFrom(asset: AVAsset) -> AVAsset {
        let assetTracks = asset.tracks
        var audio: AVAssetTrack? = nil
        
        for track in assetTracks {
            if track.mediaType == .audio {
                audio = track
            }
        }
        
        let composition = AVMutableComposition()
        let compositionTrack = composition.addMutableTrack(withMediaType: audio!.mediaType, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        try! compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: audio!, at: .zero)
        
        
        return composition
    }
    
    
    func playAudioMode() {
        guard let asset = player?.currentItem?.asset else {
            return
        }
        
        if player?.isPlaying == false {
            return
        }
        
        self.addSubGifImageView()
        
        let playedTime = player?.currentItem?.currentTime()
        
        let audioAsset = getAudioAssetFrom(asset: asset)
        
        let audioItem = AVPlayerItem(asset: audioAsset)
        audioItem.seek(to: playedTime!, completionHandler: nil)
        
        configure(playerItem: audioItem)
        play()
        playMode = .audioMode
        
    }
    
    func playVideoMode() {
        if player?.isPlaying == false {
            return
        }
//        guard let item = self.playerItem else {
//            return;
//        }
        
        
        let asset = playerItem?.asset
        
        let playedTime = player?.currentItem?.currentTime()
        
        let item = AVPlayerItem(asset: asset!)
        item.seek(to: playedTime!, completionHandler: nil)
        
        
        pause()
        configure(playerItem: item)
        play()
        
//
//
//        let playedTime = player?.currentItem?.currentTime()
//
//        playerItem?.seek(to: playedTime!, completionHandler: nil)
//
//
//        configure(playerItem: item)
//        play()
        playMode = .videoMode
//
//
        self.removeSubGifImageView()
        
    }

    func addSubGifImageView() {
        let gif = try? UIImage(gifName: "CheapBitesizedIslandcanary-size_restricted.gif")
        audioPlayGIFImageView = UIImageView(gifImage: gif!)
        audioPlayGIFImageView?.frame = self.bounds
        self.addSubview(audioPlayGIFImageView!)
    }
    
    func removeSubGifImageView() {
        audioPlayGIFImageView?.removeFromSuperview()
    }
    
}
