//
//  MDCache.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/12.
//

import Foundation
import Cache


public enum MDExpiry: Equatable {
    /// Object will be expired in the nearest future
    case never
    /// Object will be expired in the specified amount of seconds
    case seconds(TimeInterval)
    /// Object will be expired on the specified date
    case date(Date)
    
    /// Returns the appropriate date object
    public var expiry: Expiry {
        switch self {
        case .never:
            return Expiry.never
        case .seconds(let seconds):
            return Expiry.seconds(seconds)
        case .date(let date):
            return Expiry.date(date)
        }
    }
    public var isExpired: Bool {
        return expiry.isExpired
    }
}

struct CacheModel: Codable {
    var data: Data?
    var dataDict: Dictionary<String, Data>?
}

class MDCache: NSObject {
    
    static let `default` = MDCache()
    /// Manage storage
    private var storage: Storage<CacheModel>?
    /// init
    override init() {
        super.init()
        expiryConfiguration()
    }
    var expiry: MDExpiry = .never
    
    func expiryConfiguration(expiry: MDExpiry = .never) {
        self.expiry = expiry
        let diskConfig = DiskConfig(
            name: Bundle.main.bundleIdentifier ?? "",
            expiry: expiry.expiry
        )
        let memoryConfig = MemoryConfig(expiry: expiry.expiry)
        do {
            storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: CacheModel.self))
        } catch {
            MDLog("\(error)")
        }
    }
    
    /// 清除所有缓存
    ///
    /// - Parameter completion: completion
    func removeAllCache(completion: @escaping (_ isSuccess: Bool)->()) {
        storage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    /// 根据key值清除缓存
    ///
    /// - Parameters:
    ///   - cacheKey: cacheKey
    ///   - completion: completion
    func removeObjectCache(_ cacheKey: String, completion: @escaping (_ isSuccess: Bool)->()) {
        storage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    /// 读取缓存
    ///
    /// - Parameter key: key
    /// - Returns: model
    func objectSync(forKey key: String) -> CacheModel? {
        do {
            ///过期清除缓存
            if let isExpire = try storage?.isExpiredObject(forKey: key), isExpire {
                removeObjectCache(key) { (_) in }
                return nil
            } else {
                return (try storage?.object(forKey: key)) ?? nil
            }
        } catch {
            return nil
        }
    }
    
    /// 异步缓存
    ///
    /// - Parameters:
    ///   - object: model
    ///   - key: key
    func setObject(_ object: CacheModel, forKey key: String) {
        storage?.async.setObject(object, forKey: key, expiry: nil, completion: { (result) in
            switch result {
            case .value(_):
                MDLog("缓存成功")
            case .error(let error):
                MDLog("缓存失败: \(error)")
            }
        })
    }
    
    static func getCacheKey(_ url: URL, parameters : [String : Any]? = nil, headers : [String: String]? = nil) -> String {
       var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
       var queryItems : [URLQueryItem] = []
       for parameter in parameters ?? [:] {
           let queryItem = URLQueryItem(name: parameter.key, value: "\(parameter.value)")
           queryItems.append(queryItem)
           urlComponents?.queryItems = queryItems
       }
       let urlPath = urlComponents?.url?.description
       let headerStr = headers?.keys.sorted().reduce("") { $0 + $1 + (headers?[$1] ?? "")}
       return MD5([urlPath, headerStr].compactMap{$0}.joined())
    }
}
