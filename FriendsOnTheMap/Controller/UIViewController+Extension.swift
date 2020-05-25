//
//  UIViewController+Extension.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func logout(_ sender: UIBarButtonItem) {
        MapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
