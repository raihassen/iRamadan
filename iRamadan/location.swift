//
//  location.swift
//  iRamadan
//
//  Created by Raikhan Khassenova on 05/05/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation

struct Location {
    var latitude: Double
    var longitude: Double
    var name: String
    var timezone: String
    init() {
        latitude = 0.0
        longitude = 0.0
        name = ""
        timezone = ""
    }
}
