//
//  ContactViewController.swift
//  2besafe
//
//  Created by Yaojia on 3/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    var userid = String()

    @IBOutlet weak var contactName1TextField: UITextField!
    @IBOutlet weak var contactEmail1TextField: UITextField!
    @IBOutlet weak var contactName2TextField: UITextField!
    @IBOutlet weak var contactEmail2TextField: UITextField!
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.cornerRadius = 5
        
        submitButton.layer.cornerRadius = 5
        
        // request contact info
        var splitedArray = [String]()
        var strURL = "http://13.73.118.226/API/operations.php?func=getContacts"
        let parameters = ("&para1="+self.userid)
        strURL = strURL + parameters
        print(strURL)
        
        
        var request = URLRequest(url: URL(string: strURL)!)
        request.httpMethod = "POST"
        let postString = ""
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler:{ (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(String(describing: responseString))")
            
            DispatchQueue.main.async {
                if (responseString=="False"){
                    self.showUpdateFailAlert()
                    return
                }else {
                    print(responseString)
                    splitedArray = responseString.components(separatedBy: ",")
                    self.contactName1TextField.text = splitedArray[0]
                    self.contactEmail1TextField.text = splitedArray[1]
                    self.contactName2TextField.text = splitedArray[2]
                    self.contactEmail2TextField.text = splitedArray[3]
                }
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backMain"{
            let controller = segue.destination as! ViewController
            controller.userid = (sender as? String)!
        }
    }
    
    @IBAction func BackMain(_ sender: Any) {
        let str = userid
        self.performSegue(withIdentifier: "backMain", sender: str)
    }
    
    func showAllInfoAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Please Input All Information", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showUpdateFailAlert(){
        let alertControl = UIAlertController(title: "Alert", message: "Failed", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    // update the contact info
    @IBAction func SubmitContact(_ sender: Any) {
        let contactName1 = contactName1TextField.text!
        let contactEmail1 = contactEmail1TextField.text!
        let contactName2 = contactName2TextField.text!
        let contactEmail2 = contactEmail2TextField.text!
        
        if(contactName1.characters.count==0 || contactEmail1.characters.count==0 || contactName2.characters.count==0 || contactEmail2.characters.count==0) {
            showAllInfoAlert()
            return
        }
        
        var strURL = "http://13.73.118.226/API/operations.php?func=updateContacts"
        let parameters = ("&para1="+self.userid+"&para2="+contactName1+"&para3="+contactEmail1+"&para4="+contactName2+"&para5="+contactEmail2)
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
                    self.showUpdateFailAlert()
                    return
                }else {
                    //self.userid = responseString
                    let str = self.userid
                    self.performSegue(withIdentifier: "backMain", sender: str)
                }
            }
        }
        task.resume()
    }
}
