//
//  AVPlayer+.swift
//  VideoPlayer
//
//  Created by kiwan on 04/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
