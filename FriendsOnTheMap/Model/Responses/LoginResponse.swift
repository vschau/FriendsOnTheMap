//
//  LoginResponse.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

//{
//    "account": {
//    "registered": true,
//    "key": "45707299"
//    },
//    "session": {
//    "id": "0204934604S5158b168dffba614dfa5576069a728f2",
//    "expiration": "2020-05-25T21:23:57.003190Z"
//    }
//}

struct UdacityLoginResponse: Codable {
    let account: Account
    let session: Session
    
    
    enum CodingKeys:String, CodingKey {
        case account
        case session
    }
}

