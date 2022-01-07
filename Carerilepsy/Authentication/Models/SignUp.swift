//
//  User.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 19/07/2021.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift
 
struct SignUp: Codable {
    
    var email: String
    var password: String
    var retypePassword: String
    var error: String
    var alert: Bool
   
}
