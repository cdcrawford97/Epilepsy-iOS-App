//
//  TreatmentsViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 18/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class TreatmentsViewModel: ObservableObject {
    
    @Published var treatments = [Treatment]()
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    private var listenerRegistration: ListenerRegistration?
    
    
    func fetchData() {
        
        if listenerRegistration == nil {
            
            let user = Auth.auth().currentUser
            
            if let user = user {
                    
                let uid = user.uid
                
                listenerRegistration = db.collection("patients").document(uid).collection("treatments").order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents treatments")
                        return
                    }
              
                    self.treatments = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Treatment.self)
                    }
                }
                
            }
            
        }
    }
}
