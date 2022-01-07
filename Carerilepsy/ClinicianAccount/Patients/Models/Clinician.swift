//
//  Clinician.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 05/08/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
 
struct Clinician: Identifiable, Codable {
    
    @DocumentID var id: String?
    var name: String
    var email: String
    var uuid: String
    var status: String
    @ServerTimestamp var createdAt: Timestamp?
}
