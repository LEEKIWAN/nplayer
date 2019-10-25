//
//  PlayerSliderView.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/10/25.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

import Foundation

class PlayerSliderView: UIView {
   
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
        setUI()
        configureSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
        setUI()
        configureSlider()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("PlayerSliderView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {
    }
    
    

    func configureSlider() {
        backgroundColor = UIColor.clear
        
        sliderView.maximumValue = 1.0
        sliderView.minimumValue = 0.0
        sliderView.value = 0.0
        sliderView.maximumTrackTintColor = UIColor.clear
        sliderView.minimumTrackTintColor = UIColor.clear

        let thumbImage = UIImage(named: "VGPlayer_ic_slider_thumb")
        let normalThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 15, height: 15))
        sliderView.setThumbImage(normalThumbImage, for: .normal)
        let highlightedThumbImage = PlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 20, height: 20))
        sliderView.setThumbImage(highlightedThumbImage, for: .highlighted)

        
        progressView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7988548801)
        progressView.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2964201627)
    }

    open func setProgress(_ progress: Float, animated: Bool) {
        sliderView.value = progress
        progressView.setProgress(progress, animated: animated)
    }

    
}



//open class PlayerSlider: UISlider {
//
//    open var progressView : UIProgressView
//
//
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//
//    public override init(frame: CGRect) {
//        self.progressView = UIProgressView()
//        super.init(frame: frame)
//        configureSlider()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        self.progressView = UIProgressView()
//        super.init(coder: aDecoder)
//        configureSlider()
//    }
//
//
//
//    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
//        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
//        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y + 1, width: rect.width, height: rect.height)
//        return newRect
//    }
//
//    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = super.trackRect(forBounds: bounds)
//        let newRect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: 2))  // 2
//        configureProgressView(newRect)
//        return newRect
//    }
//
//
//
//}

