//
//  LandScapeStatusBar.swift
//  VideoPlayer
//
//  Created by 이기완 on 2019/10/26.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class StatusBar: UIView {
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    @IBOutlet weak var boundaryView: UIView!
    @IBOutlet weak var batterColorView: UIView!
    @IBOutlet weak var rechargeImageView: UIImageView!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    
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
        UIDevice.current.isBatteryMonitoringEnabled = true
        boundaryView.layer.cornerRadius = 2;
        
        self.updateStatusBarInformation()
    }
    
    func configure() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatusBarInformation), userInfo: nil, repeats: true)
    }
        
    @objc func updateStatusBarInformation() {
        let currentDate = Date()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        timeLabel.text = dateString
        
        // battery
        
        let batteryLevel = Int(self.batteryLevel * 100)
        batteryLevelLabel.text = "\(batteryLevel)%"
        
        if batteryLevel >= 20 {
            batterColorView.backgroundColor = UIColor(hexFromString: "#62D53F")
        }
        else {
            batterColorView.backgroundColor = UIColor(hexFromString: "#DD554A")
        }
        
        // 저전력
        if ProcessInfo.processInfo.isLowPowerModeEnabled {
            batterColorView.backgroundColor = UIColor(hexFromString: "#F8D74A")
        }
        
        
        switch batteryState {
        case .charging:
            rechargeImageView.isHidden = false
        default:
            rechargeImageView.isHidden = true
        }

//        print("current Battery State : \(batteryState.rawValue)")
    }
    
    
    
}
