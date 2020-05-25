//
//  ViewLocationViewController.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class ViewLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let first = "VV"
//        let last = "CC"
//        let mediaURL = "sdsds"
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        annotation.title = "\(first) \(last)"
//        annotation.subtitle = mediaURL
//        self.mapView.addAnnotation(annotation)
        print("Hi")
    }
}
