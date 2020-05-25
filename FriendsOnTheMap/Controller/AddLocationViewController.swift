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
    
    @IBAction func findTapped(_ sender: Any) {
        getCoordinate(addressString: "Dallas, TX", completionHandler: handleGeocodeResult)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    
    func handleGeocodeResult(success: CLLocationCoordinate2D, error: NSError?) {
        if error == nil {
//            performSegue(withIdentifier: "geocodeSegue", sender: nil)
//            CurrentLocation.latitude = success.latitude
//            CurrentLocation.longitude = success.longitude
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "viewLocation") as! ViewLocationViewController
            viewController.latitude = success.latitude
            viewController.longitude = success.longitude
            if let navigator = navigationController {
                DispatchQueue.main.async {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else {
            geocodeFailure(message: error?.localizedDescription ?? "")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? NotesListViewController {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                vc.notebook = notebook(at: indexPath)
//                // this line!!!
//                vc.dataController = dataController
//            }
//        }
//    }
    
    func geocodeFailure(message: String) {
        let alertVC = UIAlertController(title: "Geocoding Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
