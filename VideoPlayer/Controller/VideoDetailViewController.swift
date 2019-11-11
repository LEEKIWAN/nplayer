//
//  VideoDetailViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 21/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import AVFoundation

class VideoDetailViewController: UIViewController, VideoViewDelegate {
    var shouldHideHomeBarIndicator = false
    
    var data: FileObject?
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var videoView: VideoView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var audioDescriptionLabel: UILabel!
    
    
    var settingPopupViewController: PopupViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return shouldHideHomeBarIndicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else {
            return
        }
        
        self.navigationController?.navigationBar.isTranslucent = false;
        
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
        
        if let videoView = videoView {
            videoView.frame = (self.navigationController?.view.window?.bounds)!
        }
        
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
    
    func setPrefersHomeIndicator(autoHidden: Bool) {
        self.shouldHideHomeBarIndicator = autoHidden
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let videoView = videoView else {
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            videoView.configureVisibleStatusBar()
            videoView.onRotateScreenUpdate()
            
        }) { (_) in
            
        }
    }
    
    
    //MARK: - Event     - 플레이
    
    @IBAction func onPlayTouched(_ sender: UIButton) {
        videoView = VideoView(frame: (self.navigationController?.view.window!.bounds)!)
        videoView.delegate = self
        videoView.setPlayItem(item: data!)
        
        videoView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.videoView.alpha = 1
            self.navigationController?.view.addSubview(self.videoView)
            
        }) { (completion) in
            //            AppUtility.lockOrientation(.landscape)
            self.setPrefersHomeIndicator(autoHidden: true)
        }
    }
    
    //MARK: - VideoViewDelegate     - 클로즈
    func videoViewDidClosed(videoView: VideoView) {
        AppUtility.lockOrientation(.all)
        self.setPrefersHomeIndicator(autoHidden: false)
        videoView.removeFromSuperview()
        self.videoView = nil
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    
    func videoViewDidPlayed(videoView: VideoView) {
        
    }
    
    
    func videoViewSettingTouched(videoView: VideoView) {
        let storyBoard = UIStoryboard(name: "SettingPopupViewController", bundle: nil)
        let tabViewController = storyBoard.instantiateInitialViewController()
        let settingPopupViewController = PopupViewController(contentController: tabViewController!, popupWidth: 300, popupHeight: 300)
        settingPopupViewController.backgroundAlpha = 0
        settingPopupViewController.cornerRadius = 10

        
        let _ = tabViewController?.children.map {
            if $0.children[0] is SubTitlePopupViewController {
                ($0.children[0] as! SubTitlePopupViewController).mediaPlayer = videoView.mediaPlayer
            }
            else if $0.children[0] is VideoPopupViewController {
                ($0.children[0] as! VideoPopupViewController).mediaPlayer = videoView.mediaPlayer
            }
        }
        
        present(settingPopupViewController, animated: true, completion: nil)
    }
    
    
    
    deinit {
        print("Asdf")
    }
    
}
