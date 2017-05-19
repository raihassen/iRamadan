//
//  prayerData.swift
//  iRamadan
//
//  Created by Raikhan Khassenova on 05/05/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
struct PrayerData {
    var maghrib: String // please make it later time format
    var fajr: String // please make it time format
    var date: Date
    var location: Location
    init(){
        fajr = ""
        maghrib = ""
        date = Date()
        location = Location()
    }
}
