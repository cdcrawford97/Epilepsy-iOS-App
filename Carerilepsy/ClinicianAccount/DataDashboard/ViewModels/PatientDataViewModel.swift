//
//  SeizureDataViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 11/08/2021.
//

import Foundation
import Firebase
import Combine
import SwiftUI

//MARK:- Pie Chart Data
struct ChartData {
    var id = UUID()
    var color : Color
    var percent : CGFloat
    var value : CGFloat
    var label: String
    
}

class PatientDataViewModel: ObservableObject {
    
    @Published var seizures = [Seizure]()
    @Published var seizureCount: [Int] =  [0, 0, 0, 0, 0, 0, 0]
    @Published var monthSeizureCountFirstHalf: [Int] =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var monthSeizureCountSecondHalf: [Int] =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var yearSeizureCountFirstHalf: [Int] =  [0, 0, 0, 0, 0, 0]
    @Published var yearSeizureCountSecondHalf: [Int] =  [0, 0, 0, 0, 0, 0]
    @Published var averageSeizureDurationMinutes: Int = 0
    @Published var averageSeizureDurationSeconds: Int = 0
    @Published var chartData = [ChartData(color: Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1)), percent: 50, value: 0, label: "")]
    var secondPickerSelection: Int = 0
    
    // Initializing instance of Cloud Firestore
    private var db = Firestore.firestore()
    
    
    
    func fetchData(patient: Patient, dateRange: Range<Date>, secondSelectedPicker: Int) {
        
        let uid = patient.uuid
        
        let secondSelectedPickerValue = secondSelectedPicker
        
        db.collection("patients").document(uid).collection("seizures").whereField("dateTime", isGreaterThan: dateRange.lowerBound).whereField("dateTime", isLessThan: dateRange.upperBound).order(by: "dateTime", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.seizures = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Seizure.self)
            }
            
            self.calcWeekSeizureCount()
            self.calcAvgSeizureDuration()
            self.calcChartData(secondSelectedPicker: secondSelectedPickerValue)
            self.calcMonthSeizureCount()
            self.calcYearSeizureCount()
        }
    }
    
    
    func calcWeekSeizureCount() {
        
        var seizureCount: [Int] = []
        for num in 0...6 {
            let endDate = Calendar.current.date(byAdding: DateComponents(day: -6 + num), to: Date().endOfDay())!
            let startDate = Calendar.current.date(byAdding: DateComponents(day: -7 + num), to: Date().endOfDay())!
            let newArray = self.seizures.filter{$0.dateTime > startDate && $0.dateTime < endDate}
            seizureCount.append(newArray.reduce(0) { $0 + $1.numberOf})
        }
        self.seizureCount = seizureCount
        
    }
    
    
    
    func calcMonthSeizureCount() {
        
        var monthSeizureCountFirstHalf: [Int] = []
        var monthSeizureCountSecondHalf: [Int] = []
        
        for num in 0...14 {
            let endDate = Calendar.current.date(byAdding: DateComponents(day: -29 + num), to: Date().endOfDay())!
            let startDate = Calendar.current.date(byAdding: DateComponents(day: -30 + num), to: Date().endOfDay())!
            let newArray = self.seizures.filter{$0.dateTime > startDate && $0.dateTime < endDate}
            monthSeizureCountFirstHalf.append(newArray.reduce(0) { $0 + $1.numberOf})
        }
        
        self.monthSeizureCountFirstHalf = monthSeizureCountFirstHalf
        
        for num in 0...14 {
            let endDate = Calendar.current.date(byAdding: DateComponents(day: -14 + num), to: Date().endOfDay())!
            let startDate = Calendar.current.date(byAdding: DateComponents(day: -15 + num), to: Date().endOfDay())!
            let newArray = self.seizures.filter{$0.dateTime > startDate && $0.dateTime < endDate}
            monthSeizureCountSecondHalf.append(newArray.reduce(0) { $0 + $1.numberOf})
        }
    
        self.monthSeizureCountSecondHalf = monthSeizureCountSecondHalf
        
    }
    
    func calcYearSeizureCount() {
        
        var yearSeizureCountFirstHalf: [Int] = []
        var yearSeizureCountSecondHalf: [Int] = []
        for num in 0...5 {
            let endDate = Calendar.current.date(byAdding: DateComponents(month: num + 1, day: -1), to: Date().startOfYear())!
            let startDate = Calendar.current.date(byAdding: DateComponents(month: num), to: Date().startOfYear())!
            let newArray = self.seizures.filter{$0.dateTime > startDate && $0.dateTime < endDate}
            yearSeizureCountFirstHalf.append(newArray.reduce(0) { $0 + $1.numberOf})
        }
        
        self.yearSeizureCountFirstHalf = yearSeizureCountFirstHalf
        
        for num in 0...5 {
            let endDate = Calendar.current.date(byAdding: DateComponents(month: num + 7, day: -1), to: Date().startOfYear())!
            let startDate = Calendar.current.date(byAdding: DateComponents(month: num + 6), to: Date().startOfYear())!
            let newArray = self.seizures.filter{$0.dateTime > startDate && $0.dateTime < endDate}
            yearSeizureCountSecondHalf.append(newArray.reduce(0) { $0 + $1.numberOf})
        }
    
        self.yearSeizureCountSecondHalf = yearSeizureCountSecondHalf
        
    }
    
    
    
    func calcChartData(secondSelectedPicker: Int) {
        
        let colors = [Color(#colorLiteral(red: 0.337254902, green: 0.2666666667, blue: 0.5843137255, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4980392157, blue: 0.3647058824, alpha: 1)), Color(#colorLiteral(red: 0.3843137255, green: 0.7058823529, blue: 0.4980392157, alpha: 1)), Color(#colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))]
        
        
        let total = Double(seizures.count)
        
        let myGroup = DispatchGroup()
        
        let groups = Dictionary(grouping: self.seizures, by: { secondSelectedPicker == 0 ? $0.trigger : $0.type })
        var index = 0
        var pieChartData: [ChartData] = []
        for group in groups {
            myGroup.enter()
            // calculateing percent value
            let count = Double(groups[group.key]!.count)
            let percent: CGFloat = CGFloat(Double(count/total)*100.0)
            pieChartData.append(ChartData(color: colors[index], percent: percent, value: 0, label: group.key))
            index += 1
            myGroup.leave()
        }
        
        myGroup.notify(queue: .main) {
            self.chartData = pieChartData
            
            var value : CGFloat = 0
            
            for i in 0..<self.chartData.count {
                value += self.chartData[i].percent
                self.chartData[i].value = value
            }
        }
    
        
    }
    
    func calcAvgSeizureDuration() {
        
        var sumSeconds: Double = 0
        for seizure in seizures {
            sumSeconds += Double(seizure.minutes * 60 + seizure.seconds)
        }
        
        if self.seizures.count == 0 {
            self.averageSeizureDurationMinutes = 0
            self.averageSeizureDurationSeconds = 0
        } else {
            let avgDurationInSeconds = Int( sumSeconds / Double(self.seizures.count) )
            self.averageSeizureDurationMinutes = Int(avgDurationInSeconds / 60)
            self.averageSeizureDurationSeconds = avgDurationInSeconds % 60
        }
        
    }
    
    
    
}
