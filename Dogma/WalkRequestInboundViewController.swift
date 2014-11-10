//
//  WalkRequestInboundViewController.swift
//  Dogma
//
//  Created by Loren Heiman on 11/5/14.
//  Copyright (c) 2014 Kyle Pickering. All rights reserved.
//

import UIKit
import MapKit

class WalkRequestInboundViewController: UIViewController {

 
   
@IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var walkFeeField: UILabel!
    @IBOutlet weak var walkLocationField: UILabel!
    @IBOutlet weak var walkDurationField: UILabel!
    @IBOutlet weak var walkTimeField: UILabel!
    @IBOutlet weak var dogNameField: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    var pickupPlaceID: String!
    var walkerName: String!
    var test: String!
    
     var defaults = NSUserDefaults.standardUserDefaults()
    
    var firebaseRef = Firebase(url:"https://dogma.firebaseio.com")
    var walkDetailsRef = Firebase(url:"https://dogma.firebaseio.com/walkDetails")
    var dogDetailsRef = Firebase(url:"https://dogma.firebaseio.com/dogDetails")
    var walkStatusRef = Firebase(url:"https://dogma.firebaseio.com/walkStatus")
    var walkerDetailsRef = Firebase(url:"https://dogma.firebaseio.com/walkerDetails")
    
    var walkDetails = [
        "pickupPlaceID": "sldkgjsg",
        "walkDuration": "6 hours",
        "walkFee": "$22",
        "walkLocation": "Bolvia boo",
        "walkTime": "4:44pm"
    ]
    
    var walkerDetails = [
        "walkerImageURL" : "walkerImageURL",
        "walkerName" : "walkerImageURL"
    ]
    
    override func viewDidAppear(animated: Bool) {
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        walkerName = defaults.valueForKey("ownName") as String
        
        walkerDetails["walkerName"] = walkerName
        
        walkerDetailsRef.setValue(walkerDetails)
        
        /*
        firebaseRef.observeEventType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            self.walkDetails = snapshot.value.valueForKeyPath("walkDetails") as Dictionary
            println(self.walkDetails)
        })*/
        
        
        walkDetailsRef.observeEventType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            
            self.walkFeeField.text = snapshot.value.valueForKey("walkFee") as? String
            self.walkLocationField.text = snapshot.value.valueForKey("walkLocation") as? String
            self.defaults.setValue(self.walkLocationField.text, forKey: "walkLocation")
            self.walkDurationField.text = snapshot.value.valueForKey("walkDuration") as? String
            self.defaults.setValue(self.walkDurationField.text, forKey: "walkDuration")
            self.walkTimeField.text = snapshot.value.valueForKey("walkTime") as? String
            self.defaults.setValue(self.walkTimeField.text, forKey: "walkTime")
            self.pickupPlaceID = snapshot.value.valueForKey("pickupPlaceID") as? String
            
            
            var url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + self.pickupPlaceID + "&key=AIzaSyBR25mbykImkoIribmzpCFXLAuvPkfqCio")
            var request = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                var objects = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                var result = objects["result"] as NSDictionary
                var geometry = result["geometry"] as NSDictionary
                var locations = geometry["location"] as NSDictionary
                
                var lat = locations["lat"] as CLLocationDegrees
                var lng = locations["lng"] as CLLocationDegrees
                
                println("lat is \(lat)")
                println("long is \(lng)")
                
                var location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let span = MKCoordinateSpanMake(0.03, 0.03)
                let region = MKCoordinateRegion(center: location, span: span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.scrollEnabled = false
                self.mapView.zoomEnabled = false
                
                println("pickup location is \(location)")
                
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location)
                
                self.mapView.addAnnotation(annotation)
                
            }

           
        })
        
        
        
        dogDetailsRef.observeEventType(FEventType.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
            self.dogNameField.text = snapshot.value.valueForKey("dogName") as? String
            self.defaults.setValue(self.dogNameField.text, forKey: "dogName")
            
        })
        
        
        dogImage.layer.cornerRadius = dogImage.frame.size.width/2
        dogImage.clipsToBounds = true
       
    
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onAcceptWalkButtonTap(sender: AnyObject) {
        walkStatusRef.setValue("accepted")
    }

    
    
    
}
