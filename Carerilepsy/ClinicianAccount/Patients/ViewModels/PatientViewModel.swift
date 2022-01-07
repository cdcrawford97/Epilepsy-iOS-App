//
//  PatientViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 06/08/2021.
//

import Foundation
import Firebase
import Combine

class PatientViewModel: ObservableObject {
    
    // MARK: - Public properties
    @Published var patient: Patient
    
    // MARK: - Internal properties
        
    init(patient: Patient = Patient(id: UUID().uuidString, name: "", email: "", uuid: UUID().uuidString)){
        self.patient = patient
    }
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    func addPatient(clinician: Clinician) {
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                
                let docRef = db.collection("patients").document(uid)
                docRef.getDocument { document, error in
                    if let error = error as NSError? {
                        print(error.localizedDescription)
                    }
                    else if let document = document {
                        do {
                            let data = document.data()
                            let name = data?["name"] as? String ?? ""
                            let email = data?["email"] as? String ?? ""
                            self.patient.name = name
                            self.patient.email = email
                            self.patient.uuid = document.documentID
                            
                            let _ = try self.db.collection("clinicians").document(clinician.uuid).collection("patients").addDocument(from: self.patient)
                        }
                        catch{
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func removePatients(patients: [Patient]) {
        for patient in patients {
            if let documentId = patient.id {
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    let uid = user.uid
                    db.collection("clinicians").document(uid).collection("patients").document(documentId).delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }

            }
        }
    }
    
    func removePatient(clinician: Clinician) {
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let docRef = db.collection("patients").document(uid)
                docRef.getDocument { document, error in
                    if let error = error as NSError? {
                        print(error.localizedDescription)
                    }
                    else if let document = document {
                        do {
                            let data = document.data()
                            let email = data?["email"] as? String ?? ""
                            
                            self.db.collection("clinicians").document(clinician.uuid).collection("patients").whereField("email", isEqualTo: email)
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            self.db.collection("clinicians").document(clinician.uuid).collection("patients").document(document.documentID).delete { error in
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
            }
        }
        
    }
    
    
}
