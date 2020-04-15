//
//  DictionaryExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

//MARK:--- 重载运算符 两个字典合并为一个字典 ----------
public func += <key, value> ( cd_one: inout Dictionary<key, value>, cd_two: Dictionary<key, value>) {
    for (k, v) in cd_two {
        cd_one.updateValue(v, forKey: k)
    }
}
extension Dictionary {
    
    ///拼接字典
    mutating func addDictionary(_ para:Dictionary?) -> Dictionary{
        if para != nil {
            for (key,value) in para! {
                self[key] = value
            }
        }
        return self
    }
    
    ///判断是否存在
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    ///删除所有
    mutating func removeAll(keys: [Key]) {
        keys.forEach({ removeValue(forKey: $0)})
    }
    
    ///Json字典转Json字符串
    func jsonString(prettify: Bool = false) -> String? {
        
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    ///Json字典转Data
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
}
