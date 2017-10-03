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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lostUseridAlert() {
        let alertControl = UIAlertController(title: "Alert", message: "User ID lost", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    @IBAction func clickSetTaskButton(_ sender: UIButton) {
        print("User ID = "+self.userid)
        if (self.userid != ""){
            self.performSegue(withIdentifier: "main2SetTask", sender: self.userid)
        }
        else{
            self.lostUseridAlert()
            // GO BACK TO LOGIN AGAIN????
        }
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "main2SetTask"{
            var viewController = segue.destination as! SetTaskViewController
            viewController.userid = self.userid
        }
        if segue.identifier == "main2Contact"{
            var viewController = segue.destination as! ContactViewController
            viewController.userid = self.userid
        }
    }


}

