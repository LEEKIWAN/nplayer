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
        let rect = super.trackRect(forBounds: bounds)
        let newRect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: 2))  // 2
        configureProgressView(newRect)
        return newRect
    }
    
    func configureSlider() {
        maximumValue = 1.0
        minimumValue = 0.0
        value = 0.0
        maximumTrackTintColor = UIColor.clear
        minimumTrackTintColor = UIColor.white
        
        let thumbImage = UIImage(named: "VGPlayer_ic_slider_thumb")
        let normalThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 15, height: 15))
        setThumbImage(normalThumbImage, for: .normal)
        let highlightedThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 20, height: 20))
        setThumbImage(highlightedThumbImage, for: .highlighted)
        
        backgroundColor = UIColor.clear
        progressView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7988548801)
        progressView.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2964201627)
    }
    
    func configureProgressView(_ frame: CGRect) {
        progressView.frame = frame
        insertSubview(progressView, at: 0)
    }
    
    open func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }
    
}
