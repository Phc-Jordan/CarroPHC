//
//  UserDefaults.swift
//  Carro
//
//  Created by 彭汉昌 on 2021/10/8.
//

import UIKit

extension UserDefaults {
    /// bool类型的默认值为false
    var isHasLaunch: Bool {
        get {
            return bool(forKey: "isHasLaunch")
        }
        set {
            set(newValue, forKey: "isHasLaunch")
        }
    }
    
    var isLogin: Bool {
        get {
            return token != nil
        }
    }
    
    var token: String? {
        get {
            return string(forKey: "token")
        }
        set {
            set(newValue, forKey: "token")
        }
    }
    
    var rToken: String? {
        get {
            return string(forKey: "rToken")
        }
        set {
            set(newValue, forKey: "rToken")
            if newValue != nil {
                
            }else {
                
            }
        }
    }
}

