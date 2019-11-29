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
    
    fileprivate let queue = DispatchQueue(label: "FileMonitorQueue", target: .main)

    
    /// A dispatch source to monitor a file descriptor created from the directory.
    var directoryMonitorSource: DispatchSourceFileSystemObject?
    var readSource: DispatchSourceRead!

    /// URL for the directory being monitored.
    var URL: URL
    
    var addedFile: FileObject?
    
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
            directoryMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredDirectoryFileDescriptor, eventMask: .write, queue: queue)

            directoryMonitorSource?.setEventHandler(handler: {
                self.delegate?.directoryMonitorDidObserveChange(directoryMonitor: self)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let addedFile = self.addedFile else { return }
                    let fileHandle = try! FileHandle(forReadingFrom: addedFile.url)
                    
                    self.readSource = DispatchSource.makeReadSource(fileDescriptor: fileHandle.fileDescriptor, queue: self.queue)
                    self.readSource.setEventHandler {
                        fileHandle.readToEndOfFileInBackgroundAndNotify()

                    }
                    self.readSource.resume()
                    
                    self.readSource.setCancelHandler {
                        fileHandle.closeFile()
                    }
                    print("!!!!!!!!!!!!!!!!!!")
                }
                
                return
            })
            
            directoryMonitorSource?.setCancelHandler(handler: {
                close(self.monitoredDirectoryFileDescriptor)
                self.monitoredDirectoryFileDescriptor = -1
                self.directoryMonitorSource = nil
            })
            
            
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
