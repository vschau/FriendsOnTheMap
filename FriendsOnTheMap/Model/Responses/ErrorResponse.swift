//
//  ErrorResponse.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let status: Int
    let error: String
}
