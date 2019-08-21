//
//  CustomSlider.swift
//  VideoPlayer
//
//  Created by kiwan on 07/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class CustomSlider: UIView {
    
    var progressView = UIView()
    
    var maximumValue: Double = 1.0
    var minimumValue: Double = 0
    var value: CGFloat = 0 {
        didSet {
            let frameX = self.frame.width * value
            self.progressView.frame = CGRect(x: 0, y: 0, width: frameX, height: self.frame.height)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.height)
        progressView.backgroundColor = UIColor(hexFromString: "#F7C203", alpha: 0.8)
        self.addSubview(self.progressView)
    }
    
    
    
    
    open func setProgress(_ progress: Float, animated: Bool) {
        
    }
    
}
