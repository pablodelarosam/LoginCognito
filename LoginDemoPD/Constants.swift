//
//  Constants.swift
//  LoginDemoPD
//
//  Created by Hugo Juárez on 03/04/19.
//  Copyright © 2019 Hugo Juárez. All rights reserved.
//

import Foundation


struct Constants {
    
    static func storeUserName(username: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(username, forKeyPath: "username")
    }
    
    static func retrieveUserName() -> String? {
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.value(forKey: "username") as? String {
            return username
        }
        return ""
    }
    
}
