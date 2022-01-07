//
//  PatientsViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 06/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class PatientsViewModel: ObservableObject {
    
    @Published var patients = [Patient]()
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    
    
    func fetchData() {
            
        let user = Auth.auth().currentUser
        
        if let user = user {
                
            let uid = user.uid
            
            db.collection("clinicians").document(uid).collection("patients").order(by: "createdAt").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
          
                self.patients = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Patient.self)
                }
            }
        }
        
    }
}
