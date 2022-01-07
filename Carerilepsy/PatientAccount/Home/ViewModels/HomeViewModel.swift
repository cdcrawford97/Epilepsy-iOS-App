//
//  HomeViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 25/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var treatmentTimes = [TreatmentTime]()
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    private var listenerRegistration: ListenerRegistration?
    
    
    private func fetchData(completion: @escaping ([Treatment]) -> Void) {
        
        if listenerRegistration == nil {
            
            let user = Auth.auth().currentUser
            
            if let user = user {
                    
                let uid = user.uid
                
                listenerRegistration = db.collection("patients").document(uid).collection("treatments").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    let treatmentArray = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Treatment.self)
                    }
                    
                    completion(treatmentArray)
                    
                }

            }
        }
    }
    
    func createTreatmentTimes() {
        
        fetchData { treatments in
            
            self.treatmentTimes.removeAll()
            var array: [TreatmentTime] = []
            
            for treatment in treatments {
                
                if treatment.startDate < Date().endOfDay() {
                    let weekday = Date().shortDayDate()
                    if treatment.daily {
                        for time in treatment.time {
                            array.append(TreatmentTime(name: treatment.name, dosage: "\(treatment.dosage) \(treatment.dosageUnit)", time: time))
                        }
                    }
                    else {
                        for day in treatment.days {
                            if day.toggleValue {
                                if weekday == day.dayName {
                                    for time in treatment.time {
                                        array.append(TreatmentTime(name: treatment.name, dosage: "\(treatment.dosage) \(treatment.dosageUnit)", time: time))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.treatmentTimes = array.sorted(by: { $0.time.compare($1.time) == .orderedAscending})
            
        }
        
        
    }
    
    
    

}
