//
//  ImageViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 31/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class ImageViewerController: UIViewController {
    
//    var data: FileObject?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard data != nil else {
//            return
//        }
//        
//        titleLabel.text = data?.fileName
//
//
//        if data?.extension.lowercased() == "gif" {
//            self.imageView.setGifFromURL(data!.url)
//        }
//        else {
//            self.imageView.image = UIImage(contentsOfFile: data!.filePath)
//        }
        
//
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if data?.extension.lowercased() == "gif" {
//            imageView.startAnimatingGif()
//        }
    }
    
    
    //MARK: - Event
    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDeleteTouched(_ sender: UIButton) {
        
    }
    
}
