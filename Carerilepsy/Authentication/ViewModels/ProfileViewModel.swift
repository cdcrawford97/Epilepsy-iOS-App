//
//  ProfileViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 20/07/2021.
//

import Foundation
import Firebase
import Combine

class ProfileViewModel: ObservableObject {
    
    @Published var patientProfile: PatientProfile
    @Published var clinicianProfile: ClinicianProfile
    
    private var listenerRegistration: ListenerRegistration?
    
    init(profile: PatientProfile = PatientProfile(name: "", email: ""), profile2: ClinicianProfile = ClinicianProfile(name: "", email: "")){
        self.patientProfile = profile
        self.clinicianProfile = profile2
    }
    
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    private func addPatientProfile(profile: PatientProfile) {
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                patientProfile.email = user.email!
                
                let _ = try db.collection("patients").document(uid).setData(from: patientProfile) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Patient profile created")
                    }
                }
                
            }
                
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    private func addClinicianProfile(profile: ClinicianProfile) {
        
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                clinicianProfile.email = user.email!
                
                let _ = try db.collection("clinicians").document(uid).setData(from: clinicianProfile) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Clinician profile created")
                    }
                }
            }
                
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchPatientProfileData() {
        
        
        
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
                        self.patientProfile.name = name
                    }
                }
            }
        }
    }
    
    func fetchClinicianProfileData() {
        
        if listenerRegistration == nil {
            
            let user = Auth.auth().currentUser
            
            if let user = user {
                
                let uid = user.uid
                
                db.collection("clinicians").document(uid).getDocument { document, error in
                    if let error = error as NSError? {
                        print(error.localizedDescription)
                    }
                    else if let document = document {
                        do {
                            let data = document.data()
                            let name = data?["name"] as? String ?? ""
                            self.clinicianProfile.name = name
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UI handlers
    
    func savePatient() {
        addPatientProfile(profile: self.patientProfile)
    }
    
    func saveClinician() {
        addClinicianProfile(profile: self.clinicianProfile)
    }
    
}
