//
//  Date+.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/28.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

extension Date {
    var String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: self)
    }
}
