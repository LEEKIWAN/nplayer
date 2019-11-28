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
    
    
    
    
    init(fourCharCode: FourCharCode) {
        let n = Int(fourCharCode)
        var s: String = ""
        
        let unicodes = [UnicodeScalar((n >> 24) & 255), UnicodeScalar((n >> 16) & 255), UnicodeScalar((n >> 8) & 255), UnicodeScalar(n & 255)]
        unicodes.compactMap { (unicode) -> String? in
            guard let unicode = unicode else { return nil }
            return String(unicode)
        }.forEach { (unicode) in
            s.append(unicode)
        }
        
        self = s.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    
    func toCodecName() -> String {
        let textValue = self
        
        switch textValue {
        case "h264":
            return "H.264"
        case "h265":
            return "H.265"
        case "mp4v", "m4s2":
            return "MPEG-4"
        case "mp3":
            return "MP3"
        case "AAC", "AACP", "MP4A", "mp4a", "VLB":
            return "AAC"
            
        default:
            return "MPEG-4"
        }
        
    }
    
    
    
}

extension String {
    func season() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "S(\\d{1,2})", options: .caseInsensitive) {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
        }

        return []
    }
    
    func episode() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "E(\\d{1,2})", options: .caseInsensitive) {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
        }

        return []
    }
    
    
    func title() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "([ .\\w]+?)(\\W\\d{4})", options: .caseInsensitive) {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                var title = string.substring(with: $0.range)
                title.removeLast(5)
                return title
            }
        }

        return []
    }
    
    
    
}

