//
//  VideoPopupViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/11.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class VideoPopupViewController: UIViewController {
    
    var videoView: VideoView?
    var mediaPlayer: VLCMediaPlayer?
    
    var dataArray: [VideoConfigObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "Text")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "Switch")
        
        let subTitleText: String = getVideoInformation()
        let titleText: String = getVideoTitleName()
        
        
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: titleText, subTitle: subTitleText, selectedValue: "", isSelectAccesory: false ))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "화면비율", subTitle: "", selectedValue: "기본값", isSelectAccesory: true ))
        dataArray.append(VideoConfigObject(style: .switch, switchIsOn: false, title: "좌우 반전", subTitle: "", selectedValue: "", isSelectAccesory: false ))
        dataArray.append(VideoConfigObject(style: .switch, switchIsOn: false, title: "상하 반전", subTitle: "", selectedValue: "", isSelectAccesory: false ))
        
    }
    
    func getVideoTitleName() -> String {
        guard let mediaPlayer = mediaPlayer else { return ""}
        
        if mediaPlayer.videoTrackNames!.count > 0 {
            return "\(mediaPlayer.videoTrackNames[mediaPlayer.videoTrackNames!.count - 1])"
        }
        return ""
    }
    
    func getVideoInformation() -> String {
        guard let mediaPlayer = mediaPlayer else { return ""}
        guard let tracksInformation = mediaPlayer.media?.tracksInformation else { return ""}
        
        
        
        var videoInfo: Dictionary<String, Any>? = nil
        
        for i in 0 ..< tracksInformation.count {
            let info = tracksInformation[i] as! Dictionary<String, Any>
            if info["type"] as! String == "video" {
                videoInfo = info
            }
        }
        
        
        var subTitleText: String = ""
        
        if let videoInfo = videoInfo {
            let videoResolution = "\(videoInfo["width"] as! Int)x\(videoInfo["height"] as! Int)"
            let codecFourCC = FourCharCode(integerLiteral: videoInfo["codec"] as! UInt32).toString()
            let languageCode = "\(videoInfo["language"] ?? "und")"
            subTitleText = "\(codecFourCC.toCodecName()), \(videoResolution), \(languageCode)"
        }
        
        return subTitleText
    }
    
}



extension VideoPopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataArray[indexPath.row]
        
        if data.style == .text {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath) as! TextTableViewCell
            cell.data = data
            
            if data.isSelectAccesory {
                cell.accessoryType = .disclosureIndicator
            }
            else {
                cell.accessoryType = .none
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Switch", for: indexPath) as! SwitchTableViewCell
            cell.data = data
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mediaPlayer = mediaPlayer else { return }
        guard let videoView = videoView else { return }

        let data = dataArray[indexPath.row]
        if data.isSelectAccesory {
            let storyBoard = UIStoryboard(name: "PopupResolutionViewController", bundle: nil)
            let resolustionViewController = storyBoard.instantiateInitialViewController() as! PopupResolutionViewController
            resolustionViewController.mediaPlayer = mediaPlayer
            resolustionViewController.videoView = videoView
            navigationController?.pushViewController(resolustionViewController, animated: true)
        }
    }
}

extension VideoPopupViewController: SwitchCellDelegate {
    func switchCellValueChanged(cell: SwitchTableViewCell) {
        let view: UIView = mediaPlayer?.drawable as! UIView
        
        let leftRightObject = dataArray.filter { (object) -> Bool in
            return object.title == "좌우 반전"
        }.first
        
        let upDownObject = dataArray.filter { (object) -> Bool in
            return object.title == "상하 반전"
        }.first
                
        
        if cell.data!.title == "좌우 반전" {
            UIView.transition(with: view, duration: 0.2, options: .transitionFlipFromRight, animations: {
                let upDownValue = upDownObject!.switchIsOn ? 1 : 0
                
                if cell.switch.isOn {
                    if upDownValue == 0 {
                        view.transform = CGAffineTransform(scaleX: -1, y: 1)
                    }
                    else {
                        view.transform = CGAffineTransform(scaleX: -1, y: -1)
                    }
                }
                else {
                    if upDownValue == 0 {
                        view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                    else {
                        view.transform = CGAffineTransform(scaleX: 1, y: -1)
                    }
                }
                
                cell.data!.switchIsOn = cell.switch.isOn
                
            }, completion: nil)
        }
        else if cell.data!.title == "상하 반전" {
            UIView.transition(with: view, duration: 0.2, options: .transitionFlipFromBottom, animations: {
                let leftRightValue = leftRightObject!.switchIsOn ? 1 : 0
                
                if cell.switch.isOn {
                    if leftRightValue == 0 {
                        view.transform = CGAffineTransform(scaleX: 1, y: -1)
                    }
                    else {
                        view.transform = CGAffineTransform(scaleX: -1, y: -1)
                    }
                }
                else {
                    if leftRightValue == 0 {
                        view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                    else {
                        view.transform = CGAffineTransform(scaleX: -1, y: 1)
                    }
                }
                
                cell.data!.switchIsOn = cell.switch.isOn
            }, completion: nil)
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
}

