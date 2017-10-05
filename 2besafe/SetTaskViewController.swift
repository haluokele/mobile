//
//  SetTaskViewController.swift
//  2besafe
//
//  Created by Yaojia on 1/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit
import MapKit

class SetTaskViewController: UIViewController,UISearchBarDelegate,MKMapViewDelegate, CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource{
    var userid = String()

    //***************************************
    //********** Navigation Part ************
    //***************************************
    
    @IBOutlet var mapSearchBar: UISearchBar!
    
    @IBOutlet weak var mapkitView: MKMapView!
    
    var sourceLocation = CLLocationCoordinate2D()
    var destLatitude = CLLocationDegrees()
    var destLongitude = CLLocationDegrees()
    
    let locationManager = CLLocationManager()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search bar clicked", mapSearchBar.text!)
        
        // search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            
            if response == nil
            {
                print("search request error")
            }
            else // search request response exists
            {
                // Get destination's location from search result
                self.destLatitude = (response?.boundingRegion.center.latitude)!
                self.destLongitude = (response?.boundingRegion.center.longitude)!
                
                print("after set value:",self.destLatitude,self.destLongitude)
                
                //Remove previous annotations
                let annotations = self.mapkitView.annotations
                self.mapkitView.removeAnnotations(annotations)
                
                //Create annotation for destination
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(self.destLatitude, self.destLongitude)
                
                
                // direction
                self.sourceLocation = (self.locationManager.location?.coordinate)!
                let destLocation = CLLocationCoordinate2DMake(self.destLatitude, self.destLongitude)
                
                let sourcePlacemark = MKPlacemark(coordinate: self.sourceLocation)
                let destPlacemark = MKPlacemark(coordinate: destLocation)
                
                let sourceItem = MKMapItem(placemark: sourcePlacemark)
                let destItem = MKMapItem(placemark: destPlacemark)
                
                // walking direction request
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = sourceItem
                directionRequest.destination = destItem
                directionRequest.transportType = .walking
                
                let directions = MKDirections(request: directionRequest)
                directions.calculate(completionHandler: { (response,error) in
                    //                    print("response:",response)
                    //                    print("error:",error)
                    
                    if response == nil{
                        print ("direction request error")
                    }
                    else{
                        // Remove previous route
                        let overlays = self.mapkitView.overlays
                        self.mapkitView.removeOverlays(overlays)
                        
                        // Creat route
                        let route = response?.routes[0]
                        self.mapkitView.add((route?.polyline)!, level:.aboveRoads)
                        
                        
                        // Zoom in based on the route rect
//                        let centerLatitude = CLLocationDegrees((sourceLocation?.latitude)! + self.destLatitude)/2)
//                        let centerLongitude = CLLocationDegrees(((sourceLocation?.longitude)! + self.destLongitude)/2)
//                        let centerCoordinate = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
//                        let zoomSpan = MKCoordinateSpanMake(<#T##latitudeDelta: CLLocationDegrees##CLLocationDegrees#>, <#T##longitudeDelta: CLLocationDegrees##CLLocationDegrees#>)
                        let rect = route?.polyline.boundingMapRect
                        self.mapkitView.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
                        
                        // Get arrival time
                        let time = route?.expectedTravelTime
                        let minutes = Int(time!/60)
                        let seconds = Int(time!.truncatingRemainder(dividingBy: 60))
                        let showtime = String(minutes)+" min "+String(seconds)+" sec"
                        
                        // Set arrival time on the pin's callout
                        // and automatically display without tap
                        annotation.title = showtime
                        self.mapkitView.addAnnotation(annotation)
                        self.mapkitView.selectAnnotation(annotation, animated: false)
                    }
                    
                })
                
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 5.0
        
        return render
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // **************************************
    // ********* Set Time Part **************
    // **************************************
    @IBOutlet weak var minutePicker: UIPickerView!
    let minutes = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    var minuteChoice = 0
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return minutes[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
   
        return minutes.count
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minuteChoice = row+1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // ************************************************
    // ********** Submit to Server Part ****************
    // Submit data to server
    // including start time(current time), end time(current time+choosen time)
    //           start place, end place
    //           user ID
    // Time all in UTC format
    // Places all use coordinate(latitude & longitude)
    // ***********************************************
    @IBAction func clickStartButton(_ sender: UIButton) {
        // 10 digits UTC timestamp
        let startUTC = String(Int(NSDate().timeIntervalSince1970))
        let dateAfterMin = NSDate.init(timeIntervalSinceNow: (Double(minuteChoice) * 60.0))
        let endUTC = String(Int(dateAfterMin.timeIntervalSince1970))

        // start point
        let sourceLatitude = String(self.sourceLocation.latitude)
        let sourceLongitude = String(self.sourceLocation.longitude)


        // Generate request
        var strURL = "http://13.73.118.226/API/operations.php?func=newTask"
        var parameters = "&para1=\(startUTC)&para2=\(endUTC)&para3=\(sourceLatitude)&para4=\(sourceLongitude)&para5=\(String(self.destLatitude))&para6=\(String(self.destLongitude))&para7=\(sourceLatitude)&para8=\(sourceLongitude)&para9=\(startUTC)&para10=\(self.userid)"
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


        }
        task.resume()
        performSegue(withIdentifier: "setTask2Timer", sender: self)
   
    }
    
    func showChooseTimeAlert(){
        let alertControl = UIAlertController(title: "Can't set task!", message: "Please choose an arrival time", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertControl.addAction(okAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapSearchBar.delegate = self
        
        mapkitView.delegate = self
        mapkitView.showsScale = true
        mapkitView.showsPointsOfInterest = true
        mapkitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake((self.locationManager.location?.coordinate)!, span)
            
            mapkitView.setRegion(region, animated: true)
        }
        
        minutePicker.dataSource = self
        minutePicker.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTask2Timer"{
            var viewController = segue.destination as! TimerViewController
            viewController.userid = self.userid
            viewController.minuteChoice = self.minuteChoice
        }
    }
    

}
