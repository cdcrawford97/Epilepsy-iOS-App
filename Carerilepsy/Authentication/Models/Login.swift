//
//  Login.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 19/07/2021.
//

import Foundation
import FirebaseFirestoreSwift
 
struct Login: Codable {
    
    var email: String
    var password: String
    var error: String
    var alert: Bool
   
}
