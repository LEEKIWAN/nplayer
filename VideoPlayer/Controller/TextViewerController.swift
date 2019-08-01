//
//  TextViewerViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 01/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class TextViewerController: UIViewController {

    var data: FileObject?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if data?.extension.lowercased() == "gif" {
//            self.imageView.setGifFromURL(data!.url)
//        }
//        else {
            textView.text = try? String(contentsOfFile: data!.filePath, encoding: .utf8)
//        }
        
    }
    

    
    
    @IBAction func onCloseTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
