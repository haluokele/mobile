//
//  LoginViewController.swift
//  2besafe
//
//  Created by Yaojia on 3/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var userid = String()
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    //    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set login button style
                loginButton.layer.cornerRadius = 5
                loginButton.layer.borderWidth = 1
                loginButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAllInfoAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Please Input All Information", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showLoginFailAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    @IBAction func clickLoginButton(_ sender: UIButton) {
        // must input username & password
        // else will pop up alert box
        if (usernameTextField.text != "" && passwordTextField.text != ""){
            var strURL = "http://13.73.118.226/API/operations.php?func=login"
            let parameters = ("&para1="+usernameTextField.text!+"&para2="+passwordTextField.text!)
            strURL = strURL + parameters
            print(strURL)

            var request = URLRequest(url: URL(string: strURL)!)
            request.httpMethod = "POST"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in

                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }

                var responseString = String(data: data, encoding: .utf8)!
                print("responseString = "+responseString)

                // Use GCD to invoke the completion handler on the main thread
                // update UI
                DispatchQueue.main.async {
                    if (responseString != "False" && responseString != ""){ // if login successfully
                        print(responseString)
                        self.userid = responseString
                        print(self.userid)
                        self.performSegue(withIdentifier: "login2Main", sender: self)

                    }
                    else{
                        self.showLoginFailAlert()
                    }
                }

            }
            task.resume()

        }
        else{
            self.showAllInfoAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login2Main"{
            var mainViewController = segue.destination as! ViewController
            mainViewController.userid = self.userid
        }
    }
    
    

}
