//
//  SubTitlePopupViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/08.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation


class SubTitlePopupViewController: UIViewController {

    var mediaPlayer: VLCMediaPlayer?
    

    @IBOutlet weak var subTitleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func onSubtitleValueChanged(_ sender: UISwitch) {
        
        guard let mediaPlayer = mediaPlayer, mediaPlayer.videoSubTitlesNames.count > 0 else { return }
                    
        if subTitleSwitch.isOn {
            
        }
        else {
            
        }
    }
}

