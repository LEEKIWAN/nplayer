//
//  PreferenceManager.swift
//  VideoPlayer
//
//  Created by kiwan on 26/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation

class PreferenceManager {
    
    static let shared: PreferenceManager = PreferenceManager()
    
    
    // MARK: - Member Variable
    
    var contrast: Float {
        get {
            return UserDefaults.standard.float(forKey: "contrast")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "contrast")
            UserDefaults.standard.synchronize()
        }
    }
    
    var brightness: Float {
        get {
            return UserDefaults.standard.float(forKey: "brightness")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "brightness")
            UserDefaults.standard.synchronize()
        }
    }
    
    var hue: Float {
        get {
            return UserDefaults.standard.float(forKey: "hue")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hue")
            UserDefaults.standard.synchronize()
        }
    }
    
    var saturation: Float {
        get {
            return UserDefaults.standard.float(forKey: "saturation")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "saturation")
            UserDefaults.standard.synchronize()
        }
    }
    
    var gamma: Float {
        get {
            return UserDefaults.standard.float(forKey: "gamma")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "gamma")
            UserDefaults.standard.synchronize()
        }
    }
    
    var subtitleSize: Int {
        get {
            return UserDefaults.standard.integer(forKey: "subtitleSize")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subtitleSize")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
//    var serverLocation: String {
//        get {
//            return UserDefaults.standard.string(forKey: "serverLocation") ?? ""
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "serverLocation")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    var videoQuality: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: "videoQuality")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "videoQuality")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//
//    var videoBitrate: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: "videoBitrate")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "videoBitrate")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    var videoFramerate: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: "videoFramerate")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "videoFramerate")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    var audioBitrate: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: "audioBitrate")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "audioBitrate")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    var videoAudioUse: Bool {
//        get {
//            return UserDefaults.standard.bool(forKey: "videoAudioUse")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "videoAudioUse")
//            UserDefaults.standard.synchronize()
//        }
//    }
    
    
    // MARK: - initialize Values
    
    func initializeDefaultValues() {
        var defaultValues: [String : Any] = ["contrast" : 1.0, "brightness" : 1.0, "hue" : 1.0, "saturation" : 1.0, "gamma" : 1.0]
        
        defaultValues["subtitleSize"] = 10
        
        UserDefaults.standard.register(defaults: defaultValues)
    }
    
    
    
    // MARK: - revmove Values
    func removeAllPreferenceValues() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}




