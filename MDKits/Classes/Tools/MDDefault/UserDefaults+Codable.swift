//
//  UserDefaults+Codable.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/17.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

extension MDKit where Base: UserDefaults {
    public func store<T: Codable>(_ value: T,
                           forKey key: String,
                           encoder: JSONEncoder = JSONEncoder()) {
        if let data: Data = try? encoder.encode(value) {
            (base as UserDefaults).set(data, forKey: key)
            (base as UserDefaults).synchronize()
        }
    }
    
    public func fetch<T>(forKey key: String,
                  type: T.Type,
                  decoder: JSONDecoder = JSONDecoder()) -> T? where T: Decodable {
        if let data = (base as UserDefaults).data(forKey: key) {
            return try? decoder.decode(type, from: data) as T
        }
        
        return nil
    }
}
