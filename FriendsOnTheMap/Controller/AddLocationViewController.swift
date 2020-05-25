//
//  AddLocationViewController.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTextField.text = ""
        linkTextField.text = ""
    }
    
    // MARK: - IBAction
    @IBAction func findTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        getCoordinate(addressString: locationTextField.text!)
    }
    
    func getCoordinate(addressString : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.coordinate = placemark.location!.coordinate
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "viewLocation", sender: nil)
                    }
                }
            } else {
                self.geocodeFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewLocationViewController {
            viewController.mapString = locationTextField.text
            viewController.mediaURL = linkTextField.text
            viewController.coordinate = coordinate
        }
    }
    
    func geocodeFailure(message: String) {
        let controller = UIAlertController(title: "Unable to Find Location", message: "Please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
    }
}
