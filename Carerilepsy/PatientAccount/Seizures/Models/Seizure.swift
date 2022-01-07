//
//  Seizure.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 01/08/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
 
struct Seizure: Identifiable, Codable {
    
    @DocumentID var id: String?
    var dateTime: Date
    var numberOf: Int
    var clusterOrSeizure: String
    var type: String
    var minutes: Int
    var seconds: Int
    var trigger: String
    var rescueMed: String
    var remarks: String
    @ServerTimestamp var createdAt: Timestamp?
   
}
