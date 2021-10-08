//
//  NetManager.swift
//  Framework
//
//  Created by able on 2017/3/24.
//  Copyright © 2017年 able. All rights reserved.
//
//  网络请求工具类

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON


class NetTool {
    /// 网络请求进度回调
    typealias ProgressHandler = (Float) -> Void
    /// 网络请求完成回调
    typealias CompletionHandler = (RequestResult) -> Void
    
    class var sessionManager: SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let manager = SessionManager.init(configuration: configuration)
        return manager
    }
}


//MARK: - 完整URL拼接以及参数加密
extension NetTool {

    
    class var kHost: String {
        return "http://www.mingtangshijia.com/api.php/"
    }
    
    /// 根据子路径获取完整url
    class func fullUrl(with path: String) -> String {
        return path.hasPrefix("http") ? path : kHost + path
    }
    
    
    /// 拼接加密参数并加密密码
    class func encryption(_ params: [String: Any]?) -> [String: Any]! {
        var parameDic = params ?? [String : Any]()
        if let token = UserDefaults.standard.token {
            parameDic["token"] = token
        }
        return parameDic
    }
    
    class func printFullPath(with path: String, params: [String: Any]?) {
        let url = fullUrl(with: path)
        let secretParams = encryption(params)!
        var postUrl = url + "?"
        for key in secretParams.keys {
            let value = secretParams[key] ?? ""
            postUrl += "\(key)=\(value)&"
        }
        postUrl.removeLast()
        print(postUrl)
    }
    
}

//MARK: - 基础网络请求
extension NetTool {
    
    /// 发起post网络请求
    ///
    /// - Parameters:
    ///   - path: 网络请求路径
    ///   - params: 参数列表(默认为空)
    ///   - completionHandler: 请求完成回调(默认为空)
    /// - Returns: 网络请求对象
    @discardableResult
    class func post(with path: String,
                    analysisPath: [JSONSubscriptType] = [JSONSubscriptType](),
                    params: [String: Any]? = nil,
                    completionHandler: CompletionHandler? = nil)
        -> DataRequest {
            let url = fullUrl(with: path)
            let secretParams = encryption(params)!
            printFullPath(with: path, params: params)
            return Alamofire.request(url, method: .post, parameters: secretParams).responseData {
                guard let completionHandler = completionHandler else { return }
                let result = RequestResult(response: $0, path: analysisPath)
                completionHandler(result)
            }
    }
    
    /// 发起get网络请求
    ///
    /// - Parameters:
    ///   - path: 网络请求路径
    ///   - params: 参数列表(默认为空)
    ///   - completionHandler: 请求完成回调(默认为空)
    /// - Returns: 网络请求对象
    @discardableResult
    class func get(with path: String,
                    analysisPath: [JSONSubscriptType] = [JSONSubscriptType](),
                    params: [String: Any]? = nil,
                    completionHandler: CompletionHandler? = nil)
        -> DataRequest {
            let url = fullUrl(with: path)
            let secretParams = encryption(params)!
            printFullPath(with: path, params: secretParams)
            return Alamofire.request(url, method: .get, parameters: secretParams).responseData {
                guard let completionHandler = completionHandler else { return }
                let result = RequestResult(response: $0, path: analysisPath)
                completionHandler(result)
            }
    }
}

extension NetTool {
    /// 发起post网络请求
    ///
    /// - Parameters:
    ///   - path: 网络请求路径
    ///   - params: 参数列表(默认为空)
    ///   - completionHandler: 请求完成回调(默认为空)
    /// - Returns: 网络请求对象
    @discardableResult
    class func loadModel<T>(_ path: String,
                            method: HTTPMethod,
                            analysisPath: [JSONSubscriptType] = [JSONSubscriptType](),
                            params: [String: Any]? = nil,
                            completionHandler: @escaping (RequestModelResult<T>) -> Void)
        -> DataRequest {
            let url = fullUrl(with: path)
            let secretParams = encryption(params)!
            printFullPath(with: path, params: secretParams)
            return Alamofire.request(url, method: method, parameters: secretParams).responseData {
                let result = RequestModelResult<T>(response: $0, path: analysisPath)
                completionHandler(result)
            }
    }
    
