//
//  PatientViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 05/08/2021.
//

import Foundation
import Firebase
import Combine

enum ActiveAlert {
    case success, failure
}

class ClinicianViewModel: ObservableObject {
    
    // MARK: - Public properties
    @Published var clinician: Clinician
    @Published var email: String = ""
    @Published var showAlert: Bool
    @Published var activeAlert: ActiveAlert = .success
    
    // MARK: - Internal properties
        
    init(clinician: Clinician = Clinician(id: UUID().uuidString, name: "", email: "", uuid: UUID().uuidString, status: "Pending")){
        self.clinician = clinician
        showAlert = false
    }
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    private func addClinician() {
        db.collection("patients").whereField("email", isEqualTo: self.email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if querySnapshot!.documents.isEmpty {
                    print("Patient email \(self.email) does not exist")
                    self.showAlert = true
                    self.activeAlert = .failure
                }
                else {
                    for document in querySnapshot!.documents {
                        let patientId = document.documentID
                        do {
                            let user = Auth.auth().currentUser
                            if let user = user {
                                
                                let docRef = self.db.collection("clinicians").document(user.uid)
                                docRef.getDocument { document, error in
                                    if let error = error as NSError? {
                                        print(error.localizedDescription)
                                    }
                                    else if let document = document {
                                        do {
                                            // assigning names
                                            let data = document.data()
                                            let name = data?["name"] as? String ?? ""
                                            self.clinician.name = name
                                            
                                            // assigning other fields
                                            self.clinician.email = user.email!
                                            self.clinician.uuid = user.uid

                                            let _ = try self.db.collection("patients").document(patientId).collection("clinicians").addDocument(from: self.clinician) { err in
                                                if let error = error as NSError? {
                                                    print(error.localizedDescription)
                                                }
                                                else {
                                                    print("Patient email exists, successfully sent request")
                                                    self.showAlert = true
                                                    self.activeAlert = .success
                                                }
                                            }
                             
                                        }
                                        catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    private func updateClinician(_ clinicican: Clinician) {
        if let documentId = clinician.id {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    try db.collection("patients").document(uid).collection("clinicians").document(documentId).setData(from: clinician)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeClinicians(clinicians: [Clinician]) {
        for clinician in clinicians {
            if let documentId = clinician.id {
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    let uid = user.uid
                    
                    db.collection("patients").document(uid).collection("clinicians").document(documentId).delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func removeClinician(patient: Patient) {
        
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                let email = user.email
                self.db.collection("patients").document(patient.uuid).collection("clinicians").whereField("email", isEqualTo: email!)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                self.db.collection("patients").document(patient.uuid).collection("clinicians").document(document.documentID).delete { error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
    }
    
    
    

    
    // MARK: - UI handlers
    
    func save() {
        addClinician()
    }
    
    func update() {
        updateClinician(self.clinician)
    }
    
    

}
