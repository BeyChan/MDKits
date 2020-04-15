//
//  MDNetworking.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/12.
//

import Foundation
import Alamofire


public struct MDDecoderConfig {
    /// 模型的键值路径
    public let keyPath: String?
    
    /// 回调的线程
    public let queue: DispatchQueue?
    
    /// decoder
    public let decoder: JSONDecoder?
    
    /// 初始化方法
    public init(keyPath: String? = nil, queue: DispatchQueue? = nil,decoder: JSONDecoder? = nil) {
        self.keyPath = keyPath
        self.queue = queue
        self.decoder = decoder
    }
}

public class MDNetworking {
    private init() {}
    
    public static let `default`: MDNetworking = MDNetworking()
    
    public var baseURL : URL?
    
    /// 开启/关闭请求url log
    public var openUrlLog: Bool = true
    /// 开启/关闭结果log
    public var openResultLog: Bool = true
    
    /// 默认的StatusCodes校验
     private static let defaultStatusCodes = Array(200..<300)
     
     ///  默认的ContentTypes校验
     private static let defaultContentTypes = ["*/*"]

    /// 配置缓存过期时间
    ///
    /// - Parameter expiry: 参考 DaisyExpiry
    public func cacheExpiryConfig(expiry: MDExpiry) {
        MDCache.default.expiryConfiguration(expiry: expiry)
    }
    
    
    lazy var sessionManager: SessionManager = {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            /// 正式环境的证书配置,修改成自己项目的正式url
            "b.socialeras.com": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            ),
            /// 测试环境的证书配置,不验证证书,无脑通过
            "testb.socialeras.com": .disableEvaluation
        ]
        config.timeoutIntervalForRequest = 30
        /// 根据config创建manager
        return SessionManager(configuration: config,
                              delegate: SessionDelegate(),
                              serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    func buildURL(url : MDURLConvertible) -> MDURLConvertible {
        if let asURL = url.urlValue {
            if asURL.host == nil && baseURL != nil {
                var urlComponents = URLComponents(url: asURL, resolvingAgainstBaseURL:false)
                urlComponents?.host = baseURL?.host
                urlComponents?.scheme = baseURL?.scheme
                urlComponents?.port = baseURL?.port
                let path = (baseURL?.path ?? "") + (urlComponents?.path ?? "")
                urlComponents?.path = path
                let newURL = urlComponents?.url
                assert(newURL != nil)
                return newURL!
            }
        }
        return url
    }
    
    
    @discardableResult
    public static func requestData<T: Codable>(url: MDURLConvertible,
                                        method: MDRequestMethod = .get,
                                        parameters : [String : Any]? = nil,
                                        headers : MDRequestHeaders? = nil,
                                        decoderConfig: MDDecoderConfig? = nil,
                                        encoding: MDRequestEncoding = .json,
                                        cache: Bool = false,
                                        completion: @escaping MDResponseResultHandle<T>) -> URLSessionTask?{
        
        guard let newUrl = MDNetworking.default.buildURL(url: url).urlValue else {
            return nil
        }
        let cacheKey = MDCache.getCacheKey(newUrl, parameters: parameters, headers: headers)
        
        //  打印请求API
        if MDNetworking.default.openUrlLog {
            MDLog("MDNetwoking ## API Request ## \(method) ## \(newUrl) ## parameters = \(parameters ?? [:])")
        }
        ///  检查网络
        guard MDNetworkListener.shared.isReachable else {
            let failure = MDResponseResult<T>.Failure(cache: nil, data: nil, otherError: .networkNotReachable, error: nil, httpURLResponse: nil)
            completion(.failure(failure))
            /// 使用缓存
            if cache {
                self.responseCacheHandler(cacheKey: cacheKey, completion: completion)
            }
            return nil
        }
        
        MDNetworking.indicatorRun()
        
        let dataRequest =  MDNetworking.default.sessionManager.request(newUrl, method: method.toAlamofireMethod(), parameters: parameters, encoding: encoding.toAlamofireEncoding(), headers: headers).validate(statusCode: defaultStatusCodes).validate(contentType: defaultContentTypes)

        dataRequest.responseDecodableObject(queue: decoderConfig?.queue,
                                            keyPath: decoderConfig?.keyPath,
                                            decoder: decoderConfig?.decoder ?? JSONDecoder())
        { (response: DataResponse<T>) in
            
            MDNetworking.self.indicatorStop()
            
       
            ///  data -> jsonString
            let jsonString: String?
            if let data = response.data {
                jsonString = String(data: data, encoding: .utf8)
            }else {
                jsonString = nil
            }
            
        /// 进行结果答应
           if MDNetworking.default.openResultLog {
            MDLog("MDNetwoking ## API Response ## \(url) ## data = \(String(describing: jsonString)))")
           }
            switch response.result {
            case .success(let value):
                if cache {
                    var model = CacheModel()
                    model.data = response.data
                    MDCache.default.setObject(model, forKey: cacheKey)
                }
                let success = MDResponseResult.Success(codableModel: value, data: response.data, jsonString: jsonString, httpURLResponse: response.response)
                completion(.success(success))
            case .failure(let error):
                let err = error as NSError
                let mdErr = MDError(code: err.code, massage: err.localizedDescription)
                let failure = MDResponseResult<T>.Failure(cache: nil, data: response.data, otherError: nil, error: mdErr, httpURLResponse: response.response)
                completion(.failure(failure))
                MDHUD.showError(mdErr)
            }
        }
        return dataRequest.task
    }
    
    
    /// 响应缓存回调
    ///
    /// - Parameters:
    ///   - url: 请求网址
    ///   - callbackHandler: 回调
    private static func responseCacheHandler<T: Codable>(cacheKey: String, completion: @escaping MDResponseResultHandle<T>) {
        if let data = MDCache.default.objectSync(forKey: cacheKey)?.data {
            let cache = try? JSONDecoder().decode(T.self, from: data)
            let failure = MDResponseResult<T>.Failure(cache: cache, data: data, otherError: .networkNotReachable, error: nil, httpURLResponse: nil)
            completion(.failure(failure))
        }else {
            let failure = MDResponseResult<T>.Failure(cache: nil, data: nil, otherError: .readJSONCacheFailed, error: nil, httpURLResponse: nil)
            completion(.failure(failure))
        }
    }
    
}

