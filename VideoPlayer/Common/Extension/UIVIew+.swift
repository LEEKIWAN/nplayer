//
//  UIVIew+.swift
//  VideoPlayer
//
//  Created by kiwan on 26/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
