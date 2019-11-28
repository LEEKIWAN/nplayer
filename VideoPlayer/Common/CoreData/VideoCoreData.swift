//
//  VideoCoreData.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/25.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import CoreData


public class VideoCoreData: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoCoreData> {
        return NSFetchRequest<VideoCoreData>(entityName: "Video")
    }

    
    
    @NSManaged public var todoName: String
    @NSManaged public var todoDescription: String
    @NSManaged public var todoImage: NSData?
    @NSManaged public var dateCreated: NSDate
}
