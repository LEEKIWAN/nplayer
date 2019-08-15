 //
 //  VideoPlayerController.swift
 //  VideoPlayer
 //
 //  Created by kiwan on 02/08/2019.
 //  Copyright © 2019 kiwan. All rights reserved.
 //
 
 import UIKit
 
 class VideoPlayerController: UIViewController ,VLCMediaPlayerDelegate {
    
    @IBOutlet weak var videoView: UIView!
    var playItem: FileObject!
    
    // Enable debugging
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])
    
    //    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add rotation observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VideoPlayerController.rotated),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        
        //Setup movieView
        
        //Add tap gesture to movieView for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerController.movieViewTapped(_:)))
        self.videoView.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")
        
        //Playing HTTP from internet
        //let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")
        
        //Playing RTSP from internet
        //        let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")
        
        let url = playItem.url
        
        if url == nil {
            print("Invalid URL")
            return
        }
        
        let media = VLCMedia(url: url)
        
        // Set media options
        // https://wiki.videolan.org/VLC_command-line_help
        //media.addOptions([
        //    "network-caching": 300
        //])
        
        mediaPlayer.media = media
        
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.videoView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func rotated() {
        
        let orientation = UIDevice.current.orientation
        
        //        if (UIDeviceOrientationIsLandscape(orientation)) {
        //            print("Switched to landscape")
        //        }
        //        else if(UIDeviceOrientationIsPortrait(orientation)) {
        //            print("Switched to portrait")
        //        }
        
        //Always fill entire screen
//        self.videoView.frame = self.view.frame
        
    }
    
    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {
        
        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
            
            let remaining = mediaPlayer.remainingTime
            let time = mediaPlayer.time
            
            print("Paused at \(time?.stringValue ?? "nil") with \(remaining?.stringValue ?? "nil") time remaining")
        }
        else {
            mediaPlayer.play()
            print("Playing")
        }
        
    }
    
    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
 }
 
 
