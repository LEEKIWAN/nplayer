//
//  PlayListViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class PlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var videoItems: [VideoObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createTableViewItems()
        self.tableView.reloadData()
    }

    func createTableViewItems() {
        
        // Local ->
        
        let videoNames = ["bulletTrain", "monkey", "newYorkFlip", "SampleVideo_1280x720_10mb"]
        
        for i in 0 ..< videoNames.count {
            let urlPath = Bundle.main.path(forResource: videoNames[i], ofType: "mp4")!
            let url = URL(fileURLWithPath: urlPath)
            
            let item = VideoObject(url: url, title: videoNames[i])
            self.videoItems.append(item)
        }
        
        let urlPath = Bundle.main.path(forResource: "Prelude", ofType: "mp3")!
        let url = URL(fileURLWithPath: urlPath)
        
        let item = VideoObject(url: url, title: "Prelude")
        self.videoItems.append(item)
        
        
        
        // URL ->
        
        let remoteUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")
        self.videoItems.append(VideoObject(url: remoteUrl!, title: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"))
        
        let remoteUrl2 = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")
        self.videoItems.append(VideoObject(url: remoteUrl2!, title: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"))
        
    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! PlayItemTableViewCell
        
        cell.titleLabel.text = videoItems[indexPath.row].title
        cell.thumbnailImageView.image = videoItems[indexPath.row].thumbnailImage
        cell.totalPlayTime.text = videoItems[indexPath.row].totalPlayTimeText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "PlayViewController", bundle: nil)
        let playViewController = storyBoard.instantiateInitialViewController() as! PlayViewController
        
        playViewController.playItem = videoItems[indexPath.row]
        
        self.present(playViewController, animated: true, completion: nil)
    }
    
    
}
