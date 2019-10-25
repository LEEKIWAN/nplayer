//
//  PlayerSlider.swift
//  VideoPlayer
//
//  Created by kiwan on 02/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

open class PlayerSlider: UISlider {
    
    open var progressView : UIProgressView
    
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        self.progressView = UIProgressView()
        super.init(frame: frame)
        configureSlider()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.progressView = UIProgressView()
        super.init(coder: aDecoder)
        configureSlider()
    }
    
    
    
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y + 1, width: rect.width, height: rect.height)
        return newRect
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.trackRect(forBounds: bounds)
        
        let newRect = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))  // 2
        configureProgressView(newRect)
        return newRect
    }
    
    func configureSlider() {
        maximumValue = 1.0
        minimumValue = 0.0
        value = 0.0
        maximumTrackTintColor = UIColor.clear
        //        minimumTrackTintColor = UIColor.white
        //        minimumTrackTintColor = UIColor(hexFromString: "#2D7FC1")
        minimumTrackTintColor = UIColor.clear
        
        
        let thumbImage = UIImage(named: "VGPlayer_ic_slider_thumb")
        let normalThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 15, height: 15))
        setThumbImage(normalThumbImage, for: .normal)
        let highlightedThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 20, height: 20))
        setThumbImage(highlightedThumbImage, for: .highlighted)
        
        backgroundColor = UIColor.clear
        
    }
    
    func configureProgressView(_ frame: CGRect) {
        print(frame)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
//        progressView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true // ---- 1
//        progressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true // ---- 2
//        progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true // ---- 3
        
        progressView.heightAnchor.constraint(equalToConstant: self.frame.size.height).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        
        
        
        progressView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7988548801)
        progressView.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2964201627)
        
        //        progressView.transform = CGAffineTransform(scaleX: 1, y: 6)
        insertSubview(progressView, at: 0)
        
    }
    
    open func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }
    
}
