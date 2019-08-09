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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let playItem = playItem else { return }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
