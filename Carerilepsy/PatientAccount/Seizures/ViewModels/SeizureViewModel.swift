//
//  SeizureViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 01/08/2021.
//

import Foundation
import Firebase
import Combine

class SeizureViewModel: ObservableObject {
    
    
    // MARK: - Public properties
    
    @Published var seizure: Seizure
    @Published var modified = false

    // MARK: - Internal properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // ensures form with empty fields isn't submitted
    init(seizure: Seizure = Seizure(id: UUID().uuidString, dateTime: Date(), numberOf: 1, clusterOrSeizure: "Seizure", type: "", minutes: 0, seconds: 0, trigger: "None", rescueMed: "", remarks: "")){
        self.seizure = seizure
        
        self.$seizure
            .dropFirst()
            .sink { [weak self] seizure in
                self?.modified = true
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Firestore
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    private func addSeizure(seizure: Seizure) {
        do {
            
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let _ = try db.collection("patients").document(uid).collection("seizures").addDocument(from: seizure){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("seizure added")
                    }
                }
            }
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    private func updateSeizure(_ seizure: Seizure) {
        if let documentId = seizure.id {
            do {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    try db.collection("patients").document(uid).collection("seizures").document(documentId).setData(from: seizure){ err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("seizure updated")
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateOrAddSeizure() {
        if let _ = seizure.id {
            self.updateSeizure(self.seizure)
        }
        else {
            addSeizure(seizure: seizure)
        }
    }
    
    
    private func removeSeizure() {
        if let documentId = seizure.id {
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                
                db.collection("patients").document(uid).collection("seizures").document(documentId).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }

        }
    }
    
    // MARK: - UI handlers
    
    func save() {
        updateOrAddSeizure()
    }
    
    func handleDeleteTapped() {
        self.removeSeizure()
    }

    
}
