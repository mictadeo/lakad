//
//  LoginViewController.swift
//  Lakad
//
//  Created by Michael Tadeo on 7/18/19.
//  Copyright © 2019 Tadeo Man. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LegendViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var googleLabel: UILabel!
    
    let user = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLogin()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("Signed Out")
            checkUserLogin()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func checkUserLogin () {
        if Auth.auth().currentUser != nil {
            googleLoginButton.isHidden = true
            googleLabel.isHidden = true
            logoutButton.isHidden = false
        } else {
            googleLoginButton.isHidden = false
            googleLabel.isHidden = false
            logoutButton.isHidden = true
        }
    }
}

extension LegendViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential, completion: {(authResult, error) in
                if let error = error {
                    print ("Firebase sign in error")
                    print (error)
                    return
                }
                print("User is signed in")
                self.checkUserLogin()
            })
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
}