    @discardableResult
    class func loadList<T>(_ path: String,
                           method: HTTPMethod,
                           analysisPath: [JSONSubscriptType] = [JSONSubscriptType](),
                           params: [String: Any]? = nil,
                           completionHandler: @escaping (RequestListResult<T>) -> Void)
        -> DataRequest {
            
            let url = fullUrl(with: path)
            let secretParams = encryption(params)!
            printFullPath(with: path, params: secretParams)
            return Alamofire.request(url, method: method, parameters: secretParams).responseData {
                let result = RequestListResult<T>(response: $0, path: analysisPath)
                completionHandler(result)
            }
    }

}

extension NetTool {
    
    /// 单文件上传
    ///
    /// - Parameters:
    ///   - path: 上传请求路径
    ///   - data: 上传文件的二进制数据
    ///   - params: 参数列表
    ///   - progressHanlder: 上传进度回调
    ///   - completionHandler: 上传完成回调
    /// - Returns: 上传请求对象
    @discardableResult
    class func upload(with path: String,
                      data: Data,
                      params: [String: String]? = nil,
                      progressHanlder: ProgressHandler? = nil,
                      completionHandler: CompletionHandler? = nil)
        -> UploadRequest {
            let url = fullUrl(with: path)
            let headers = encryption(params) as! [String: String]
            printFullPath(with: path, params: headers)
            return Alamofire.upload(data, to: url, method: .post, headers: headers).uploadProgress(closure: { (progress) in
                guard let progressHanlder = progressHanlder else { return }
                let progressValue = Float(progress.fractionCompleted)
                progressHanlder(progressValue)
            }).responseData {
                guard let completionHandler = completionHandler else { return }
                let result = RequestResult(response: $0, path: [])
                completionHandler(result)
            }
    }
    

    /// 多文件上传
    ///
    /// - Parameters:
    ///   - path: 上传请求路径
    ///   - datas: 上传文件的二进制数据数组
    ///   - dataType: 上传文件类型(例: "image/png")
    ///   - params: 参数列表
    ///   - progressHanlder: 上传进度回调
    ///   - completionHandler: 上传完成回调
    class func upload(_ path: String,
                      datas: [Data],
                      dataType: String,
                      params: [String: String]? = nil,
                      progressHanlder: ProgressHandler? = nil,
                      completionHandler: CompletionHandler? = nil) {
        
        let url = fullUrl(with: path)
        let headers = encryption(params) as! [String: String]
        Alamofire.upload(multipartFormData: {
            guard datas.count > 0 else { return }
            for data in datas {
                $0.append(data, withName: "file[]", fileName: "file[]", mimeType: dataType)
            }
        }, to: url, headers: headers, encodingCompletion: {
            switch $0 {
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress(closure: { (progress) in
                    guard let progressHanlder = progressHanlder else { return }
                    let progressValue = Float(progress.fractionCompleted)
                    progressHanlder(progressValue)
                }).responseData(completionHandler: {
                    guard let completionHandler = completionHandler else { return }
                    let result = RequestResult(response: $0, path: [])
                    completionHandler(result)
                })
            case .failure:
                guard let completionHandler = completionHandler else { return }
                let result = RequestResult(failDescribtion: "请检查网络是否正常")
                completionHandler(result)
            }
        })
        
    }
    
}

extension NetTool {
    @discardableResult
    class func getNormal(with path: String,
                   params: [String: Any]? = nil,
                   completionHandler: ((NormalRequestResult) -> Void)? = nil)
        -> DataRequest {
            let url = fullUrl(with: path)
            let secretParams = encryption(params)!
            printFullPath(with: path, params: secretParams)
            return Alamofire.request(url, method: .get, parameters: secretParams).responseData {
                guard let completionHandler = completionHandler else { return }
                let result = NormalRequestResult(response: $0)
                completionHandler(result)
            }
    }
}

