
//
//  SleepTimerPopupView.swift
//  VideoPlayer
//
//  Created by kiwan on 27/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

protocol SleepTimerPopupViewDelegate: class {
    func SleepTimerPopup(view: SleepTimerPopupView, hour: Int, minutes: Int)
    
}


class SleepTimerPopupView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: SleepTimerPopupViewDelegate?

    
    var hour: Int = 0
    var minutes: Int = 1
    
    let minutesArray: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var popupView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setNib()
        setUI()
        setEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNib()
        setUI()
        setEvent()
    }
    
    func setNib() {
        let view = Bundle.main.loadNibNamed("SleepTimerPopupView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setUI() {
        popupView.layer.cornerRadius = 10
    }
    
    func setEvent() {
        
    }
    
    // MARK : - Event
    
    @IBAction func onBackgroundTouched(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    @IBAction func onConfirmTouched(_ sender: UIButton) {
        self.removeFromSuperview()
        delegate?.SleepTimerPopup(view: self, hour: hour, minutes: minutes)
    }
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    // MARK : - UIPickerViewDelegate, UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return minutesArray.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) 시"
        case 1:
            return "\(minutesArray[row]) 분"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = minutesArray[row]
        default:
            break;
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component {
        case 0:
            return NSAttributedString(string: "\(row) 시", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        case 1:
            return NSAttributedString(string: "\(minutesArray[row]) 분", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        default:
            return NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    
    }

}

