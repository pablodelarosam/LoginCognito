//
//  ViewController.swift
//  LoginDemoPD
//
//  Created by Hugo Juárez on 02/04/19.
//  Copyright © 2019 Hugo Juárez. All rights reserved.
//

import UIKit
import AWSMobileClient
import WebKit
import PDFKit

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Web view"
        AWSMobileClient.sharedInstance().getUserAttributes { (attributes, error) in
            print(attributes)
        }

    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        signIn()
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        AWSMobileClient.sharedInstance().signOut()
            signIn()
        

    }
    private func loadUI() {
        self.title = "Login demo"
    }
    
    private func signIn() {
        if AWSMobileClient.sharedInstance().isSignedIn{
            
        } else {
            guard let navController = self.navigationController else {
                return
            }
            AWSMobileClient.sharedInstance().showSignIn(navigationController: navController,
                                                        signInUIOptions: SignInUIOptions(
                                                            canCancel: false,
                                                            logoImage: UIImage(named: "iconVW"),
                                                            backgroundColor: UIColor.black)) {
                                                                (userState, error) in
                                                                
                                                                guard error == nil else {
                                                                    return
                                                                }
                                                                guard userState != nil else {
                                                                    return
                                                                }
                                                                
                                                                if userState == .signedIn {
                                                                    print("success")
                                                                    print(AWSMobileClient.sharedInstance().username ?? "no user name")
                                                                    
                                                                    if let user = AWSMobileClient.sharedInstance().username {
                                                                        Constants.storeUserName(username: user )
                                                                        self.usernameLabel.text = "Welcome, \(user ?? "")"


                                                                    }
                                                                }
            }
        }
    }


}

