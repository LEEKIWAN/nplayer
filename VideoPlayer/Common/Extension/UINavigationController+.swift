//
//  UINavigationController+.swift
//  VideoPlayer
//
//  Created by kiwan on 30/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
