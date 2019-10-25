//
//  PlayerSliderView.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/10/25.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation


protocol PlayerSliderViewDelegate: class {
    func timeSliderTouchDown(sliderView: PlayerSliderView)
    func timeSliderTouchUpInside(sliderView: PlayerSliderView)
    func timeSliderValueChanged(sliderView: PlayerSliderView)
}


class PlayerSliderView: UIView {
    
    weak var delegate: PlayerSliderViewDelegate?
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
        setUI()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
        setUI()
        configure()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("PlayerSliderView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {

        self.progressView.tintColor = UIColor(hexFromString: "#F7C203", alpha: 0.7)
        self.progressView.backgroundColor = UIColor(hexFromString: "#F7C203", alpha: 0.5)
    }
    
    func configure() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(timeSliderValueChanged(_:)))
        progressView.addGestureRecognizer(panGesture)
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(timeSliderValueTouched(_:)))
        tapGesture.minimumPressDuration = 0
        progressView.addGestureRecognizer(tapGesture)
    }
    
    open func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }

    //MARK: - Evtn
    @objc func timeSliderValueChanged(_ recognizer: UIPanGestureRecognizer?) {
    }
    
    @objc func timeSliderValueTouched(_ recognizer: UILongPressGestureRecognizer?) {
        let location = recognizer?.location(in: recognizer?.view)
        let width = recognizer?.view?.frame.size.width ?? 0.0
        let pointX = location?.x ?? 0.0
        
        let currentValue = pointX / width
        progressView.setProgress(Float(currentValue), animated: false)
        
        
        switch recognizer?.state {
        case.began:
            delegate?.timeSliderTouchDown(sliderView: self)
        case .changed:
            let location = recognizer?.location(in: recognizer?.view)
            let width = recognizer?.view?.frame.size.width ?? 0.0
            let pointX = location?.x ?? 0.0
            
            let currentValue = pointX / width
            progressView.setProgress(Float(currentValue), animated: false)
            delegate?.timeSliderValueChanged(sliderView: self)            
        case .ended:
            delegate?.timeSliderTouchUpInside(sliderView: self)
        default:
            break
        }
        
    }
    
}
