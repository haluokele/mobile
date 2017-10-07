//
//  ViewController.swift
//  2besafe
//
//  Created by Yaojia on 1/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var userid = String()
    var call000Flag = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(call000Flag)
        if call000Flag == true{
            self.call000Alert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lostUseridAlert() {
        let alertControl = UIAlertController(title: "User ID lost", message: "Please login again", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func call000Alert(){
        let alertControl = UIAlertController(title: "Didn't Cancel Task Alert", message: "You didn't cancel your last task. We have sent notification to your friends.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "I got it", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    @IBAction func clickSetTaskButton(_ sender: UIButton) {
        let str = userid
        self.performSegue(withIdentifier: "main2SetTask", sender: str)
    }

    @IBAction func clickContactButton(_ sender: UIButton) {
        let str = userid
        self.performSegue(withIdentifier: "main2Contact", sender: str)
    }
    
    @IBAction func CallPolice(_ sender: Any) {
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
    }
    
    @IBAction func clickBrowserButton(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://www.crimestatistics.vic.gov.au/")! as URL)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go to set task page
        if segue.identifier == "main2SetTask"{
            // Because in the SetTaskViewController, it uses a Navigation Controller
            // the follwing codes are look like this
            let navigationController = segue.destination as! UINavigationController
            let setTaskViewController = navigationController.topViewController as! SetTaskViewController
            setTaskViewController.userid = self.userid
        }
            
        // Go to update contact page
        if segue.identifier == "main2Contact"{
            let viewController = segue.destination as! ContactViewController
            viewController.userid = self.userid
        }
    }


}

