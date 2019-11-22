//
//  SubTitlePopupViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/08.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation


class SubTitlePopupViewController: UIViewController {
    
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
        
        
        updateTableViewData()
        tableView.reloadData()
    }
    
    func updateTableViewData() {
        dataArray.removeAll()
        dataArray.append(VideoConfigObject(style: .switch, switchIsOn: true, title: "자막보기", subTitle: "", selectedValue: "", isSelectAccesory: false ))
        
        guard let subTitleNames = mediaPlayer?.videoSubTitlesNames else { return }
        
        for i in 0 ..< subTitleNames.count {
            let currentSubTitleIndex = mediaPlayer!.currentVideoSubTitleIndex
            if subTitleNames[i] as! String == "Disable" {
                continue
            }
            
            if i == currentSubTitleIndex - 1 {
                dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: subTitleNames[i] as! String, subTitle: "", selectedValue: "", isSelectAccesory: true))
            }
            else {
                dataArray.append(VideoConfigObject(style: .text, switchIsOn: false, title: subTitleNames[i] as! String, subTitle: "", selectedValue: "", isSelectAccesory: false))
            }
            
        }
        
        if subTitleNames.count > 0 {
            dataArray.append(VideoConfigObject(style: .stepper, switchIsOn: false, title: "지연", subTitle: "0.00", selectedValue: "", isSelectAccesory: false ))
        }
        
        
    }
}



extension SubTitlePopupViewController: UITableViewDelegate, UITableViewDataSource {
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
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        else if data.style == .stepper {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Stepper", for: indexPath) as! StepperTableViewCell
            cell.data = data
            cell.delegate = self
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
        if dataArray[indexPath.row].style != .text {
            return
        }
//2 gksrnrdj 3영어ㅕ
        
        let subTitleIndex = indexPath.row + 1
        print(Int32(subTitleIndex))
        mediaPlayer?.currentVideoSubTitleIndex = Int32(subTitleIndex)
        
        
        updateTableViewData()
        tableView.reloadData()
        
    }
}


extension SubTitlePopupViewController: StepperCellDelegate {
    func stepperCellValueChanged(cell: StepperTableViewCell) {
        guard let mediaPlayer = mediaPlayer else { return }
        let value = (cell.data!.selectedValue as NSString).floatValue * 1000000
        mediaPlayer.currentVideoSubTitleDelay = Int(value)
    }
}


extension SubTitlePopupViewController: SwitchCellDelegate {
    func switchCellValueChanged(cell: SwitchTableViewCell) {
        if cell.switch.isOn {
            dataArray[0].switchIsOn = true
            updateTableViewData()
            tableView.reloadData()
        }
        else {
            dataArray[0].switchIsOn = false
            for i in (0 ..< dataArray.count).reversed() {
                if i == 0 {
                    continue
                }
                dataArray.remove(at: i)
            }
            
            mediaPlayer?.currentVideoSubTitleIndex = -1
            tableView.reloadData()
        }
        
    }
}


