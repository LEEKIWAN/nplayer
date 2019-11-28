//
//  VideoObject.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation

class FileObject: NSObject, VLCMediaThumbnailerDelegate, VLCMediaDelegate {
    
    let url: URL
    let filePath: String
    let fileName: String
    let `extension`: String
    
    var fileSize: String?
    var fileCreation: String?
    
    var thumbnailImage: UIImage?
    
    // directory
    var fileCountInDir: Int?
        
    // Video
    var vlcMedia: VLCMedia?
    var totalDurationText: String?
    
    // tableView
    var tableView: UITableView?
    var indexPath: IndexPath?
    
    
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
        
        super.init()

        self.createThumbanailImage()
    }
    
    func createThumbanailImage() {
        let fileType = getFileType()
        if fileType == .video {
            createVideoMetadatas()
        }
        else if fileType == .audio {
            createAudioMetadatas()
        }
        else if fileType == .image {
            self.thumbnailImage = UIImage(contentsOfFile: filePath)
        }
        else if fileType == .text {
            self.thumbnailImage = UIImage(named: "text")
        }
        else if fileType == .directory {
            self.thumbnailImage = UIImage(systemName: "folder")
        }
        else {
            self.thumbnailImage = UIImage(named: "file")
        }
    }

    
    func createVideoMetadatas() {
        self.vlcMedia = VLCMedia(url: url)
        self.vlcMedia?.delegate = self
        self.vlcMedia?.parse(withOptions: 0)
        let thumbnailer = VLCMediaThumbnailer(media: VLCMedia(url: url), andDelegate: self)
        thumbnailer?.fetchThumbnail()
    }
    
    func createAudioMetadatas() {
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
        
        self.totalDurationText = asset.duration.stringValue
    }
    
    func getFileType() -> FileType {
        switch self.extension.lowercased() {
        case "png", "gif", "jpg", "jpeg":
            return .image
        case "txt", "md", "swift":
            return .text
        case "mp3":
            return .audio
        case "mp4", "avi", "mkv":
            return .video
        case "directory":
            return .directory
        default:
            return .etc
        }
    }
    
    // MARK: - VLCMediaThumbnailerDelegate
    
    func mediaThumbnailerDidTimeOut(_ mediaThumbnailer: VLCMediaThumbnailer!) {
        print("timeout")
    }
    
    func mediaThumbnailer(_ mediaThumbnailer: VLCMediaThumbnailer!, didFinishThumbnail thumbnail: CGImage!) {
        self.thumbnailImage = UIImage(cgImage: thumbnail)
        tableView?.reloadRows(at: [indexPath!], with: .none)
    }
    
    
    // MARK: - VLCMediaDelegate
    
    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        self.totalDurationText = vlcMedia?.length.stringValue
        tableView?.reloadRows(at: [indexPath!], with: .none)
    }
    
}
