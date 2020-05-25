//
//  StudentLocation.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

extension StudentLocation {
    var url: String {
        if (!mediaURL.hasPrefix("http") && !mediaURL.hasPrefix("https")) {
            return "https://\(mediaURL)"
        } else {
            return ""
        }
    }
}
