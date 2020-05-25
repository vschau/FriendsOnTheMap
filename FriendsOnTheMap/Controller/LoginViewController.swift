//
//  LoginViewController.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signup: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignupLink()
    }

    @IBAction func loginTapped(_ sender: Any) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
//        MapClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse)
//        MapClient.login(username: "gnessa14@gmail.com", password: "aishiteru", completion: handleLoginResponse)
    }
    
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: Helpers
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setupSignupLink() {
        signup.delegate = self
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        attributedString.addAttribute(.link, value: "https://auth.udacity.com/sign-up?redirect_to=onthemap:authenticate", range: NSRange(location: 23, length: 7))
        signup.attributedText = attributedString
    }
    
    
}

