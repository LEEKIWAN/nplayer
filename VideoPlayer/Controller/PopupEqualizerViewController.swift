//
//  PopupEqualizerViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/14.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit


class PopupEqualizerViewController: UIViewController {
    var videoView: VideoView?
    var mediaPlayer: VLCMediaPlayer?
    
    var dataArray: [VideoConfigObject] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "Text")
        
        guard let mediaPlayer = mediaPlayer else { return }
        guard let equalizerProfiles = mediaPlayer.equalizerProfiles else { return }
        
        for i in 0 ..< equalizerProfiles.count {
            dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: equalizerProfiles[i] as! String, subTitle: "", selectedValue: "", isSelectAccesory: false))
        }
        
        let checkedIndex = 0
        dataArray[checkedIndex].isSelectAccesory = true
        
        tableView.reloadData()
        
        //title
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "이퀄라이저"
        
     
        
        
    }
}


extension PopupEqualizerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath) as! TextTableViewCell
        cell.data = data
        
        if data.isSelectAccesory {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.tintColor = UIColor(hexFromString: "#F7C203")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for data in dataArray {
            data.isSelectAccesory = false
        }
        
        dataArray[indexPath.row].isSelectAccesory = true
        tableView.reloadData()
        
        guard let mediaPlayer = mediaPlayer else { return }
        guard let equalizerProfiles = mediaPlayer.equalizerProfiles else { return }
        
        print(mediaPlayer.equalizerEnabled)
        
        let profile = equalizerProfiles[indexPath.row]
        mediaPlayer.resetEqualizer(fromProfile: profile)
        
        
        for i in 0 ..< mediaPlayer.numberOfBands {
            
            let value = mediaPlayer.amplification(ofBand: i)
            print("amplification \(value)")
            
            let value2 = mediaPlayer.frequencyOfBand(at: i)
//            print("frequncy \(value2)")
            
            
        }
        
    }
}

