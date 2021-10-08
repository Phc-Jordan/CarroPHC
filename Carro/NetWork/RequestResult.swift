//
//  RequestResult.swift
//  Framework
//
//  Created by able on 2017/3/28.
//  Copyright © 2017年 able. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

struct NormalRequestResult {
    
    var data: [String: Any]?
    init(response: DataResponse<Data>) {
        if let value = response.result.value {
            let json = JSON(value)
            data = json.dictionaryObject
        }
    }
}


struct RequestResult {
    
    /// 网络请求返回的状态
    private enum StatusCode: Int {
        case unknown = -1
        case success = 200
        case nofound = 404
        case failure = -599
        case tokenExpired = 403
        case otherDidLogin = 300
    }
    
    private var statusCode: Int? {
        didSet {
            let netStatusCode = StatusCode(rawValue: statusCode ?? -1) ?? .unknown
            switch netStatusCode {
            case .success:
                isSuccess = true
                describtion = "请求数据成功"
            case .failure:
                isSuccess = false
                describtion = "请求数据失败"
            case .tokenExpired:
                isSuccess = false
                describtion = "token过期"
            case .nofound:
                isSuccess = false
                describtion = "路径不存在"
            case .unknown:
                isSuccess = false
                describtion = "未知错误"
            case .otherDidLogin:
                isSuccess = false
                describtion = "异处登录"
            }
        }
    }
    private var dataPath = [JSONSubscriptType]()
    
    var isSuccess = false
    var describtion = ""
    var data: Any?
    
    init(isSuccess: Bool, describtion: String = "", data: Any? = nil) {
        self.isSuccess = isSuccess
        self.describtion = describtion
        self.data = data
    }
    
    init(failDescribtion: String) {
        self.isSuccess = false
        self.describtion = failDescribtion
    }
    
    init(response: DataResponse<Data>, path: [JSONSubscriptType]) {
        self.isSuccess = response.result.isSuccess
        self.statusCode = response.response?.statusCode
        self.dataPath = path
        if isSuccess {
            setResultData(resultData: response.result.value)
        }
    }
    
    init(response: DownloadResponse<Data>) {
        self.isSuccess = response.result.isSuccess
        self.statusCode = response.response?.statusCode
        if isSuccess {
            setResultData(resultData: response.result.value)
        }
    }
    
    private mutating func setResultData(resultData: Any?) {
        guard let resultData = resultData else {
            isSuccess = false
            describtion = "返回数据错误"
            data = nil
            return
        }
        let json = JSON(resultData)
        describtion = json["message"].string ?? ""
        let code = json["code"].int
        if code == -1 {
           
        }else if code == 1 {
            isSuccess = true
        }else {
            isSuccess = false
            if let msg = data as? String {
                describtion = msg
            }
        }
        // print(String(data: resultData as! Data, encoding: .utf8) ?? "")
          data = json["data"][dataPath].object
        
    }

    
}


struct RequestModelResult<T: Mappable> {
    var isSuccess = false
    var describtion = ""
    var model = T.self as? T
    
    init(response: DataResponse<Data>, path: [JSONSubscriptType]) {
        let result = RequestResult(response: response, path: path)
        self.init(result: result)
    }
    
    init(failDescribtion: String) {
        self.isSuccess = false
        self.describtion = failDescribtion
    }
    
    init(result: RequestResult) {
        isSuccess = result.isSuccess
        describtion = result.describtion
        if let data = Mapper<T>().map(JSONObject: result.data) {
            model = data
        }else {
            isSuccess = false
            describtion = "数据解析错误"
        }
    }
}

struct RequestListResult<T: Mappable> {
    var isSuccess = false
    var describtion = ""
    var list = [T]()
    var total = 0
    
    init(response: DataResponse<Data>, path: [JSONSubscriptType]) {
        let result = RequestResult(response: response, path: path)
        self.isSuccess = result.isSuccess
        self.describtion = result.describtion
        if let data = Mapper<T>().mapArray(JSONObject: result.data) {
            list = data
        }else {
            list = [T]()
        }
    }
    
    init(failDescribtion: String) {
        self.isSuccess = false
        self.describtion = failDescribtion
    }
}


class SearchKeyWorkModel {
    var hot = [String]()
    var history = [String]()
}




