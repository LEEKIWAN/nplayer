//
//  String+.swift
//  VideoPlayer
//
//  Created by kiwan on 29/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}

