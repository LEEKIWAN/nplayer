//
//  PlayItemTableViewCell.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation

class FileItemTableViewCell: UITableViewCell {

    var data: FileObject!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileExtensionLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var fileInfoStackView: UIStackView!
    @IBOutlet weak var playInfoStackView: UIStackView!
    
    @IBOutlet weak var directoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        thumbnailImageView.tintColor = UIColor.init(hexFromString: "#F7C203")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: FileObject) {
        self.data = data
        
        fileNameLabel.text = data.fileName
        fileSizeLabel.text = data.fileSize
        createDateLabel.text = data.fileCreation
        
        thumbnailImageView.image = data.thumbnailImage
        
        if data.extension == "directory" {
            self.fileExtensionLabel.layer.cornerRadius = 0
            fileInfoStackView.isHidden = true
            playInfoStackView.isHidden = true
            fileNameLabel.isHidden = true
            directoryNameLabel.isHidden = false
            
            directoryNameLabel.text = data.fileName
        }
        else {
            self.fileExtensionLabel.layer.cornerRadius = fileExtensionLabel.frame.height / 2
            
            fileInfoStackView.isHidden = false
            playInfoStackView.isHidden = false
            fileNameLabel.isHidden = false
            directoryNameLabel.isHidden = true


            fileExtensionLabel.text = String("\(data.extension)")
        }
        
        
        
        if data.extension == "mp4" {
//            createTotalPlayTime()
        }
        else {
        }
    }
    

//    func createTotalPlayTime() {
//        let asset = AVAsset(url: data.url)
//
//        let durationTime = CMTimeGetSeconds(asset.duration)
//
//        self.totalPlayTime.text = formatTimeInSec(totalSeconds: Int(durationTime))
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
