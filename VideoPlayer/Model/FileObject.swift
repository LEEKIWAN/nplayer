//
//  VideoObject.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation

class FileObject {
    
    let url: URL
    let filePath: String
    let fileName: String
    let `extension`: String
    
    var fileSize: String?
    var fileCreation: String?
    
    // directory
    var fileCountInDir: Int?
    
    var thumbnailImage: UIImage?
    // MP4
    
//    var totalPlayTimeText: String?
    
    init(url: URL) {
        self.url = url
        self.filePath = url.path
        self.fileName = url.lastPathComponent.fileName()
        self.fileSize = url.fileSizeString
        self.fileCreation = url.creationDateString
        
        if url.hasDirectoryPath {
            self.extension = "directory"
            let dirContents = try? FileManager.default.contentsOfDirectory(atPath: self.filePath)
            fileCountInDir = dirContents?.count
        }
        else {
            self.extension = url.pathExtension
        }

        self.createThumbanailImage()
    }
    
    func createThumbanailImage() {
        if self.extension == "mp4" {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            var time = asset.duration
            time.value = 0
            
            let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil)
            
            self.thumbnailImage = UIImage(cgImage: imageRef!)
        }
        else if self.extension == "mp3" {
            let asset = AVURLAsset(url: self.url)
            
            for metadataItem in asset.commonMetadata {
                if (metadataItem.commonKey! == .commonKeyArtwork) {
                    
                    if let data = metadataItem.dataValue {
                        self.thumbnailImage = UIImage(data: data)
                    }
                    else {
                        self.thumbnailImage = UIImage(named: "baseline_music_video_black_48pt")
                    }
                }
            }
        }
        else if self.extension.lowercased() == "png" || self.extension.lowercased() == "gif" || self.extension.lowercased() == "jpg" {
            self.thumbnailImage = UIImage(contentsOfFile: filePath)
        }
        else if self.extension.lowercased() == "swift" || self.extension.lowercased() == "txt" || self.extension.lowercased() == "md" {
            self.thumbnailImage = UIImage(named: "text")
        }
        else if self.extension == "directory" {
            self.thumbnailImage = UIImage(named: "folder")
        }
        else {
            self.thumbnailImage = UIImage(named: "file")
        }
    }

    
//    func createTotalPlayTime() {
//        let asset = AVAsset(url: url)
//        
//        let durationTime = CMTimeGetSeconds(asset.duration)
//        
//        self.totalPlayTimeText = formatTimeInSec(totalSeconds: Int(durationTime))
//    }
//    
//    func formatTimeInSec(totalSeconds: Int) -> String {
//        let seconds = totalSeconds % 60
//        let minutes = (totalSeconds / 60) % 60
//        let hours = totalSeconds / 3600
//        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
//        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
//        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
//
//        if hours > 0 {
//            return "\(strHours):\(strMinutes):\(strSeconds)"
//        }
//        else {
//            return "\(strMinutes):\(strSeconds)"
//        }
//    }
    
}
