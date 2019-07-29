//
//  VideoObject.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation

class VideoObject {
    
    let url: URL
    var thumbnailImage: UIImage?
    var title: String?
    var totalPlayTimeText: String?
    
    init(url: URL, title: String) {
        self.url = url
        self.title = title
      
        createThumbanailImage()
        createTotalPlayTime()
    }
    
    func createThumbanailImage() {
        let asset = AVAsset(url: url)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = 0
        
        let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil)
        
        var thumbnail: UIImage? = nil
        
        if imageRef == nil {
            thumbnail = UIImage(named: "baseline_music_video_black_48pt")
        }
        else {
            thumbnail = UIImage(cgImage: imageRef!)
        }
        
        
        self.thumbnailImage = thumbnail
    }
    
    func createTotalPlayTime() {
        let asset = AVAsset(url: url)
        
        let durationTime = CMTimeGetSeconds(asset.duration)
        
        self.totalPlayTimeText = formatTimeInSec(totalSeconds: Int(durationTime))
    }
    
    func formatTimeInSec(totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)

        if hours > 0 {
            return "\(strHours):\(strMinutes):\(strSeconds)"
        }
        else {
            return "\(strMinutes):\(strSeconds)"
        }
    }
    
}
