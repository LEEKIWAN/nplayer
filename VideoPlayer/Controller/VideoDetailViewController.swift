//
//  VideoDetailViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 21/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import AVFoundation

class VideoDetailViewController: UIViewController {
    
    var data: FileObject?
    
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var audioDescriptionLabel: UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else {
            return
        }
        
        titleLabel.text = "\(data.fileName).\(data.extension)"
        thumbnailImageView.image = data.thumbnailImage
        backgroundImageView.image = data.thumbnailImage
        totalDurationLabel.text = data.totalDurationText
        setBackgroundBlurView()
        
        guard let tracksInformation = data.vlcMedia?.tracksInformation else {
            return
        }
        
        
        var videoInfo: Dictionary<String, Any>? = nil
        var audioInfo: Dictionary<String, Any>? = nil
        
        for i in 0 ..< tracksInformation.count {
            let info = tracksInformation[i] as! Dictionary<String, Any>
            if info["type"] as! String == "audio" {
                audioInfo = info
            }
            else if info["type"] as! String == "video" {
                videoInfo = info
            }
        }
        
        if let videoInfo = videoInfo {
            videoInformationUpdate(track: videoInfo)
        }
        
        if let audioInfo = audioInfo {
            audioInformationUpdate(track: audioInfo)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurView.frame = backgroundImageView.bounds
    }
    
    //MARK: - UI
    
    func videoInformationUpdate(track: Dictionary<String, Any>) {
        let videoResolution = "\(track["width"] as! Int)x\(track["height"] as! Int)"
        let codecFourCC = FourCharCode(integerLiteral: track["codec"] as! UInt32).toString()

        videoDescriptionLabel.text = "\(videoResolution)" + ", \(codecFourCC.toCodecName())"
    }
    
    func audioInformationUpdate(track: Dictionary<String, Any>) {
        let channels = "\(track["channelsNumber"] as! Int)ch"
        let bitrate = "\(track["rate"] as! Float / 1000)kHz"
        let codecFourCC = FourCharCode(integerLiteral: track["codec"] as! UInt32).toString()
        
        audioDescriptionLabel.text = "\(channels)" + ", \(bitrate)" + ", \(codecFourCC.toCodecName())"
    }
    
    func setBackgroundBlurView() {
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
    }
    
    //MARK: - Event
    
    @IBAction func onPlayTouched(_ sender: UIButton) {
        
    }
    
}
