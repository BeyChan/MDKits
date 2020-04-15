
//
//  KeyedDecodingContainer+Helper.swift
//  JsonToModel
//
//  Created by  MarvinChan on 2019/7/26.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation
// MARK: - 主要解决Codable类型错误导致解析失败
extension KeyedDecodingContainer {
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try? decode(type, forKey: key)
    }
}
// MARK: - decode String & Bool & Double
extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Float.self, forKey: key) {
            return String(value)
        }
        return nil
    }
    
    public func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            if let valueInt = Int(value) {
                return Bool(valueInt != 0)
            }
            return nil
        }
        if let value = try? decode(Int.self, forKey: key) {
            return Bool(value != 0)
        }
        return nil
    }
    
    public func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Double(value)
        }
        return nil
    }
}
// MARK: - decode Int
extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int8(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int16(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int32(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int64(value)
        }
        return nil
    }
}
// MARK: - decode UInt
extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return UInt(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return UInt8(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return UInt16(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return UInt32(value)
        }
        return nil
    }
    public func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return UInt64(value)
        }
        return nil
    }
    
}
// MARK: - decode Float
extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Float(value)
        }
        return nil
    }
}

