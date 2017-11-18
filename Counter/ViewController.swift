//
//  ViewController.swift
//  Counter
//
//  Created by MacOS on 13/11/2017.
//  Copyright © 2017 amberApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Variables
    
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var hoursInput: UITextField!
    @IBOutlet weak var minutesInput: UITextField!
    
    @IBOutlet weak var setHour: UITextField!
    @IBOutlet weak var setMinute: UITextField!
    
    var resumeTapped = false
    
    var secondsTimer = Timer()
    var minutesTimer = Timer()
    var hoursTimer = Timer()
    
    var valueSeconds = 0
    var valueMinutes = 0
    var valueHours = 0
    
    // Start counter method
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        if self.resumeTapped == false {
            secondsOn()
            minutesOn()
            hoursOn()
            self.resumeTapped = true
        } else {
            secondsTimer.invalidate()
            minutesTimer.invalidate()
            hoursTimer.invalidate()
            self.resumeTapped = false
        }
    }
    
    // Reset counter method
    @IBAction func resetTimer(_ sender: Any) {
        secondsTimer.invalidate()
        minutesTimer.invalidate()
        hoursTimer.invalidate()
        hours.text = "00"
        minutes.text = "00"
        seconds.text = "00"
        valueSeconds = 60
        valueMinutes = 60
        valueHours = 24
    }
    
    // Reset input fields method
    @IBAction func resetFields(_ sender: Any) {
        hoursInput.text = ""
        minutesInput.text = ""
        setHour.text = ""
        setMinute.text = ""
    }
    
    // Initial view method
    override func viewDidLoad() {
        super.viewDidLoad()
        hours.text = "00"
        minutes.text = "00"
        seconds.text = "00"
        valueSeconds = 60
        valueMinutes = 60
        valueHours = 24
        hoursInput.delegate = self
        minutesInput.delegate = self
        setHour.delegate = self
        setMinute.delegate = self
    }

    // MARK: UITextFieldDelegate methods
    
    func checkTextFieldFormatHours(_ textField: UITextField) -> Bool {
        guard let textToInt = Int(textField.text!), textField.text?.count == 2, textToInt >= 0 && textToInt <= 23 else {
            return false
        }
        return true
    }
    
    func checkTextFieldFormatMinutes(_ textField: UITextField) -> Bool {
        guard let textToInt = Int(textField.text!), textField.text?.count == 2, textToInt >= 0 && textToInt <= 59 else {
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == hoursInput || textField == minutesInput {
            guard checkTextFieldFormatHours(hoursInput) == true, hoursInput.text != "" else {
                hours.text = "00"
                valueHours = 24
                seconds.text = "00"
                valueSeconds = 60
                return true
            }
        
            guard checkTextFieldFormatMinutes(minutesInput) == true, minutesInput.text != "" else {
                minutes.text = "00"
                valueMinutes = 60
                seconds.text = "00"
                valueSeconds = 60
                return true
            }
            
            hours.text = hoursInput.text
            minutes.text = minutesInput.text
            seconds.text = "00"
            valueSeconds = 0
            
            if hours.text == "00" {
                valueHours = 24
            } else {
                valueHours = Int(hoursInput.text!)!
            }
            
            if minutes.text == "00" {
                valueMinutes = 60
            } else {
                valueMinutes = Int(minutesInput.text!)!
            }
        
            textField.resignFirstResponder()
        }
        
        if textField == setMinute || textField == setHour {
            guard checkTextFieldFormatHours(setHour) == true, setHour.text != "" else {
                return true
            }
        
            guard checkTextFieldFormatMinutes(setMinute) == true, setMinute.text != "" else {
                return true
            }
            countRemainingTime()
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textFieldToChange: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
    // limit to 4 characters
    let characterCountLimit = 2
    // We need to figure out how many characters would be in the string
    let startingLength = textFieldToChange.text?.characters.count ?? 0
    let lengthToAdd = string.characters.count
    let lengthToReplace = range.length
    let newLength = startingLength + lengthToAdd - lengthToReplace
    return newLength <= characterCountLimit
}

    // method correcting timer according to the set time
    func countRemainingTime() -> Bool {
        let unitFlags:Set<Calendar.Component> = [.hour, .day, .month, .year, .minute, .hour, .second, .calendar]
        var dateComponents = Calendar.current.dateComponents(unitFlags, from: Date())
        
        if let hour = dateComponents.hour, let minute = dateComponents.minute {
            let timeInSeconds = (hour * 60 + minute) * 60
            let inputInSeconds = (Int(hoursInput.text!)! * 60 + Int(minutesInput.text!)!) * 60
            let setValueInSeconds = (Int(setHour.text!)! * 60 + Int(setMinute.text!)!) * 60
            let timeValue = timeInSeconds + inputInSeconds
            var timeDifference = setValueInSeconds - timeInSeconds
            
            guard setValueInSeconds > timeInSeconds else {
                return false
            }
            
            if timeDifference < 0 {
                timeDifference = -timeDifference
            }
            
            if timeValue > setValueInSeconds {
                let hoursNew = Int(timeDifference/3600)
                let minutesNew = timeDifference/60 - hoursNew*60
                valueHours = hoursNew
                valueMinutes = minutesNew
                valueSeconds = 0
                seconds.text = "00"
                
                switch valueMinutes {
                case 0:
                    valueMinutes = 60
                    minutes.text = "00"
                case 1...9:
                    minutes.text = "0" + String(valueMinutes)
                default:
                    minutes.text = String(valueMinutes)
                }
                
                switch valueHours {
                case 0:
                    valueHours = 24
                    hours.text = "00"
                case 1...9:
                    hours.text = "0" + String(valueHours)
                default:
                    hours.text = String(valueHours)
                }
            }
                else {
                    hours.text = hoursInput.text
                    minutes.text = minutesInput.text
                    seconds.text = "00"
                    valueSeconds = 0
                    
                    if hours.text == "00" {
                        valueHours = 24
                    } else {
                        valueHours = Int(hoursInput.text!)!
                    }
                    
                    if minutes.text == "00" {
                        valueMinutes = 60
                    } else {
                        valueMinutes = Int(minutesInput.text!)!
                    }
                }
        }
    return true
}
    
    // Timer methods
    
    func secondsOn() {
        secondsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
    }
    
    func minutesOn() {
        minutesTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateMinutes), userInfo: nil, repeats: true)
    }
    
    func hoursOn() {
        hoursTimer = Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(updateHours), userInfo: nil, repeats: true)
    }
    
    @objc func updateSeconds() {
        switch valueSeconds {
        case 0:
            valueSeconds = 60
            valueSeconds-=1
            seconds.text = String(valueSeconds)
        case 1...10:
            valueSeconds-=1
            seconds.text = "0" + String(valueSeconds)
        default:
            valueSeconds-=1
            seconds.text = String(valueSeconds)
        }

    }
    
    @objc func updateMinutes() {
        switch valueMinutes {
        case 0:
            valueMinutes = 60
            valueMinutes-=1
            seconds.text = String(valueMinutes)
        case 1...10:
            valueMinutes-=1
            minutes.text = "0" + String(valueMinutes)
        default:
            valueMinutes-=1
            minutes.text = String(valueMinutes)
        }
    }
    
    @objc func updateHours() {
        switch valueHours {
        case 0:
            valueHours = 24
            valueHours-=1
            hours.text = "0" + String(valueHours)
        case 1...10:
            valueHours-=1
            hours.text = "0" + String(valueHours)
        default:
            valueHours-=1
            hours.text = String(valueHours)
        }
    }
}