// MARK: - 上传
extension MDNetworking {
    // 文件上传
    ///
    /// - Parameters:
    ///   - sessionManage: Alamofire.SessionManager
    ///   - url: 请求完整网址
    ///   - uploadStream: 上传的数据流
    ///   - parameters: 请求字段
    ///   - headers: 请求头
    ///   - size: 文件的size 长宽
    ///   - mimeType: 文件类型 详细看FawMimeType枚举
    ///   - callbackHandler: 上传回调
    public static func uploadData(sessionManager: SessionManager = SessionManager.background,
                                  url: MDURLConvertible,
                                  uploadStream: MDUploadStream,
                                  parameters: [String: Any]? = nil,
                                  headers: MDRequestHeaders? = nil,
                                  size: CGSize? = nil,
                                  mimeType: MDMimeType,
                                  callbackHandler: MDUploadCallbackHandler) {
        
        guard let newUrl = MDNetworking.default.buildURL(url: url).urlValue else { return }
        //  检查网络
        guard MDNetworkListener.shared.isReachable else {
            MDLog("没有网络!")
            return
        }
        
        
        //  请求头的设置
        var uploadHeaders = ["Content-Type": "multipart/form-data;charset=UTF-8"]
        if let unwappedHeaders = headers {
            uploadHeaders.merge(unwappedHeaders) { (current, new) -> String in return current }
        }
        
        //  如果有多媒体的宽高信息,就加入headers中
        if let mediaSize = size {
            uploadHeaders.updateValue("\(mediaSize.width)", forKey: "width")
            uploadHeaders.updateValue("\(mediaSize.height)", forKey: "height")
        }
        
        //  菊花转
        MDNetworking.indicatorRun()
        
        //  开始请求
        sessionManager.upload(multipartFormData: { multipartFormData in
            
            //  表单处理
            
            //  是否有请求字段
            if let params = parameters as? [String: String] {
                for (key, value) in params {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
            
            //  数据上传
            for (key, value) in uploadStream {
                multipartFormData.append(value, withName: key, fileName: key + mimeType.fileName, mimeType: mimeType.type)
            }
        },
                              to: newUrl,
                              headers: uploadHeaders,
                              encodingCompletion: { encodingResult in
                                
                                //  菊花转结束
                                MDNetworking.self.indicatorStop()
                                
                                //  响应请求结果
                                switch encodingResult {
                                case .success(let uploadRequest, _ , let streamFileURL):
                                    
                                    uploadRequest.responseJSON(queue: callbackHandler.queue) { (response) in
                                        switch response.result {
                                        case .success(let value):
                                            callbackHandler.result?(streamFileURL, true, nil, value as? [String: Any])
                                        case .failure(let error):
                                            callbackHandler.result?(streamFileURL, false, error ,nil)
                                        }
                                    }
                                    
                                    uploadRequest.uploadProgress(queue: callbackHandler.progressQueue ?? DispatchQueue.main) { progress in
                                        callbackHandler.progress?(streamFileURL, progress)
                                    }
                                    
                                case .failure(let error):
                                    callbackHandler.result?(nil, false, error, nil)
                                }
        })
        
    }
    
    /// 通过文件路径进行上传
    ///
    /// - Parameters:
    ///   - sessionManager: Alamofire.SessionManager
    ///   - filePath: 文件路径字符串
    ///   - url: 请求网址
    ///   - method: 请求方法
    ///   - headers: 请求头
    ///   - callbackHandler: 上传回调
    public static func uploadFromeFilePath(filePath: String,
                                           to url: MDURLConvertible,
                                           method: MDRequestMethod = .post,
                                           headers: MDRequestHeaders? = nil,
                                           callbackHandler: MDUploadCallbackHandler) {
        
        //  检查网络
        guard MDNetworkListener.shared.isReachable else {
            MDLog("没有网络!")
            return
        }
        
        //  文件路径
        let fileUrl = URL(fileURLWithPath: filePath)
        
        guard let newUrl = MDNetworking.default.buildURL(url: url).urlValue else { return }
        
        let uploadRequest = Alamofire.upload(fileUrl, to: newUrl)
        
        //  上传结果
        uploadRequest.responseJSON(queue: callbackHandler.queue) { (response) in
            switch response.result {
            case .success(let value):
                callbackHandler.result?(fileUrl, true, nil, value as? [String: Any])
            case .failure(let error):
                callbackHandler.result?(fileUrl, false, error ,nil)
            }
        }
        
        //  上传进度
        uploadRequest.uploadProgress(queue: callbackHandler.progressQueue ?? DispatchQueue.main) { (progress) in
            callbackHandler.progress?(fileUrl, progress)
        }
    }
    
}

// MARK: - 下载的网络请求
extension MDNetworking {
    /// 文件下载
    ///
    /// - Parameters:
    ///   - sessionManager: Alamofire.SessionManage
    ///   - url: 请求网址
    ///   - parameters: 请求字段
    ///   - headers: 请求头
    ///   - callbackHandler: 下载回调
    /// - Returns: 下载任务字典
    public static func downloadData(sessionManager: SessionManager = SessionManager.background,
                                    url: MDURLConvertible,
                                    parameters: [String: Any]? = nil,
                                    headers: MDRequestHeaders?? = nil,
                                    downloadDestinationURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
                                    callbackHandler: MDDownloadCallbackHandler) -> DownloadRequestTask? {
        
        guard let url = url.urlValue?.absoluteString else {
            return nil
        }
        
        //  检查网络
        guard MDNetworkListener.shared.isReachable else {
            MDLog("没有网络!")
            return nil
        }
        //  创建路径
        let destination: DownloadRequest.DownloadFileDestination = { temporaryURL, response in
            let fileURL = downloadDestinationURL.appendingPathComponent(response.suggestedFilename ?? "temp.tmp")
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //  状态栏的菊花转开始
        MDNetworking.indicatorRun()
        
        
        //  如果有临时数据那么就断点下载
        if let resumData = MDDiskStorage.getResumeData(url: url) {
            return downloadResumData(sessionManager: sessionManager, url: url, resumData: resumData, to: destination, callbackHandler: callbackHandler)
        }
        
        let downloadRequest = sessionManager.download(url, parameters: parameters, to: destination).responseData(queue: callbackHandler.queue) { (responseData) in
            
            //  状态栏的菊花转结束
            self.indicatorStop()
            
            //  响应请求结果
            switch responseData.result {
            case .success(let value):
                callbackHandler.success?(responseData.temporaryURL, responseData.destinationURL, value)
            case .failure(let error):
                callbackHandler.failure?(responseData.resumeData, responseData.temporaryURL, error, responseData.response?.statusCode)
                
                //  将请求失败而下载的部分数据存下来,下次进行
                MDDiskStorage.write(data: responseData.resumeData, by: url) { (isOK) in
                    MDLog("写入下载失败而下载的部分数据缓存\(isOK ? "成功" : "失败")")
                }
                
            }
            
            //  回调有响应,将任务移除
            self.downloadRequestTask.removeValue(forKey: url)
        }
        
        //  下载进度的回调
        downloadRequest.downloadProgress(queue: callbackHandler.progressQueue ?? DispatchQueue.main) { (progress) in
            callbackHandler.progress?(progress)
        }
        
        downloadRequestTask.updateValue(downloadRequest, forKey: url)
        return [url: downloadRequest]
    }
    
    /// 断点续下载的方法
    /// 这个方法更多的是配合上面的方法进行使用
    /// - Parameters:
    ///   - sessionManager: Alamofire.SessionManage
    ///   - url: 请求网址
    ///   - resumData: 续下载的数据
    ///   - destination: 目的路径
    ///   - callbackHandler: 下载回调
    /// - Returns: 下载任务字典
    @discardableResult
    public static func downloadResumData(sessionManager: SessionManager = SessionManager.background,
                                         url: MDURLConvertible,
                                         resumData: Data,
                                         to destination: DownloadRequest.DownloadFileDestination? = nil,
                                         callbackHandler: MDDownloadCallbackHandler) -> DownloadRequestTask {
        
        guard let url = url.urlValue?.absoluteString else {
            return [:]
        }
        
        let downloadRequest = sessionManager.download(resumingWith: resumData, to: destination).responseData(queue: callbackHandler.queue) { (responseData) in
            
            //  状态栏的菊花转结束
            self.indicatorStop()
            
            MDLog("MDNetworking ## API Response ## \(String(describing: url)) ## data = \(String(describing: responseData))")
            
            //  响应请求结果
            switch responseData.result {
            case .success(let value):
                callbackHandler.success?(responseData.temporaryURL, responseData.destinationURL, value)
                try? FileManager.default.removeItem(atPath: MDDiskStorage.getFilePath(url: url))
            case .failure(let error):
                callbackHandler.failure?(responseData.resumeData, responseData.temporaryURL, error, responseData.response?.statusCode)
                
                //  将请求失败而下载的部分数据存下来,下次进行
                MDDiskStorage.write(data: responseData.resumeData, by: url) { (isOK) in
                    MDLog("写入下载失败而下载的部分数据缓存\(isOK ? "成功" : "失败")")
                }
            }
            
            //  回调有响应,将任务移除
            downloadRequestTask.removeValue(forKey: url)
            
        }
        
        //  下载进度的回调
        downloadRequest.downloadProgress(queue: callbackHandler.progressQueue ?? DispatchQueue.main) { (progress) in
            callbackHandler.progress?(progress)
        }
        
        downloadRequestTask.updateValue(downloadRequest, forKey: url)
        return [url: downloadRequest]
    }
}

// MARK: - 存储下载任务的字典 用于通过url获取下载任务 进而进行暂停/恢复/取消等操作
public typealias DownloadRequestTask = [String: DownloadRequest]

extension MDNetworking {
    
    /// 下载任务
    public static var downloadRequestTask = DownloadRequestTask()
    
    /// 通过url暂停下载任务
    /// 
    ///
    /// - Parameter url: 请求网址
    public static func suspendDownloadRequest(url: URLConvertible) {
        guard let url = try? url.asURL().absoluteString, let downloadRequest = downloadRequestTask[url] else {
            return
        }
        downloadRequest.suspend()
    }
    
    /// 通过url继续下载任务
    ///
    /// - Parameter url: 请求网址
    public static func resumeDownloadRequest(url: URLConvertible) {
        guard let url = try? url.asURL().absoluteString, let downloadRequest = downloadRequestTask[url] else {
            return
        }
        downloadRequest.resume()
    }
    
    /// 通过url取消下载任务
    ///
    /// - Parameter url: 请求网址
    public static func cancelDownloadRequest(url: URLConvertible) {
        guard let url = try? url.asURL().absoluteString, let downloadRequest = downloadRequestTask[url] else {
            return
        }
        downloadRequest.cancel()
    }
}




extension MDNetworking {
    /// 菊花转开始
    
    static func indicatorRun() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    /// 菊花转停止
    static func indicatorStop() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


public extension SessionManager {
    /// https://stackoverflow.com/questions/41482187/keep-alive-not-working-properly-on-ios
    /// httpShouldUsePipelining -> true, Connection: Keep-Alive
    /// 自定义的sessionManager
    static var custom: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.httpShouldUsePipelining = true
        return SessionManager(configuration: configuration)
    }()
    
    /// 后台的sessionManager
    static var background: SessionManager = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.socialeras.shop.background.transfer")
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 300
        configuration.httpShouldUsePipelining = true
        return SessionManager(configuration: configuration)
    }()
}

