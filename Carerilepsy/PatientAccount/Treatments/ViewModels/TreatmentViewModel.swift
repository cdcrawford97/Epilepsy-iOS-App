//
//  TreatmentViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 18/07/2021.
//

import Foundation
import Firebase
import Combine

class TreatmentViewModel: ObservableObject {
    
    
    // MARK: - Public properties
    
    @Published var treatment: Treatment
    @Published var modified = false

    // MARK: - Internal properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // ensures form with empty fields isn't submitted
    init(treatment: Treatment = Treatment(id: UUID().uuidString, type: "", intake: "", name: "", dosage: "", dosageUnit: "", time: [Date()], startDate: Date(), daily: true, days: [TreatmentDay(dayName: "Mon", toggleValue: true), TreatmentDay(dayName: "Tue", toggleValue: true), TreatmentDay(dayName: "Wed", toggleValue: true), TreatmentDay(dayName: "Thu", toggleValue: true), TreatmentDay(dayName: "Fri", toggleValue: true), TreatmentDay(dayName: "Sat", toggleValue: true), TreatmentDay(dayName: "Sun", toggleValue: true)], comment: "")){
        self.treatment = treatment
        
        self.$treatment
            .dropFirst()
            .sink { [weak self] treatment in
                self?.modified = true
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Firestore
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    private func addTreatment(treatment: Treatment) {
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                
                let _ = try db.collection("patients").document(uid).collection("treatments").addDocument(from: treatment){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("treatment added")
                    }
                }
            }
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    private func updateTreatment(_ treatment: Treatment) {
        if let documentId = treatment.id {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    try db.collection("patients").document(uid).collection("treatments").document(documentId).setData(from: treatment){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("treatment updated")
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateOrAddTreatment() {
        if let _ = treatment.id {
            self.updateTreatment(self.treatment)
        }
        else {
            addTreatment(treatment: treatment)
        }
    }
    
    
    private func removeTreatment() {
        if let documentId = treatment.id {
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                
                db.collection("patients").document(uid).collection("treatments").document(documentId).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }

        }
    }
    
    // MARK: - UI handlers
    
    func save() {
        updateOrAddTreatment()
    }
    
    func handleDeleteTapped() {
        self.removeTreatment()
    }

    
}
