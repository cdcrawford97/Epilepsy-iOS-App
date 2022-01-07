//
//  Patient.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 06/08/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
 
struct Patient: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var name: String
    var email: String
    var uuid: String
    @ServerTimestamp var createdAt: Timestamp?
}
