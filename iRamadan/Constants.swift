//
//  Constants.swift
//  iRamadan
//
//  Created by Raikhan Khassenova on 05/05/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import Alamofire

typealias DownloadComplete = () -> ()


enum settingTypes: Int {
    case calculation
    case jurisdic
    case latitudeAdjustment
    case other
}


var location = Location()
var prayerTimingsURL = String()
var prayerTime = PrayerData()
var statusPrayerData = false
var calculationMethod = 1
var juristicSettings = 1
var latitudeAdjustmentSettings = 1

func giveMeURL()-> String {
    let timestamp = Int(Date().timeIntervalSince1970)
    let prayer_timings_url = "http://api.aladhan.com/timings/\(timestamp)?latitude=\(location.latitude)&longitude=\(location.longitude)&timezonestring=\(location.timezone)&method=\(String(calculationMethod))&school=\(String(juristicSettings))&latitudeAdjustmentMethod=\(String(latitudeAdjustmentSettings+1))"
    return prayer_timings_url
}

func getPrayerDataFor(completed: @escaping DownloadComplete){
    Alamofire.request(prayerTimingsURL).responseJSON(){ response in
        switch response.result {
        case .success:
            print(response)
            // in case of Success parse the data and fill in the prayerTimes
            statusPrayerData = true
            if let result = response.result.value as? Dictionary<String, AnyObject> {                
                if let data = result["data"] as? Dictionary<String, AnyObject> {
                    if let date = data["date"] as? Dictionary<String, AnyObject> {
                        if let timestamp = date["timestamp"] as? String {
                            if let timestampDouble = Double(timestamp) {
                                let date = NSDate(timeIntervalSince1970: timestampDouble)
                                prayerTime.date = date as Date
                            }
                        }
                    }
                    
                    if let timings = data["timings"] as? Dictionary<String, String> {
                        if let sahoor = timings["Fajr"]{
                            prayerTime.fajr = sahoor
                        }
                        if let maghrib = timings["Maghrib"] {
                            prayerTime.maghrib = maghrib
                        }
                    }
                }
            }
        case .failure:
            statusPrayerData = false
        }
        completed()
    }
}
