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
    @IBOutlet weak var hoursInput: UITextField!
    
    @IBOutlet weak var minutesInput: UITextField!
    
    @IBOutlet weak var miliseconds: UILabel!
    
    @IBOutlet weak var seconds: UILabel!
    
    @IBOutlet weak var minutes: UILabel!
    
    @IBOutlet weak var hours: UILabel!
    
    var millisecondsTimer = Timer()
    var secondsTimer = Timer()
    var minutesTimer = Timer()
    var hoursTimer = Timer()
    var resumeTapped = false
    
    // Start counter method
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        if self.resumeTapped == false {
           millisecondsOn()
           secondsOn()
           minutesOn()
           hoursOn()
           self.resumeTapped = true
        } else {
           millisecondsTimer.invalidate()
           secondsTimer.invalidate()
           minutesTimer.invalidate()
           hoursTimer.invalidate()
           self.resumeTapped = false
        }
    }
    
    // Reset counter method
    @IBAction func resetTimer(_ sender: Any) {
        millisecondsTimer.invalidate()
        secondsTimer.invalidate()
        minutesTimer.invalidate()
        hoursTimer.invalidate()
        miliseconds.text = "99"
        seconds.text = "59"
        minutes.text = "59"
        hours.text = "23"
    }
    
    // Initial view method
    override func viewDidLoad() {
        super.viewDidLoad()
        miliseconds.text = "99"
        seconds.text = "59"
        minutes.text = "59"
        hours.text = "23"
        hoursInput.delegate = self
        minutesInput.delegate = self
    }
    
    // MARK: UITextFieldDelegate methods
    
    func checkTextFieldFormatMinutes(_ textField: UITextField) -> Bool {
        guard let textToInt = Int(textField.text!), textToInt >= 0 && textToInt <= 59 else {
                return false
            }
        return true
    }
    
    func checkTextFieldFormatHours(_ textField: UITextField) -> Bool {
        guard let textToInt = Int(textField.text!), textToInt >= 0 && textToInt <= 23 else {
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard checkTextFieldFormatMinutes(minutesInput) == true, minutesInput.text != "" else {
            minutes.text = "59"
            return true
        }
        guard checkTextFieldFormatHours(hoursInput) == true, hoursInput.text != "" else {
            hours.text = "23"
            return true
        }
            hours.text = hoursInput.text
            minutes.text = minutesInput.text
            return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Timer methods
    
    func millisecondsOn() {
        millisecondsTimer = Timer.scheduledTimer(timeInterval: 1.0/100, target: self, selector: #selector(updateMilliseconds), userInfo: nil, repeats: true)
    }

    func secondsOn() {
        secondsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
    }
    
    func minutesOn() {
        minutesTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateMinutes), userInfo: nil, repeats: true)
    }
    
    func hoursOn() {
        hoursTimer = Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(updateHours), userInfo: nil, repeats: true)
    }
    
    @objc func updateMilliseconds() {
        switch miliseconds.text {
        case "0"?:
            miliseconds.text = "100"
            miliseconds.text = String(Int(miliseconds.text!)!
                - 1)
        default:
            miliseconds.text = String(Int(miliseconds.text!)!
                - 1)
        }
    }
    
    @objc func updateSeconds() {
        switch seconds.text {
        case "0"?:
            seconds.text = "60"
            seconds.text = String(Int(seconds.text!)!
                - 1)
        default:
            seconds.text = String(Int(seconds.text!)!
                - 1)
        }
    }
    
    @objc func updateMinutes() {
        switch minutes.text {
        case "0"?:
            minutes.text = "60"
            minutes.text = String(Int(minutes.text!)!
                - 1)
        default:
            minutes.text = String(Int(minutes.text!)!
                - 1)
        }
    }
    
    @objc func updateHours() {
        switch hours.text {
        case "0"?:
            hours.text = "24"
            hours.text = String(Int(hours.text!)!
                - 1)
        default:
            hours.text = String(Int(hours.text!)!
                - 1)
        }
    }
}

