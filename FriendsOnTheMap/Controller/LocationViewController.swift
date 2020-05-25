//
//  LocationViewController.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshstudentLocationList()
    }
    
    func refreshstudentLocationList() {
        MapClient.getStudentLocationList() { students, error in
            StudentLocationModel.studentLocationList = students
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.studentLocationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let student = StudentLocationModel.studentLocationList[(indexPath as NSIndexPath).row]

        // Set the name and image
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentLocationModel.studentLocationList[(indexPath as NSIndexPath).row]
        UIApplication.shared.open(URL(string: student.mediaURL)!, options: [:])
    }
    
    // MARK: - IBAction
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        refreshstudentLocationList()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        MapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
