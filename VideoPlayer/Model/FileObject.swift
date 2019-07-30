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
    var fileSizeUInt: UInt64?
    
    var fileCreation: String?
    var fileCreationDate: Date?
    
    var thumbnailImage: UIImage?
    // MP4
    
//    var totalPlayTimeText: String?
    
    init(url: URL) {
        self.url = url
        self.filePath = url.path
        self.fileName = url.lastPathComponent.fileName()
        
        if url.hasDirectoryPath {
            self.extension = "directory"
        }
        else {
            self.extension = url.pathExtension
        }

        self.createThumbanailImage()
        
        fileSizeUInt = self.createFileSize()
        fileSize = fileSizeUInt64ToString(with: fileSizeUInt!)
        
        fileCreationDate = createFileCreatedDate()
        fileCreation = fileCreationDateToString(with: fileCreationDate!)
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
        else if self.extension == "directory" {
            self.thumbnailImage = UIImage(named: "folder")
        }
        else {
            self.thumbnailImage = UIImage(named: "baseline_music_video_black_48pt")
        }
    }
    
    //MARK: - File Size
    func createFileSize() -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            }
        } catch {
            print("Failed to get file Size for local File with error: \(error)")
        }
        return 0
    }
    
    func fileSizeUInt64ToString(with fileSize: UInt64) -> String {
        var convertedValue: Double = Double(fileSize)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
    
    //MARK: - File Creation Date
    
    func createFileCreatedDate() -> Date {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let creationDate = fileAttributes[FileAttributeKey.creationDate]  {
                return creationDate as! Date
            }
        } catch {
            print("Failed to get file Date for local File with error: \(error)")
        }
        
        return Date()
    }
    
    func fileCreationDateToString(with fileCreationDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: fileCreationDate)
    }
//
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
