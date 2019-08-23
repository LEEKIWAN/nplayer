
//
//  UIPanGestureRecognizer+.swift
//  VideoPlayer
//
//  Created by kiwan on 22/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation


enum GestureDirection {
    case vertical
    case horizontal
}

public enum Direction: Int {
    case Up
    case Down
    case Left
    case Right
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}

public extension UIPanGestureRecognizer {
    
    var direction: Direction? {
//        let velocity = velocity(in: view)
        let velocit = velocity(in: view)
        let vertical = abs(velocit.y) > abs(velocit.x)
        switch (vertical, velocit.x, velocit.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return nil
        }
    }
}
