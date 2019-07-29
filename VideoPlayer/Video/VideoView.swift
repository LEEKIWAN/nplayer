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
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    var controllerView = VideoControllerView()
    
    func configure(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            
            playerLayer?.videoGravity = .resizeAspectFill
            layer.addSublayer(playerLayer!)
            
            setControllerView()
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    func configure(playerItem: AVPlayerItem) {
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            
            playerLayer?.videoGravity = .resizeAspectFill
            layer.addSublayer(playerLayer!)
            
            setControllerView()
            
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    func setControllerView() {
        controllerView.frame = bounds
        controllerView.player = player
        addSubview(controllerView)
    }
    
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
    
    override func layoutSubviews() {
        playerLayer?.frame = bounds
        controllerView.frame = bounds
    }
    
 
}
