//
//  SettingPopupViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 29/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class SettingPopupViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var contentsView: UIView!
    
    @IBOutlet weak var videoTabBarItem: UITabBarItem!
    @IBOutlet weak var audioTabBarItem: UITabBarItem!
    @IBOutlet weak var subtitleTabBarItem: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBackgroundTouched(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: - UITabBarDelegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == videoTabBarItem {
            let storyBoard = UIStoryboard(name: "SettingPopupViewController", bundle: nil)
            let videoVC = storyboard!.instantiateViewController(withIdentifier: "VIDEO_IDENTIFIER")
            
            contentsView.addSubview(videoVC.view)
            videoVC.view.frame = contentsView.bounds
            videoVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            videoVC.didMove(toParent: self)
        }
        else if item == audioTabBarItem {
                
            let storyBoard = UIStoryboard(name: "SettingPopupViewController", bundle: nil)
            let videoVC = storyboard!.instantiateViewController(withIdentifier: "AUDIO_IDENTIFIER")
            
            contentsView.addSubview(videoVC.view)
            videoVC.view.frame = contentsView.bounds
            videoVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            videoVC.didMove(toParent: self)
            
        }
        else if item == subtitleTabBarItem {
            
        }
        
    }
}
