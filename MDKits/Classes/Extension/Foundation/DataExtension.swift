//
//  DataExtension.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/11/21.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

extension Data {
    
    /// 推送DeviceToken
    var deviceToken:String {
        var deviceToken: String = ""
        let bytes = [UInt8](self)
        for item in bytes {
            deviceToken += String(format: "%02x", item&0x000000FF)
        }
        return deviceToken
    }
}
