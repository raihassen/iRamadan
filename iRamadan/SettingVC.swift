//
//  SettingVC.swift
//  iRamadan
//
//  Created by Raikhan Khassenova on 11/05/2017.
//  Copyright © 2017 Raikhan Khassenova. All rights reserved.
//

import Foundation
import UIKit

class SettingVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let calculation = ["Shia Ithna-Ashari", "University of Islamic Sciences, Karachi", "Islamic Society of North America (ISNA)", "Muslim World League (MWL)", "Umm al-Qura, Makkah", "Egyptian General Authority of Survey", "Institute of Geophysics, University of Tehran"]
    let juristic = ["Shafii, Maliki, Hanbali", "Hanafi"]
    let latitudeAdjustment = ["Middle of the Night", "One Seventh", "Angle Based"]
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var latitudeAdjustmentButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var calculationMethodButton: UIButton!
    @IBOutlet weak var jurisdicSettingsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        // TD: copy initial values
        calculationMethodButton.setTitle(calculation[calculationMethod], for: UIControlState.normal)
        jurisdicSettingsButton.setTitle(juristic[juristicSettings], for: UIControlState.normal)
        latitudeAdjustmentButton.setTitle(latitudeAdjustment[latitudeAdjustmentSettings], for: UIControlState.normal)
        pickerView.isHidden = true
        pickerView.tag = settingTypes.other.rawValue
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    func updatePickerView(content: Int) {
        if pickerView.tag == content {
            pickerView.isHidden = true
            pickerView.tag = settingTypes.other.rawValue
        } else {
            pickerView.tag = content
            pickerView.isHidden = false
            pickerView.reloadAllComponents()
        }
    }
    @IBAction func calculationMethodButtonIsPressed(_ sender: Any) {
        updatePickerView(content: settingTypes.calculation.rawValue)
    }
   
    @IBAction func jurisdicSettingsButtonIsPressed(_ sender: Any) {
        updatePickerView(content: settingTypes.jurisdic.rawValue)
    
    }
    @IBAction func latitudeAdjustmentButtonIsPressed(_ sender: Any) {
        updatePickerView(content: settingTypes.latitudeAdjustment.rawValue)
    }
    @IBAction func cancelButtonIsPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        // TD: assign initial values and do nothing
    }
    @IBAction func saveButtonIsPressed(_ sender: Any) {
        presentingViewController?.viewDidLoad()
        dismiss(animated: true, completion: nil)
        print("Dismissed")
        // TD: save new values, and update info for prayer time, and view
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tag = pickerView.tag
        print(tag)
        print("row\(row)")
        switch tag {
        case 0:
            return calculation[row]
        case 1:
            return juristic[row]
        case 2:
            return latitudeAdjustment[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = pickerView.tag
        switch tag {
        case 0:
            return calculation.count
        case 1:
            return juristic.count
        case 2:
            return latitudeAdjustment.count
        default:
            return 5
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tag = pickerView.tag
        switch tag {
        case 0:
            calculationMethodButton.setTitle(calculation[row], for: UIControlState.normal)
            print(calculationMethodButton.currentTitle!)
            calculationMethod = row
        case 1:
            jurisdicSettingsButton.setTitle(juristic[row], for: UIControlState.normal)
            juristicSettings = row
        case 2:
            latitudeAdjustmentButton.setTitle(latitudeAdjustment[row], for: UIControlState.normal)
            latitudeAdjustmentSettings = row
        default:
            print("de")
        }
        pickerView.isHidden = true
    }
}
