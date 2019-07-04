//
//  ViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 03/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVKit


class ViewController: UIViewController {

    @IBOutlet weak var video1: VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        video1.configure(url: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        video1.play()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

