//
//  SeizureStatistics.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 13/08/2021.
//

import Foundation
import Firebase
import Combine

class SeizureStatistics: ObservableObject {
    
    @Published var seizures = [Seizure]()
    @Published var monthSeizureCount: [Double] =  [0]
    @Published var seizureIncreasePerc: Int = 0
    
    private var listenerRegistration: ListenerRegistration?
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    func fetchData(dateRange: Range<Date>) {
        
        if listenerRegistration == nil {
            
            let user = Auth.auth().currentUser
            
            if let user = user {
                    
                let uid = user.uid
                
                listenerRegistration = db.collection("patients").document(uid).collection("seizures").whereField("dateTime", isGreaterThan: dateRange.lowerBound).whereField("dateTime", isLessThan: dateRange.upperBound).order(by: "dateTime", descending: false).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                
                    
                    self.seizures = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Seizure.self)
                    }
                    
                    self.calcMonthSeizureCount()
                    self.calcAverageSeizureIncrease()
                }
            }
        }
        
    }
    
    func fetchTempData(dateRange: Range<Date>, completion: @escaping ([Seizure]) -> Void ) {
            
            let user = Auth.auth().currentUser
            
            if let user = user {
                    
                let uid = user.uid
                
                listenerRegistration = db.collection("patients").document(uid).collection("seizures").whereField("dateTime", isGreaterThan: dateRange.lowerBound).whereField("dateTime", isLessThan: dateRange.upperBound).order(by: "dateTime", descending: false).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    
                    let seizureArray = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Seizure.self)
                    }
                    
                    completion(seizureArray)
                }
            }
            
        
        
    }
    
    
    func calcMonthSeizureCount() {
        
        var monthSeizureCount: [Double] = []
        
        for num in 0...29 {
            let endDate = Calendar.current.date(byAdding: DateComponents(day: -29 + num), to: Date().endOfDay())!
            let startDate = Calendar.current.date(byAdding: DateComponents(day: -30 + num), to: Date().endOfDay())!
            let newArray = self.seizures.filter{$0.dateTime > startDate && $0.dateTime < endDate}
            monthSeizureCount.append(Double(newArray.reduce(0) { $0 + $1.numberOf}))
        }
        
        self.monthSeizureCount = monthSeizureCount
        
    }
    
    func calcAverageSeizureIncrease() {
        
        fetchTempData(dateRange: Date().startOf30Days()..<Date().endOfDay()) { seizureArray in
            
            let seizuresLastMonth: [Seizure] = seizureArray
            
            self.fetchTempData(dateRange: Date().startOf60Days()..<Date().startOf30Days()){ seizureArray in
                
                let seizuresPreviousMonth: [Seizure] = seizureArray
                
                let lastMonthAverage = Double(seizuresLastMonth.reduce(0) { $0 + $1.numberOf})
                let previousMonthAverage = Double(seizuresPreviousMonth.reduce(0) { $0 + $1.numberOf})
                
                if previousMonthAverage == 0 {
                    self.seizureIncreasePerc = 0
                } else {
                    self.seizureIncreasePerc = Int (((lastMonthAverage - previousMonthAverage) / previousMonthAverage) * 100)
                }
            }
        }
    }
    
    
    
}
