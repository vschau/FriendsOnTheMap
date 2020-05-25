//
//  LoginRequest.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

struct LoginInfo: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: LoginInfo
}


