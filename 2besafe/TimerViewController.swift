//
//  TimerViewController.swift
//  2besafe
//
//  Created by Yaojia on 3/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    var userid = String()
    var minuteChoice = Int()

    @IBOutlet weak var secondDisplayLabel: UILabel!
    @IBOutlet weak var minuteDisplayLabel: UILabel!
    
    @IBOutlet weak var circleGif: UIImageView!
    var timerDial = Timer()
    
    var timerSecondDisplay = Timer()
    
    var timerMinuteDisplay = Timer()
    
    var secondTime = Int.max
    
    var triggerTime = Int.max
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSLog("chosen time:"+String(minuteChoice))
        
        secondTime = minuteChoice * 60
        
        NSLog("trigger time:"+String(secondTime))
        
        //        triggerTime = minuteChoice * 60
        
        //        triggerTime = hourChoice*3600 + minuteChoice*60 // using hours
        
        //        timerDial = Timer.scheduledTimer(timeInterval: TimeInterval(secondTime), target: self, selector: #selector(dial), userInfo: nil, repeats: false)
        
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
        
        timerSecondDisplay = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownDisplay), userInfo: nil, repeats: true)
        
        //        timerMinuteDisplay = Timer.scheduledTimer(timeInterval: TimeInterval(minuteChoice), target: self, selector: #selector(countdownDisplay), userInfo: nil, repeats: true)
        
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
    func dial(){
        NSLog("call 000")
        timerDial.invalidate()
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
            timerSecondDisplay.invalidate()
            //            timerMinuteDisplay.invalidate()
            
            secondDisplayLabel.text = "00"
            minuteDisplayLabel.text = "00"
            
            self.circleGif.stopAnimating()
        }
        
    }
    
    @IBAction func clickStopButton(_ sender: UIButton) {
        timerSecondDisplay.invalidate()
        timerDial.invalidate()
        
        secondDisplayLabel.text = "00"
        minuteDisplayLabel.text = "00"
        
        self.circleGif.stopAnimating()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
