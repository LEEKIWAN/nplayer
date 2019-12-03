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
    
    @IBOutlet weak var playedDurationLabel: UILabel!
    @IBOutlet weak var fileCountLabel: UILabel!
    
    
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        thumbnailImageView.tintColor = UIColor.init(hexFromString: "#F7C203")
    }

    func setData(data: FileObject) {
        self.data = data
        
        fileNameLabel.text = data.fileName
        fileSizeLabel.text = data.size.string
        createDateLabel.text = data.creationDate?.String

        thumbnailImageView.image = data.thumbnailImage

        
        if data.isDirectory {
          self.thumbnailImageView.layer.cornerRadius = 0
              fileInfoStackView.isHidden = true
              playInfoStackView.isHidden = true
              
              if let fileCount = data.childrensCount, fileCount > 0 {
                  fileCountLabel.isHidden = false
                  fileCountLabel.text = "\(fileCount)개의 항목"
              }
              else {
                  fileCountLabel.isHidden = true
              }
        }
        else {
            fileExtensionLabel.isHidden = false
            fileExtensionLabel.text = data.url.pathExtension
        }
        
        
        switch data.getFileType() {
            case .text:
                self.thumbnailImageView.layer.cornerRadius = 0
                fileInfoStackView.isHidden = false
                playInfoStackView.isHidden = true
                fileCountLabel.isHidden = true
            case .image:
                self.thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
                fileInfoStackView.isHidden = false
                playInfoStackView.isHidden = true
                fileCountLabel.isHidden = true
        
            case .video:
                self.thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
                fileInfoStackView.isHidden = false
                playInfoStackView.isHidden = false
                fileCountLabel.isHidden = true
            
                totalDurationLabel.text = data.totalDurationText
            
            case .audio:
                self.thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
                fileInfoStackView.isHidden = false
                playInfoStackView.isHidden = false
                fileCountLabel.isHidden = true
                
                totalDurationLabel.text = data.totalDurationText
            
            default:
                self.thumbnailImageView.layer.cornerRadius = 0
                break
        }
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.isUserInteractionEnabled = true
    }
}
