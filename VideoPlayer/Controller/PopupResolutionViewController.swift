//
//  PopupResolutionViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/12.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

class PopupResolutionViewController: UIViewController {
    
    var mediaPlayer: VLCMediaPlayer?
    
    var dataArray: [VideoConfigObject] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "Text")
        
        
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "기본값", subTitle: "", selectedValue: "", isSelectAccesory: false))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "1:1", subTitle: "", selectedValue: "", isSelectAccesory: false))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "3:2", subTitle: "", selectedValue: "", isSelectAccesory: false))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "4:3", subTitle: "", selectedValue: "", isSelectAccesory: false))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "5:3", subTitle: "", selectedValue: "", isSelectAccesory: false))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "16:9", subTitle: "", selectedValue: "", isSelectAccesory: false))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "32:9", subTitle: "", selectedValue: "", isSelectAccesory: false))
        
        
        let checkedIndex = 0
        dataArray[checkedIndex].isSelectAccesory = true
        
        tableView.reloadData()
        
        //title
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "화면 비율"
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
}


extension PopupResolutionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath) as! TextTableViewCell
        cell.data = data
        
        if data.isSelectAccesory {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.tintColor = UIColor(hexFromString: "#F7C203")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for data in dataArray {
            data.isSelectAccesory = false
        }
        
        dataArray[indexPath.row].isSelectAccesory = true
        
        tableView.reloadData()
        
        guard let mediaPlayer = mediaPlayer else { return }
        
        let ratio = dataArray[indexPath.row].title
        mediaPlayer.videoAspectRatio = strdup(ratio)
        mediaPlayer.videoCropGeometry = nil
        
        
    }
}
