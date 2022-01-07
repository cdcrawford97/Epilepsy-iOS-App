//
//  CliniciansViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 05/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class CliniciansViewModel: ObservableObject {
    
    @Published var clinicians = [Clinician]()
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    func fetchData() {
            
        let user = Auth.auth().currentUser
        
        if let user = user {
                
            let uid = user.uid
            
            db.collection("patients").document(uid).collection("clinicians").order(by: "createdAt").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
          
                self.clinicians  = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Clinician.self)
                }
            }
        }
        
    }
}
