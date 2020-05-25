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
    
    var mapString: String!
    var mediaURL: String!
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addPin()
    }
    
    fileprivate func addPin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = mapString
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        MapClient.getUser(completion: handleGetUserResponse)
    }
    
    func handleGetUserResponse(userResponse: UserResponse?, error: Error?) {
        if let userResponse = userResponse {
            let locationRequest = LocationRequest(uniqueKey: userResponse.key,
                                   firstName: userResponse.firstName,
                                   lastName: userResponse.lastName,
                                   mapString: mapString,
                                   mediaURL: mediaURL,
                                   latitude: coordinate.latitude,
                                   longitude: coordinate.longitude)
            MapClient.createStudentLocation(locationRequest: locationRequest, completion: handleCreateStudentLocation)
        } else {
            createLocationFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleCreateStudentLocation(success: Bool, error: Error?) {
        if success {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            createLocationFailure(message: error?.localizedDescription ?? "")
        }
    }

    func createLocationFailure(message: String) {
        let controller = UIAlertController(title: "Unable to Create Location", message: "Please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}
