//
//  SettingTabBarController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/10/02.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class SettingTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.view.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
        
//        self.view.layoutMargins = UIEdgeInsets(top: 200, left: 100, bottom: 200, right: 100)
        
        
//        self.view.bounds = view.frame.inset(by: UIEdgeInsets(top: 100, left: 30, bottom: 100, right: 30))
        
        view.frame = view.frame.inset(by: UIEdgeInsets(top: .zero, left: 5.0, bottom: 5.0, right: .zero))

    }

}
