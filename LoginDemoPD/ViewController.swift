//
//  ViewController.swift
//  LoginDemoPD
//
//  Created by Hugo Juárez on 02/04/19.
//  Copyright © 2019 Hugo Juárez. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAPIGateway
import WebKit
import PDFKit

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    let api2 = api()
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
    
    
    
    // ViewController or application context . . .
    
    func doInvokeAPI() {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "POST"
        // change to any valid path you configured in the API
        let URLString = "/items"
        let queryStringParameters = ["key1":"{value1}"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let httpBody = "{ \n  " +
            "\"key1\":\"value1\", \n  " +
            "\"key2\":\"value2\", \n  " +
        "\"key3\":\"value3\"\n}"
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Create a service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1,
                                                           credentialsProvider: AWSMobileClient.sharedInstance())
     
        // Initialize the API client using the service configuration
        APICF4B1F1AApicfbfaClient.registerClient(withConfiguration: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient = APICF4B1F1AApicfbfaClient.client(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (task: AWSTask) -> Any? in
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: .utf8)
            
            print(responseString!)
            print(result.statusCode)
            
            return nil
        }
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
                                                                    self.doInvokeAPI()
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

