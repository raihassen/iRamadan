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
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var duaTextDisplayButton: UIButton!    
    @IBOutlet weak var maghribLabel: UILabel!
    @IBOutlet weak var duaButton: UIButton!
    @IBOutlet weak var fajrLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var circleImage: UIImageView!
    
    @IBOutlet weak var duaArabicLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var swiftTimer = Timer()
    var locManager: CLLocationManager?
    
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
        updatePrayerInfo()
    }
    
    func updatePrayerInfo() {
        currentLocationSelected()
        if currentLocation != nil{
            prayerTimingsURL = giveMeURL()
            timestamp = Int(Date().timeIntervalSince1970)
            todayTimestamp = timestamp - (timestamp % 86400)
            getPrayerDataFor {
                if statusPrayerData {
                    self.maghribLabel.text = "Maghrib \(prayerTime.maghrib)"
                    self.fajrLabel.text = "Fajr \(prayerTime.fajr)"
                    
                    self.maghribTimestamp = self.todayTimestamp + self.string2Seconds(time: prayerTime.maghrib)
                
                    self.fajrTimestamp = self.todayTimestamp + self.string2Seconds(time: prayerTime.fajr)
                
                    self.swiftTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimeleft), userInfo: nil, repeats: true)
                } else {
                    self.swiftTimer.invalidate()
                    self.maghribLabel.text = "Maghrib"
                    self.fajrLabel.text = "Fajr"
                    self.counterLabel.text = "No internet connection"
                    self.showToast(message: "No internet connection")
            }
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
            currentLocation = locationManager.location
            print(currentLocation)
        }
    }

    func currentLocationSelected() {
        locationAuthStatus()
        location.timezone = TimeZone.current.identifier
        location.name = "currentLocation"
        if (currentLocation == nil) {
            showToast(message: "Unable to find \nyour location")
        } else {
            location.latitude = currentLocation.coordinate.latitude
            location.longitude = currentLocation.coordinate.longitude
            prayerTime.location = location
        }
    }
    
    @IBAction func duaButtonIsPressed(_ sender: Any) {
        let isHidden = duaTextDisplayButton.isHidden
        duaTextDisplayButton.isHidden = !isHidden
        duaArabicLabel.isHidden = !isHidden
        circleImage.isHidden = isHidden
    }
    
    @IBAction func refreshButtonIsPressed(_ sender: Any) {
        updatePrayerInfo()
    }
    
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.numberOfLines = 2
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

