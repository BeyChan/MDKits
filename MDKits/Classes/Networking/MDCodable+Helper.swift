//
//  MDCodable+Helper.swift
//  SocialEras
//
//  Created by  MarvinChan on 2019/7/25.
//  Copyright © 2019 Yedao Inc. All rights reserved.
//

import Foundation

// MARK: - 扩展Encodable协议,添加编码的方法
public extension Encodable {
    
    /// 遵守Codable协议的对象转json字符串
    ///
    /// - Returns: json字符串
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /// 对象转换成jsonObject
    ///
    /// - Returns: jsonObject
    func toJSONObject() -> Any? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    /// 遵守Codable协议的对象转字典
    ///
    /// 对象转换成转字典
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else {
            return nil
        }
        guard let dict = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]) as [String : Any]??) else {
            return nil
        }
        return dict
    }
}
// MARK: - 扩展Decodable协议,添加解码的方法
public extension Decodable {
    
    /// json字符串转对象或者数组
    ///
    /// - Parameters:
    ///   - string: json字符串
    ///   - designatedPath: 目标路径
    /// - Returns: 对象
    static func decodeJSON(from string: String?, designatedPath: String? = nil) -> Self? {
        
        guard let data = string?.data(using: .utf8),
            let jsonData = getInnerObject(inside: data, by: designatedPath) else {
                return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    /// jsonObject转换对象或者数组
    ///
    /// - Parameters:
    ///   - jsonObject: json对象
    ///   - designatedPath: 目标路径
    /// - Returns: 对象
    static func decodeJSON(from jsonObject: Any?, designatedPath: String? = nil) -> Self? {
        
        guard let jsonObject = jsonObject,
            JSONSerialization.isValidJSONObject(jsonObject),
            let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
            let jsonData = getInnerObject(inside: data, by: designatedPath)  else {
                return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
}

// MARK: - 扩展Array,添加将jsonString或者jsonObject解码到对应对象数组的方法
public extension Array where Element: Codable {
    
    static func decodeJSON(from jsonData: Data?,designatedPath: String? = nil) -> [Element?]? {
        guard let data = jsonData,let jsonObject = ((try? JSONSerialization.jsonObject(with: data,
                                                                                     options: .allowFragments) as? [Any]) as [Any]??) else {
            return nil
        }
        return Array.decodeJSON(from: jsonObject)
    }
    
    static func decodeJSON(from jsonString: String?, designatedPath: String? = nil) -> [Element?]? {
        guard let data = jsonString?.data(using: .utf8),
            let jsonData = getInnerObject(inside: data, by: designatedPath),
            let jsonObject = ((try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any]) as [Any]??) else {
                return nil
        }
        return Array.decodeJSON(from: jsonObject)
    }
    
    static func decodeJSON(from array: [Any]?) -> [Element?]? {
        return array?.map({ (item) -> Element? in
            return Element.decodeJSON(from: item)
        })
    }
}


/// 借鉴HandyJSON中方法，根据designatedPath获取object中数据
///
/// - Parameters:
///   - jsonData: json data
///   - designatedPath: 获取json object中指定路径
/// - Returns: 可能是json object
fileprivate func getInnerObject(inside jsonData: Data?, by designatedPath: String?) -> Data? {
    
    /// 保证jsonData不为空，designatedPath有效
    guard let _jsonData = jsonData,
        let paths = designatedPath?.components(separatedBy: "."),
        paths.count > 0 else {
            return jsonData
    }
    /// 从jsonObject中取出designatedPath指定的jsonObject
    let jsonObject = try? JSONSerialization.jsonObject(with: _jsonData, options: .allowFragments)
    var result: Any? = jsonObject
    var abort = false
    var next = jsonObject as? [String: Any]
    paths.forEach({ (seg) in
        if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
            return
        }
        if let _next = next?[seg] {
            result = _next
            next = _next as? [String: Any]
        } else {
            abort = true
        }
    })
    /// 判断条件保证返回正确结果,保证没有流产,保证jsonObject转换成了Data类型
    guard abort == false,
        let resultJsonObject = result,
        let data = try? JSONSerialization.data(withJSONObject: resultJsonObject, options: []) else {
            return nil
    }
    return data
}
