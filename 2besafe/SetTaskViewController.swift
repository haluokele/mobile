//
//  SetTaskViewController.swift
//  2besafe
//
//  Created by Yaojia on 1/10/17.
//  Copyright © 2017 Yaojia. All rights reserved.
//

import UIKit
import MapKit

class SetTaskViewController: UIViewController,UISearchBarDelegate,MKMapViewDelegate, CLLocationManagerDelegate {
    var userid = String()

    @IBOutlet var mapSearchBar: UISearchBar!
    
    @IBOutlet weak var mapkitView: MKMapView!
    
    var destLatitude = CLLocationDegrees()
    var destLongitude = CLLocationDegrees()
    
    let locationManager = CLLocationManager()
    
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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
                let sourceLocation = self.locationManager.location?.coordinate
                let destLocation = CLLocationCoordinate2DMake(self.destLatitude, self.destLongitude)
                
                let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
