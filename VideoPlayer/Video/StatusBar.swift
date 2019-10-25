//
//  LandScapeStatusBar.swift
//  VideoPlayer
//
//  Created by 이기완 on 2019/10/26.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class StatusBar: UIView {
    let dateFormatter = DateFormatter()
    
    @IBOutlet var timeLabel: UILabel!
    
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
        let view = Bundle.main.loadNibNamed("StatusBar", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {

    }
    
    func configure() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBarInformation), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateStatusBarInformation() {
        let currentDate = Date()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        timeLabel.text = dateString
    }
}
