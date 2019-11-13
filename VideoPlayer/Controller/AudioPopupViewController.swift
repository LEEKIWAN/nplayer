//
//  AudioPopupViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/13.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

class AudioPopupViewController: UIViewController {
    
    var videoView: VideoView?
    var mediaPlayer: VLCMediaPlayer?
    
    var dataArray: [VideoConfigObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "Text")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "Switch")
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "Slider")
        tableView.register(UINib(nibName: "StepperTableViewCell", bundle: nil), forCellReuseIdentifier: "Stepper")
        
        let subTitleText: String = getAudioInformation()
        let titleText: String = getAudioTitleName()
        
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: titleText, subTitle: subTitleText, selectedValue: "", isSelectAccesory: false ))
        dataArray.append(VideoConfigObject(style: .slider, switchIsOn: false, title: "증폭", subTitle: "", selectedValue: "0", isSelectAccesory: false ))
        dataArray.append(VideoConfigObject(style: .stepper, switchIsOn: false, title: "지연", subTitle: "0.00", selectedValue: "", isSelectAccesory: false ))
        dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: "이퀄라이저", subTitle: "", selectedValue: "기본값", isSelectAccesory: true ))
        
        tableView.reloadData()
    }
    
    func getAudioTitleName() -> String {
        guard let mediaPlayer = mediaPlayer else { return ""}
        
        if mediaPlayer.audioTrackNames!.count > 0 {
            return "\(mediaPlayer.audioTrackNames[mediaPlayer.audioTrackNames!.count - 1])"
        }
        return ""
    }
    
    func getAudioInformation() -> String {
        guard let mediaPlayer = mediaPlayer else { return ""}
        guard let tracksInformation = mediaPlayer.media?.tracksInformation else { return ""}
        
        var audioInfo: Dictionary<String, Any>? = nil
        
        for i in 0 ..< tracksInformation.count {
            let info = tracksInformation[i] as! Dictionary<String, Any>
            if info["type"] as! String == "audio" {
                audioInfo = info
            }
        }
        
        
        var subTitleText: String = ""
        
        if let audioInfo = audioInfo {
            let channels = "\(audioInfo["channelsNumber"] as! Int)ch"
            let bitrate = "\(audioInfo["rate"] as! Float / 1000)kHz"
            let codecFourCC = FourCharCode(integerLiteral: audioInfo["codec"] as! UInt32).toString()
            let languageCode = "\(audioInfo["language"] ?? "und")"
            
            subTitleText = " \(codecFourCC.toCodecName()) / \(channels) / \(bitrate) / \(languageCode)"
        }
        
        return subTitleText
    }
    
}



extension AudioPopupViewController: UITableViewDelegate, UITableViewDataSource {
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
        else if data.style == .slider {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Slider", for: indexPath) as! SliderTableViewCell
            cell.data = data
            cell.delegate = self
            return cell
        }
        else if data.style == .stepper {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Stepper", for: indexPath) as! StepperTableViewCell
            cell.data = data
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Switch", for: indexPath) as! SwitchTableViewCell
            cell.data = data
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

extension AudioPopupViewController: SliderCellDelegate {
    func sliderCellValueChanged(cell: SliderTableViewCell) {
        guard let mediaPlayer = mediaPlayer else { return }
        mediaPlayer.preAmplification = CGFloat((cell.data!.selectedValue as NSString).floatValue)
    }
}
