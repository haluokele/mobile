//
//  RegisterViewController.swift
//  2besafe
//
//  Created by Yaojia on 3/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactEmailTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.layer.cornerRadius = 5
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
    
    func showPasswordAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Please Input Same Password", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showRegisterAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Username Used, Please Change", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showSuccessAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Registed, Please Login", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    // regist a account
    @IBAction func RegisterAcc(_ sender: Any) {
        let username = usernameTextField.text!
        let name = nameTextField.text!
        let password = passwordTextField.text!
        let repassword = repasswordTextField.text!
        let contactName = contactNameTextField.text!
        let contactEmail = contactEmailTextField.text!
        
        // check the user info is correct
        if(username.characters.count==0 || name.characters.count==0 || password.characters.count==0 || repassword.characters.count==0 || contactName.characters.count==0 || contactEmail.characters.count==0) {
            showAllInfoAlert()
            return
        }
        
        if(password != repassword){
            showPasswordAlert()
            return
        }
        
        var strURL = "http://13.73.118.226/API/operations.php?func=register"
        let parameters = ("&para1="+username+"&para2="+name+"&para3="+password+"&para4="+contactName+"&para5="+contactEmail+"&para6=&para7=")
        strURL = strURL + parameters
        print(strURL)
        
        //var request = URLRequest(url: URL(string: "http://13.70.147.66/api/operations.php")!)
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
                    self.showRegisterAlert()
                    return
                }else {
                    self.showSuccessAlert()
                    self.presentingViewController!.dismiss(animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
}
