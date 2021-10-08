//
//  CarroInfoVC.swift
//  Carro
//
//  Created by 彭汉昌 on 2021/10/8.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class CarroInfoVC: UIViewController {

    @IBOutlet weak var totalFinesLabel: UILabel!
    @IBOutlet weak var totalFinesAmount: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestData()
    }
    

    private func requestData() {
        
        let url = "https://gist.githubusercontent.com/heinhtetaung92/fbfd371881e6982c71971eedd5732798/raw/00e14e0e5502dbcf1ea9a2cdc44324fd3a5492e7/test.json"

        NetTool.loadModel(url, method: .get) { [weak self] (result: RequestModelResult<CarroInfo>) in
            if let model = result.model {
                print(model.make)
                print(model.updated_at)
                let str = self?.timeStampToString(timeStamp: String(model.updated_at)) ?? ""
                self?.timeLabel.text = "last updated: " + str
                self?.totalFinesLabel.text = String(model.total_outstanding_fine_count )
                self?.totalFinesAmount.text = String(model.total_outstanding_fine_amount)
            }
        }
        
    }
    
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy/MM/dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.string(from: date as Date))
        return dfmatter.string(from: date as Date)
    }
    

}

class Car: Mappable {
    var data = [CarroInfo]()
    var success = [Message]()
    
    init() {}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        success <- map["success"]
    }
}

class Message: Mappable {
    var message = ""
    
    init() {}
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
    }
}

class CarroInfo: Mappable {
    var base_price = ""
    var carplate_number = ""
    var days_left = ""
    var driven_this_month = 0
    var drivers = [Drivers]()
    var earliest_payment_due_date = 0
    var end_time = 0
    var has_subscribed_insurance = true
    var help = [Help]()
    var id = 1535683419
    var insurance_excess = 1
    var make = ""
    var mileage = "a53e9468124b1523d137c9bdf0d49b72"
    var model = ""
    var next_billing_date = 0
    var price = ""
    var records = [Records]()
    var road_tax = 0
    var start_time = 0
    var total_outstanding_fine_amount = 0
    var total_outstanding_fine_count = 0
    var total_per_km_rate = ""
    var type = ""
    var updated_at = ""
    var usage_due_this_month = 0

    init() {}
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        base_price <- map["base_price"]
        carplate_number <- map["carplate_number"]
        days_left <- map["days_left"]
        driven_this_month <- map["driven_this_month"]
        drivers <- map["drivers"]
        earliest_payment_due_date <- map["earliest_payment_due_date"]
        end_time <- map["end_time"]
        has_subscribed_insurance <- map["has_subscribed_insurance"]
        help <- map["help"]
        id <- map["id"]
        insurance_excess <- map["insurance_excess"]
        make <- map["make"]
        mileage <- map["mileage"]
        model <- map["model"]
        next_billing_date <- map["next_billing_date"]
        price <- map["price"]
        records <- map["records"]
        road_tax <- map["road_tax"]
        start_time <- map["start_time"]
        total_outstanding_fine_amount <- map["total_outstanding_fine_amount"]
        total_outstanding_fine_count <- map["total_outstanding_fine_count"]
        total_per_km_rate <- map["total_per_km_rate"]
        type <- map["start_time"]
        updated_at <- map["updated_at"]
        usage_due_this_month <- map["usage_due_this_month"]
    }

}

class Drivers: Mappable {
    var date_of_birth = 0
    var driver_type = ""
    var driving_experience = ""
    var driving_license_number = 0
    var driving_license_registration_date = "18627748378"
    var gender = 0
    var id_number = 0
    var marital_status = ""
    var name = "127.0.0.1"
    var phone = ""
    
    init() {}
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        date_of_birth <- map["date_of_birth"]
        driver_type <- map["driver_type"]
        driving_experience <- map["driving_experience"]
        driving_license_number <- map["driving_license_number"]
        driving_license_registration_date <- map["driving_license_registration_date"]
        gender <- map["gender"]
        id_number <- map["id_number"]
        marital_status <- map["marital_status"]
        name <- map["name"]
        phone <- map["phone"]
    }
}

class Help: Mappable {
    var key = 0
    var label = ""
    var value = ""
    
    init() {}
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        key <- map["key"]
        label <- map["label"]
        value <- map["value"]
    }
}

class Records: Mappable {
    var key = 0
    var label = ""
    
    init() {}
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        key <- map["key"]
        label <- map["label"]
    }
}
