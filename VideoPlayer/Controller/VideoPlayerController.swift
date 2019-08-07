 //
//  VideoPlayerController.swift
//  VideoPlayer
//
//  Created by kiwan on 02/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class VideoPlayerController: UIViewController {

   
    var playItem: FileObject!
    var player: Player?
    @IBOutlet weak var playerView: PlayerView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let playItem = playItem else { return }
        
//        let asset = AVAsset(url: playItem.url)
//        let item = AVPlayerItem(asset: asset)
//        videoView.configure(playerItem: item)
        
        player = Player(URL: playItem.url, playerView: playerView)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        player?.play()
        
//        playerView.play()
    }
    

    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
