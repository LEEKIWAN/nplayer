//
//  ViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 03/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVKit

import AVFoundation
import MediaPlayer

class PlayViewController: UIViewController {

    var playItem: FileObject!
    
    @IBOutlet weak var video1: VideoView!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let playItem = playItem else { return }
        
        let asset = AVAsset(url: playItem.url)
        let item = AVPlayerItem(asset: asset)       // 실제 원본 어쏐
        
        
        video1.playerItem = item
        video1.configure(playerItem: item)
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(applicationdidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationwillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        video1.play()
    }

    // MARK: - Func
    
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
    
    //MARK: - Background & Foreground

    
    @objc func applicationdidEnterBackground(notification: Notification) {
        print("applicationdidEnterBackground")
//        guard let asset = video1.player?.currentItem?.asset else {
//            return
//        }
//
//        if video1.player?.isPlaying == false {
//            return
//        }
//
//        let playedTime = video1.player?.currentItem?.currentTime()
//
//
//        let audioAsset = self.getAudioAssetFrom(asset: asset)
//
//        let audioItem = AVPlayerItem(asset: audioAsset)
//        audioItem.seek(to: playedTime!, completionHandler: nil)
//
//        video1.configure(playerItem: audioItem)
//        video1.play()
        
    }

    @objc func applicationwillEnterForeground(notification: Notification) {
        print("applicationwillEnterForeground")
//        guard let playItem = playItem else { return }
//
//        if video1.player?.isPlaying == false {
//            return
//        }
//
//        let asset = AVAsset(url: playItem.url)
//
//        let playedTime = video1.player?.currentItem?.currentTime()
//
//        let item = AVPlayerItem(asset: asset)
//        item.seek(to: playedTime!, completionHandler: nil)
//
//
//        video1.pause()
//        video1.configure(playerItem: item)
//        video1.play()
////        
    }

    
    //MARK: - Event
    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        video1.stop()
    }
    
    
    
}

