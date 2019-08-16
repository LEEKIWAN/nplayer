//
//  DirectoryMonitor.swift
//  VideoPlayer
//
//  Created by kiwan on 16/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import Dispatch
import UIKit


/// A protocol that allows delegates of `DirectoryMonitor` to respond to changes in a directory.
protocol DirectoryMonitorDelegate: class {
    func directoryMonitorDidObserveChange(directoryMonitor: DirectoryMonitor)
}

class DirectoryMonitor {
    // MARK: Properties
    
    deinit {
        stopMonitoring()
        close(monitoredDirectoryFileDescriptor)
    }
    
    
    /// The `DirectoryMonitor`'s delegate who is responsible for responding to `DirectoryMonitor` updates.
    weak var delegate: DirectoryMonitorDelegate?
    
    /// A file descriptor for the monitored directory.
    var monitoredDirectoryFileDescriptor: CInt = -1
    
    /// A dispatch queue used for sending file changes in the directory.
//    let directoryMonitorQueue = dispatch_queue_create("com.example.apple-samplecode.lister.directorymonitor", DISPATCH_QUEUE_CONCURRENT)
    
    let directoryMonitorQueue = DispatchQueue(label: "com.example.apple-samplecode.lister.directorymonitor", attributes: .concurrent)
    
    
    /// A dispatch source to monitor a file descriptor created from the directory.
    var directoryMonitorSource: DispatchSourceProtocol?
    
    /// URL for the directory being monitored.
    var URL: URL
    
    // MARK: Initializers
    init(URL: URL) {
        self.URL = URL
    }
    
    // MARK: Monitoring
    
    func startMonitoring() {
        // Listen for changes to the directory (if we are not already).
        if directoryMonitorSource == nil && monitoredDirectoryFileDescriptor == -1 {
            // Open the directory referenced by URL for monitoring only.
            monitoredDirectoryFileDescriptor = open(URL.path, O_EVTONLY)
            
            // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
//            directoryMonitorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, UInt(monitoredDirectoryFileDescriptor), DISPATCH_VNODE_WRITE, directoryMonitorQueue)
            
            
//            let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: queue);
//            directoryMonitorSource = DispatchSource.makeTimerSource(flags: <#T##DispatchSource.TimerFlags#>, queue: <#T##DispatchQueue?#>)
            directoryMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredDirectoryFileDescriptor, eventMask: .all, queue: DispatchQueue.global())

            
            
            // Define the block to call when a file change is detected.
//            dispatch_source_set_event_handler(directoryMonitorSource!) {
//                // Call out to the `DirectoryMonitorDelegate` so that it can react appropriately to the change.
//                self.delegate?.directoryMonitorDidObserveChange(self)
//
//                return
//            }
            
            directoryMonitorSource?.setEventHandler(handler: {
                self.delegate?.directoryMonitorDidObserveChange(directoryMonitor: self)
                return
            })
            
            
            // Define a cancel handler to ensure the directory is closed when the source is cancelled.
//            dispatch_source_set_cancel_handler(directoryMonitorSource!) {
//                close(self.monitoredDirectoryFileDescriptor)
//
//                self.monitoredDirectoryFileDescriptor = -1
//
//                self.directoryMonitorSource = nil
//            }
            
            directoryMonitorSource?.setCancelHandler(handler: {
                close(self.monitoredDirectoryFileDescriptor)
                self.monitoredDirectoryFileDescriptor = -1
                self.directoryMonitorSource = nil
            })
            
            
            // Start monitoring the directory via the source.
//            dispatch_resume(directoryMonitorSource!)
            
            directoryMonitorSource?.resume()
        }
    }
    
    func stopMonitoring() {
        // Stop listening for changes to the directory, if the source has been created.
        if directoryMonitorSource != nil {
            // Stop monitoring the directory via the source.
//            dispatch_source_cancel(directoryMonitorSource!)
            
            directoryMonitorSource?.cancel()
        }
    }
}
