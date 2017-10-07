//
//  TimerViewController.swift
//  2besafe
//
//  Created by Yaojia on 3/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit
import CoreLocation

class TimerViewController: UIViewController,CLLocationManagerDelegate{
    var userid = String()
    var minuteChoice = Int()
    var call000Flag = false

    @IBOutlet weak var secondDisplayLabel: UILabel!
    @IBOutlet weak var minuteDisplayLabel: UILabel!
    @IBOutlet weak var circleGif: UIImageView!
    @IBOutlet weak var stopButton: UIButton!
    
    var timerDial = Timer()
    var timerSecondDisplay = Timer()
    var secondTime = Int.max
    var triggerTime = Int.max
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.layer.cornerRadius = 5
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        NSLog("chosen time:"+String(minuteChoice))
        
        secondTime = minuteChoice * 60
        
        NSLog("trigger time:"+String(secondTime))
        
        // Timer for call 000
        timerDial = Timer.scheduledTimer(timeInterval: TimeInterval(secondTime), target: self, selector: #selector(dial), userInfo: nil, repeats: false)
        
        // Timer for label display
        // For the timer label initial display
        if (secondTime/60/10>0 && secondTime%60/10>0){
            minuteDisplayLabel.text = String(secondTime/60)
            secondDisplayLabel.text = String(secondTime%60)
        }
        
        if (secondTime/60/10>0 && secondTime%60/10<=0){
            minuteDisplayLabel.text = String(secondTime/60)
            secondDisplayLabel.text = "0"+String(secondTime%60)
        }
        
        if (secondTime/60/10<=0 && secondTime%60/10>0){
            minuteDisplayLabel.text = "0"+String(secondTime/60)
            secondDisplayLabel.text = String(secondTime%60)
        }
        
        if (secondTime/60/10<=0 && secondTime%60/10<=0){
            minuteDisplayLabel.text = "0"+String(secondTime/60)
            secondDisplayLabel.text = "0"+String(secondTime%60)
        }
        
        secondTime -= 1
        
        // Change the labels every second
        timerSecondDisplay = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownDisplay), userInfo: nil, repeats: true)
        
        
        // Display watch image
        var imageNames = ["fiveMin100.png","fiveMin099.png","fiveMin098.png","fiveMin097.png","fiveMin096.png","fiveMin095.png","fiveMin094.png","fiveMin093.png","fiveMin092.png","fiveMin091.png","fiveMin090.png","fiveMin089.png","fiveMin088.png","fiveMin087.png","fiveMin086.png","fiveMin085.png","fiveMin084.png","fiveMin083.png","fiveMin082.png","fiveMin081.png","fiveMin080.png","fiveMin079.png","fiveMin078.png","fiveMin077.png","fiveMin076.png","fiveMin075.png","fiveMin074.png","fiveMin073.png","fiveMin072.png","fiveMin071.png","fiveMin070.png","fiveMin069.png","fiveMin068.png","fiveMin067.png","fiveMin066.png","fiveMin065.png","fiveMin064.png","fiveMin063.png","fiveMin062.png","fiveMin061.png","fiveMin060.png","fiveMin059.png","fiveMin058.png","fiveMin057.png","fiveMin056.png","fiveMin055.png","fiveMin054.png","fiveMin053.png","fiveMin052.png","fiveMin051.png","fiveMin050.png","fiveMin049.png","fiveMin048.png","fiveMin047.png","fiveMin046.png","fiveMin045.png","fiveMin044.png","fiveMin043.png","fiveMin042.png","fiveMin041.png","fiveMin040.png","fiveMin039.png","fiveMin038.png","fiveMin037.png","fiveMin036.png","fiveMin035.png","fiveMin034.png","fiveMin033.png","fiveMin032.png","fiveMin031.png","fiveMin030.png","fiveMin029.png","fiveMin028.png","fiveMin027.png","fiveMin026.png","fiveMin025.png","fiveMin024.png","fiveMin023.png","fiveMin022.png","fiveMin021.png","fiveMin020.png","fiveMin019.png","fiveMin018.png","fiveMin017.png","fiveMin016.png","fiveMin015.png","fiveMin014.png","fiveMin013.png","fiveMin012.png","fiveMin011.png","fiveMin010.png","fiveMin009.png","fiveMin008.png","fiveMin007.png","fiveMin006.png","fiveMin005.png","fiveMin004.png","fiveMin003.png","fiveMin002.png","fiveMin001.png"]
        
        var images = [UIImage]()
        
        for i in 0..<imageNames.count {
            images.append(UIImage(named:(imageNames[i]))!)
        }
        
        self.circleGif.animationImages = images
        self.circleGif.animationDuration = Double(secondTime)
        self.circleGif.startAnimating()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Call 000
    // Here use a mobile number rather than 000
    @objc func dial(){
        NSLog("call 000")
        
        let urlString = "tel://0410916158"
        
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        timerDial.invalidate()
        
        // For the main page alert
        self.call000Flag = true
        
        // Jump back to main page
        self.performSegue(withIdentifier: "timer2Main", sender: self)
    }
    
    @objc func countdownDisplay() {
        if secondTime > 0{
            NSLog(String(secondTime/60)+","+String(secondTime%60))
            
            if (secondTime/60/10>0 && secondTime%60/10>0){
                minuteDisplayLabel.text = String(secondTime/60)
                secondDisplayLabel.text = String(secondTime%60)
            }
            
            if (secondTime/60/10>0 && secondTime%60/10<=0){
                minuteDisplayLabel.text = String(secondTime/60)
                secondDisplayLabel.text = "0"+String(secondTime%60)
            }
            
            if (secondTime/60/10<=0 && secondTime%60/10>0){
                minuteDisplayLabel.text = "0"+String(secondTime/60)
                secondDisplayLabel.text = String(secondTime%60)
            }
            
            if (secondTime/60/10<=0 && secondTime%60/10<=0){
                minuteDisplayLabel.text = "0"+String(secondTime/60)
                secondDisplayLabel.text = "0"+String(secondTime%60)
            }
            
            secondTime -= 1
        }
        else {
            self.timerSecondDisplay.invalidate()
            
            self.secondDisplayLabel.text = "00"
            self.minuteDisplayLabel.text = "00"
            
            self.circleGif.stopAnimating()
        }
        
        // Pop up a stop task alert before 30 seconds of arrival
        if secondTime == 120 {
            self.showStopTaskAlert()
        }
        
        // Update current coordinate to server time every 30 seconds
        if secondTime%30 == 0{
            let currentUTC = String(Int(NSDate().timeIntervalSince1970))
            var strURL = "http://13.73.118.226/API/operations.php?func=updateLocation"
            let parameters = "&para1=\(String((self.locationManager.location?.coordinate.latitude)!))&para2=\(String((self.locationManager.location?.coordinate.longitude)!))&para3=\(currentUTC)&para4=\(self.userid)"
            strURL = strURL + parameters
            print(strURL)
            
            var request = URLRequest(url: URL(string: strURL)!)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)!
                print("responseString = "+responseString)
                
            }
            task.resume()
        }
    }
    
    @IBAction func clickStopButton(_ sender: UIButton) {
        // Stop displaying timer
        self.timerSecondDisplay.invalidate()
        self.timerDial.invalidate()
        
        self.secondDisplayLabel.text = "00"
        self.minuteDisplayLabel.text = "00"
        
        self.circleGif.stopAnimating()
        
        // *****Generate Cancel Task Request*****
        var strURL = "http://13.73.118.226/API/operations.php?func=cancelTask"
        let parameters = "&para1=\(self.userid)"
        strURL = strURL + parameters
        print(strURL)
        
        var request = URLRequest(url: URL(string: strURL)!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = "+responseString)
            
            
        }
        task.resume()

        
        // Back to the Main View Controller
        self.performSegue(withIdentifier: "timer2Main", sender: self)
    }
    
    // Alert of stoping task before 2 minutes of the end time
    func showStopTaskAlert(){
        let alertControl = UIAlertController(title: "Do you want to stop the task?", message: "Please stop task if you have arrived", preferredStyle: UIAlertControllerStyle.alert)
        let stopAction = UIAlertAction(title: "Stop", style: UIAlertActionStyle.default, handler: { action in
            self.timerSecondDisplay.invalidate()
            self.timerDial.invalidate()
            
            self.secondDisplayLabel.text = "00"
            self.minuteDisplayLabel.text = "00"
            
            self.circleGif.stopAnimating()
            
            // *****Generate Cancel Task Request*****
            var strURL = "http://13.73.118.226/API/operations.php?func=cancelTask"
            let parameters = "&para1=\(self.userid)"
            strURL = strURL + parameters
            print(strURL)
            
            var request = URLRequest(url: URL(string: strURL)!)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)!
                print("responseString = "+responseString)
                
            }
            task.resume()
            
            // Back to the Main View Controller
            self.performSegue(withIdentifier: "timer2Main", sender: self)
        })
        
//        let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(stopAction)
//        alertControl.addAction(continueAction)
        self.present(alertControl, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timer2Main" {
            let viewController = segue.destination as! ViewController
            viewController.userid = self.userid
            viewController.call000Flag = self.call000Flag
        }
    }
    
    

}
