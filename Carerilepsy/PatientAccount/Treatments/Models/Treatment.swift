//
//  Treatment.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 18/07/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
 
struct Treatment: Identifiable, Encodable, Decodable {
    
    @DocumentID var id: String?
    var type: String
    var intake: String
    var name: String
    var dosage: String
    var dosageUnit: String
    var time: [Date]
    var startDate: Date
    var daily: Bool
    var days: [TreatmentDay]
    var comment: String
    @ServerTimestamp var createdAt: Timestamp?
   
}
