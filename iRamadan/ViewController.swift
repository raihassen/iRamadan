//
//  ViewController.swift
//  iRamadan
//
//  Created by Raikhan Khassenova on 05/05/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftMoment
import Popover

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var duaTextDisplayButton: UIButton!    
    @IBOutlet weak var maghribLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var duaButton: UIButton!
    @IBOutlet weak var fajrLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var circleImage: UIImageView!
    
    @IBOutlet weak var duaArabicLabel: UILabel!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var swiftTimer = Timer()
    
    var timestamp: Int!
    var todayTimestamp: Int!
    var fajrTimestamp: Int!
    var maghribTimestamp: Int!
    
    @IBAction func duaTextDisplayButtonIsPressed(_ sender: Any) {
        duaTextDisplayButton.isHidden = true
        duaArabicLabel.isHidden = true
        circleImage.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationAuthStatus()
        currentLocationSelected()
        
        prayerTimingsURL = giveMeURL()
        timestamp = Int(Date().timeIntervalSince1970)
        todayTimestamp = timestamp - (timestamp % 86400)
        updatePrayerInfo()
    }
    
    func updatePrayerInfo() {
        getPrayerDataFor {
            if statusPrayerData {
                self.maghribLabel.text = "Maghrib \(prayerTime.maghrib)"
                self.fajrLabel.text = "Fajr \(prayerTime.fajr)"
                
                self.maghribTimestamp = self.todayTimestamp + self.string2Seconds(time: prayerTime.maghrib)
                
                self.fajrTimestamp = self.todayTimestamp + self.string2Seconds(time: prayerTime.fajr)
                
                self.swiftTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimeleft), userInfo: nil, repeats: true)
            } else {
                self.maghribLabel.text = "Maghrib"
                self.fajrLabel.text = "Fajr"
                
                // self.maghribTimestamp = self.todayTimestamp + self.string2Seconds(time: prayerTime.maghrib)
                
                //self.fajrTimestamp = self.todayTimestamp + self.string2Seconds(time: prayerTime.fajr)
                self.counterLabel.text = "Calculating"
                self.updatePrayerInfo()
            }
        }
    }
    
    
    func string2Seconds(time: String) -> Int {
        let hoursAndMinutes = time.components(separatedBy: ":")
        let hours = Int(hoursAndMinutes[0])
        let minutes = Int(hoursAndMinutes[1])
        let ans = (hours! * 60 + minutes!) * 60
        return ans
    }
    
    func updateTimeleft(){
        var contentString = ""
        let timestampNow = Int(Date().timeIntervalSince1970) + TimeZone.current.secondsFromGMT()
        if (timestampNow <= maghribTimestamp && timestampNow >= fajrTimestamp) {
            contentString = "Iftar is coming\n\(seconds2String(second: (maghribTimestamp-timestampNow)))"
        } else if (timestampNow < fajrTimestamp){
            contentString = "Sahoor is coming\n\(seconds2String(second: fajrTimestamp-timestampNow))"
        } else {
            contentString = "Sahoor is coming\n\(seconds2String(second:(fajrTimestamp + 86400 - timestampNow)))"
        }
        counterLabel.text = contentString + "\n" + String()
        if (timestampNow > todayTimestamp + 86400) {
            self.viewDidLoad()
        }
    }
    
    func seconds2String(second: Int) -> String {
        let seconds = second % 60
        let minutes = Int(second / 60) % 60
        let hours = Int(second / 3600)
        let ans = "\(hours):\(minutes):\(seconds)"
        return ans
    }
    
    func difference(ahour:Int, aminute:Int, bhour:Int, bminute:Int)->Duration{
        let a = ahour.hours + aminute.minutes
        let b = bhour.hours + bminute.minutes
        let result = a - b
        return result
    }
    
    func string2Duration(time: String) ->Duration {
        let timeMoment = moment(time)
        let timeDuration = (timeMoment?.hour.hours)! + (timeMoment?.minute.minutes)!
        return timeDuration
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }

    func currentLocationSelected() {
        locationAuthStatus()
        location.timezone = TimeZone.current.identifier
        location.name = "currentLocation"
        location.latitude = currentLocation.coordinate.latitude
        location.longitude = currentLocation.coordinate.longitude
        prayerTime.location = location
    }
    
    func convertStringTimeToDateTime(time:String) -> Date {
        // please do some magic and return time
        return Date()
    }
    
    
    @IBAction func settingsButtonIsPressed(_ sender: Any) {
        
    }
    
    @IBAction func duaButtonIsPressed(_ sender: Any) {
        let isHidden = duaTextDisplayButton.isHidden
        duaTextDisplayButton.isHidden = !isHidden
        duaArabicLabel.isHidden = !isHidden
        circleImage.isHidden = isHidden
    }        
}

