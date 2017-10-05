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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
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
    
    @IBAction func LoginMain(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        if(username.characters.count==0 || password.characters.count==0) {
            showAllInfoAlert()
            return
        }
        
        var strURL = "http://13.73.118.226/API/operations.php?func=login"
        let parameters = ("&para1="+username+"&para2="+password)
        strURL = strURL + parameters
        print(strURL)
        
        var request = URLRequest(url: URL(string: strURL)!)
        request.httpMethod = "POST"
        let postString = ""
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            DispatchQueue.main.async {
                if (responseString=="False"){
                    self.showLoginFailAlert()
                    return
                }else {
                    self.userid = responseString!
                    let str = self.userid
                    self.performSegue(withIdentifier: "login2Main", sender: str)
                }
            }
        }
        task.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login2Main"{
            let mainViewController = segue.destination as! ViewController
            mainViewController.userid = self.userid
        }
    }
    
    

}
