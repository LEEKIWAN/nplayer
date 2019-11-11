//
//  VideoConfigObject.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/11.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

enum CellStyle {
    case text
    case `switch`
}

class VideoConfigObject {
    var style: CellStyle
    var switchIsOn: Bool
    var title: String
    var subTitle: String
    
    var selectedValue: String
    var isSelectAccesory: Bool
    
    init(style: CellStyle, switchIsOn: Bool, title: String, subTitle: String, selectedValue: String, isSelectAccesory: Bool) {
        self.style = style
        self.switchIsOn = switchIsOn
        self.title = title
        self.subTitle = subTitle
        self.selectedValue = selectedValue
        self.isSelectAccesory = isSelectAccesory

    }

}
