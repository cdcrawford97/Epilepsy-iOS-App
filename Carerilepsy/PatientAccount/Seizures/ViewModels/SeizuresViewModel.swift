//
//  SeizuresViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 01/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class SeizuresViewModel: ObservableObject {
    
    @Published var seizures = [Seizure]()
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    
    
    func fetchData(dateRange: Range<Date>) {
            
        let user = Auth.auth().currentUser
        
        if let user = user {
                
            let uid = user.uid
            
            db.collection("patients").document(uid).collection("seizures").whereField("dateTime", isGreaterThan: dateRange.lowerBound).whereField("dateTime", isLessThan: dateRange.upperBound).order(by: "dateTime", descending: false).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
          
                self.seizures = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Seizure.self)
                }
            }
        }
        
    }
}

