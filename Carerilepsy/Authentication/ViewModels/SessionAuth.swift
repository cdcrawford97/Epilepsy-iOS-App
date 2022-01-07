//
//  SessionAuth.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 19/07/2021.
//

import Foundation
import Firebase


class SessionAuth : ObservableObject {
    
    @Published var isLoggedIn = true
    @Published var isPatientProfileCreated = true
    @Published var isClinicianProfileCreated = true
    var handle : AuthStateDidChangeListenerHandle?
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    func listenAuthentificationState() {
     
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                //You are logged in
                self.isLoggedIn = true
                
                // verifying account type
                if let user = user {
                    
                    let uid = user.uid
                    
                    // checking if profile is for patient
                    let patientRef = self.db.collection("patients").document(uid)

                    patientRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.isPatientProfileCreated = true
                            print("Patient profile exists")
                        } else {
                            self.isPatientProfileCreated = false
                            print("Patient profile does not exist")
                        }
                    }
                    
                    // checking if profile is for clinician
                    let clinicianRef = self.db.collection("clinicians").document(uid)

                    clinicianRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.isClinicianProfileCreated = true
                            print("Clinician profile exists")
                        } else {
                            self.isClinicianProfileCreated = false
                            print("Clinician profile does not exist")
                        }
                    }
                    
                }
            }
            else {
                //You are not logged in
                self.isLoggedIn = false
            }
        }
    }
    
}
