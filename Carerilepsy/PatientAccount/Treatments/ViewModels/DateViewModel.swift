//
//  DateViewModel.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 15/08/2021.
//

import Foundation
import SwiftUI

class DateViewModel: ObservableObject {
    
    @Published var selectedDate = Date()
    @Published var showPicker = false
    @Published var hour: Int = 12
    @Published var minutes: Int = 0
    
    // Switching between hrs and mins
    @Published var changeToMin = false
    // AM or PM
    @Published var symbol = "AM"
    // angle
    @Published var angle : Double = 0
    
    func generateTime() {
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        let correctHourValue = symbol == "AM" ? hour : hour + 12
        
        let date = format.date(from: "\(correctHourValue):\(minutes)")
        
        self.selectedDate = date!
        
        withAnimation{
            showPicker.toggle()
        }
        
    }
    
    func setTime(date: Date) {
        
        changeToMin = false
        let calendar = Calendar.current
        
        hour = calendar.component(.hour, from: date)
        symbol = hour <= 12 ? "AM" : "PM"
        hour = hour == 0 ? 12 : hour
        hour = hour <= 12 ? hour : hour - 12
        
        minutes = calendar.component(.minute, from: date)
        angle = Double(hour * 30)
    }
    
}
