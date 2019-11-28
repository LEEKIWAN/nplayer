//
//  Int+.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/07.
//  Copyright © 2019 kiwan. All rights reserved.
//


extension Int {
    mutating func timeFormatted() -> String {
        if self < 0 {
            self = self * -1
        }
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)

        if hours > 0 {
            return "\(strHours):\(strMinutes):\(strSeconds)"
        }
        else {
            return "\(strMinutes):\(strSeconds)"
        }
        
    }

}


extension Int64 {
    var string: String {
        return ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
    
}

